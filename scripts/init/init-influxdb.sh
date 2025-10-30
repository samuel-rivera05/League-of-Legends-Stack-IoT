#!/bin/bash
set -e

echo "Creating API token..."

TOKEN=$(influx auth create \
  --org "${INFLUXDB_ORG}"\
  --description "Read-write token" \
  --read-buckets \
  --write-buckets \
  --token "${DOCKER_INFLUXDB_INIT_ADMIN_TOKEN}" \
  --json | awk -F'"' '/"token":/{print $4}')

if [ -n "$TOKEN" ]; then
    echo "$TOKEN" > /shared/api-token.txt
    echo "Token saved successfully"
else
    echo "Error: Failed to create token"
    exit 1
fi
