#!/bin/bash
# init-buckets.sh

set -e

echo "Esperando a que InfluxDB esté completamente inicializado..."

# Esperar a que InfluxDB esté listo
until influx ping &>/dev/null; do
    echo "Esperando InfluxDB..."
    sleep 2
done

echo "InfluxDB está listo. Creando buckets adicionales..."

# Variables desde entorno
ORG="${INFLUXDB_ORG}"
TOKEN="${DOCKER_INFLUXDB_INIT_ADMIN_TOKEN}"
BUCKET2="${INFLUXDB_BUCKET_2:-SecondBucket}"

# Crear segundo bucket
echo "Creando bucket: $BUCKET2"
influx bucket create \
    --name "$BUCKET2" \
    --org "$ORG" \
    --retention 0 \
    --token "$TOKEN" || echo "Bucket $BUCKET2 ya existe o error al crear"


echo "Buckets adicionales creados."

# Listar todos los buckets
echo "Buckets disponibles:"
influx bucket list --org "$ORG" --token "$TOKEN"