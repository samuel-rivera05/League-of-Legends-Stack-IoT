#!/bin/bash

set -e

echo "=== Configuración de InfluxDB, Node-RED y Grafana ==="
echo ""

# Crear estructura de directorios
mkdir -p grafana/provisioning/datasources
mkdir -p grafana/provisioning/dashboards

echo "Directorios creados"
echo ""

# Crear configuración de datasource para Grafana
cat > grafana/provisioning/datasources/influxdb.yml <<'EOF'
apiVersion: 1

datasources:
  - name: InfluxDB
    type: influxdb
    access: proxy
    url: http://influxdb:8086
    jsonData:
      version: Flux
      organization: Somorrostro
      defaultBucket: PruebaReto0-2
      tlsSkipVerify: true
    secureJsonData:
      token: my-super-secret-admin-token
    editable: true
    isDefault: true
EOF

echo "Datasource de InfluxDB configurado"
echo ""

# Crear configuración de dashboards provider
cat > grafana/provisioning/dashboards/dashboards.yml <<'EOF'
apiVersion: 1

providers:
  - name: 'Default'
    orgId: 1
    folder: ''
    type: file
    disableDeletion: false
    updateIntervalSeconds: 10
    allowUiUpdates: true
    options:
      path: /etc/grafana/provisioning/dashboards
EOF

echo "Configuración de dashboards creada"
echo ""

# Crear README
cat > README.md <<'EOF'
# Stack completo: InfluxDB + Node-RED + Grafana + Riot Collector

## Servicios

- **InfluxDB** (puerto 8086): Base de datos de series temporales
- **Grafana** (puerto 3000): Visualización y dashboards
- **Node-RED** (puerto 1881): Automatización y flujos
- **Riot Collector**: Recolector de datos de Riot API

## Inicio rápido

### Iniciar todos los servicios
```bash
docker-compose up -d
```

### Recolectar datos de Riot
```bash
docker-compose run --rm riot-collector
```

## Acceso a los servicios

### InfluxDB
- URL: http://localhost:8086
- Usuario: admin
- Contraseña: mipassword123
- Organización: Somorrostro
- Bucket: PruebaReto0-2
- Token: my-super-secret-admin-token

### Grafana
- URL: http://localhost:3000
- Usuario: admin
- Contraseña: admin
- Datasource: InfluxDB (preconfigurado)

### Node-RED
- URL: http://localhost:1881
- Nodos de InfluxDB preinstalados

## Crear visualizaciones en Grafana

1. Accede a http://localhost:3000
2. Login con admin/admin
3. Ve a Dashboards > New Dashboard
4. Add visualization
5. El datasource InfluxDB ya está configurado
6. Usa Flux query para consultar datos

### Ejemplo de query Flux para datos de Riot:

```flux
from(bucket: "PruebaReto0-2")
  |> range(start: -7d)
  |> filter(fn: (r) => r["_measurement"] == "lol_matches")
  |> filter(fn: (r) => r["_field"] == "kills" or r["_field"] == "deaths" or r["_field"] == "assists")
  |> aggregateWindow(every: 1h, fn: mean, createEmpty: false)
```

## Comandos útiles

### Ver logs
```bash
docker-compose logs -f
docker-compose logs -f grafana
docker-compose logs -f influxdb
```

### Reiniciar servicios
```bash
docker-compose restart
```

### Detener todo
```bash
docker-compose down
```

### Eliminar datos (CUIDADO)
```bash
docker-compose down -v
```

## Personalización

### Cambiar credenciales de Grafana
Edita el archivo `.env`:
```
GRAFANA_ADMIN_USER=tu_usuario
GRAFANA_ADMIN_PASSWORD=tu_password
```

### Añadir plugins a Grafana
Edita `docker-compose.yml` en la sección de grafana:
```yaml
environment:
  - GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-simple-json-datasource
```

### Importar dashboards
1. Crea archivos JSON en `grafana/provisioning/dashboards/`
2. Reinicia Grafana: `docker-compose restart grafana`

## Estructura del proyecto

```
.
├── docker-compose.yml
├── .env
├── Dockerfile.nodered
├── Dockerfile.python
├── requirements.txt
├── riot_collector.py
├── grafana/
│   └── provisioning/
│       ├── datasources/
│       │   └── influxdb.yml
│       └── dashboards/
│           └── dashboards.yml
└── README.md
```

## Troubleshooting

### Grafana no se conecta a InfluxDB
- Verifica que InfluxDB esté corriendo: `docker ps`
- Verifica el token en `grafana/provisioning/datasources/influxdb.yml`
- Revisa logs: `docker-compose logs grafana`

### No aparecen datos en Grafana
- Ejecuta el collector primero: `docker-compose run --rm riot-collector`
- Verifica que los datos estén en InfluxDB: http://localhost:8086
- Ajusta el rango de tiempo en Grafana

### Error de permisos en volúmenes
```bash
sudo chown -R 472:472 grafana/
```
EOF

echo "README.md creado"
echo ""

echo "=== Configuración completada ==="
echo ""
echo "Estructura de archivos creada:"
echo "  - docker-compose.yml"
echo "  - .env"
echo "  - grafana/provisioning/datasources/influxdb.yml"
echo "  - grafana/provisioning/dashboards/dashboards.yml"
echo ""
echo "Para iniciar todos los servicios:"
echo "  docker-compose up -d"
echo ""
echo "Acceso a servicios:"
echo "  InfluxDB: http://localhost:8086 (admin/mipassword123)"
echo "  Grafana:  http://localhost:3000 (admin/admin)"
echo "  Node-RED: http://localhost:1881"
echo ""
echo "Para recolectar datos de Riot:"
echo "  docker-compose run --rm riot-collector"