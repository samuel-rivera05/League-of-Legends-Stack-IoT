# =========================
# Librerías
# =========================
import requests
import os
import datetime
import pandas as pd
from influxdb_client import InfluxDBClient, Point, WritePrecision
import time # Importamos la librería time para poder hacer pausas

# =========================
# Configuración Riot API
# =========================
API_KEY = os.getenv("RIOT_API_KEY")
GAME_NAME = os.getenv("RIOT_GAME_NAME", "Messi GOAT")
TAG_LINE = os.getenv("RIOT_TAG_LINE", "4968")
ROUTING = os.getenv("RIOT_ROUTING", "europe")

headers = {"X-Riot-Token": API_KEY}

# Configuración InfluxDB
url = os.getenv("INFLUXDB_URL", "http://influxdb:8086")
token = os.getenv("INFLUXDB_TOKEN")
org = os.getenv("INFLUXDB_ORG")
bucket = os.getenv("INFLUXDB_BUCKET")

client = InfluxDBClient(url=url, token=token, org=org)
write_api = client.write_api()

# =========================
# Funciones API Riot
# =========================
def get_puuid(game_name, tag_line):
    url = f"https://{ROUTING}.api.riotgames.com/riot/account/v1/accounts/by-riot-id/{game_name}/{tag_line}"
    resp = requests.get(url, headers=headers)
    if resp.status_code != 200:
        print("Error al obtener PUUID:", resp.status_code, resp.json())
        return None
    return resp.json()["puuid"]

def get_match_history(puuid, count=10): # Pedimos menos partidas, solo las más recientes
    url = f"https://{ROUTING}.api.riotgames.com/lol/match/v5/matches/by-puuid/{puuid}/ids?count={count}"
    resp = requests.get(url, headers=headers)
    if resp.status_code != 200:
        print("Error al obtener historial:", resp.status_code, resp.json())
        return []
    return resp.json()

def get_match_details(match_id):
    url = f"https://{ROUTING}.api.riotgames.com/lol/match/v5/matches/{match_id}"
    resp = requests.get(url, headers=headers)
    if resp.status_code != 200:
        print(f"Error al obtener detalles de {match_id}:", resp.status_code, resp.json())
        return None
    return resp.json()

# =========================
# Flujo principal
# =========================
print("Obteniendo PUUID...")
puuid = get_puuid(GAME_NAME, TAG_LINE)
if not puuid:
    raise Exception("No se pudo obtener el PUUID")
print(f"PUUID encontrado: {puuid}\n")

# Usaremos un "set" para guardar los IDs de las partidas que ya hemos procesado
# Es mucho más rápido que una lista para comprobar si un elemento ya existe.
processed_match_ids = set()

print("Iniciando monitoreo de partidas en tiempo real...")

try:
    while True:
        print(f"[{datetime.datetime.now()}] Buscando nuevas partidas...")

        # 1. Obtenemos las últimas partidas
        match_ids = get_match_history(puuid, count=5) # Pedimos solo las últimas 5 para ser eficientes

        if not match_ids:
            print("No se encontraron partidas recientes.")
        else:
            for match_id in reversed(match_ids): # Revertimos la lista para procesar las más antiguas primero

                # 2. Comprobamos si la partida ya ha sido procesada
                if match_id not in processed_match_ids:
                    print(f"  -> Nueva partida encontrada: {match_id}")

                    # 3. Obtenemos los detalles de la nueva partida
                    match_data = get_match_details(match_id)
                    if not match_data:
                        continue

                    info = match_data["info"]
                    duration_min = info["gameDuration"] // 60
                    fecha = datetime.datetime.fromtimestamp(info["gameStartTimestamp"]/1000)
                    modo = info["gameMode"]

                    # 4. Procesamos y enviamos los datos de cada participante a InfluxDB
                    for p in info["participants"]:
                        point = (
                            Point("lol_matches")
                            .tag("jugador", p.get("riotIdGameName", p.get("summonerName", "Unknown")))
                            .tag("campeon", p["championName"])
                            .tag("modo", modo)
                            .tag("resultado", "Win" if p["win"] else "Lose")
                            .tag("role", p["individualPosition"])
                            .tag("teamId", str(p["teamId"]))
                            .field("kills", int(p["kills"]))
                            .field("deaths", int(p["deaths"]))
                            .field("assists", int(p["assists"]))
                            .field("visionScore", int(p["visionScore"]))
                            .field("goldEarned", int(p["goldEarned"]))
                            .field("duracion_min", int(duration_min))
                            .time(fecha, WritePrecision.NS)
                        )
                        write_api.write(bucket=bucket, org=org, record=point)

                    print(f"  -> Datos de la partida {match_id} enviados a InfluxDB.")

                    # 5. Añadimos el ID de la partida al conjunto para no volver a procesarla
                    processed_match_ids.add(match_id)

        # 6. Esperamos un tiempo antes de la próxima comprobación
        # Se recomienda un tiempo de espera de 1-2 minutos para no exceder los límites de la API de Riot
        sleep_interval = 120 # 120 segundos = 2 minutos
        print(f"Esperando {sleep_interval} segundos para la próxima comprobación...")
        time.sleep(sleep_interval)

except KeyboardInterrupt:
    print("\nProceso interrumpido por el usuario.")
finally:
    client.close()
    print("Cliente de InfluxDB cerrado.")