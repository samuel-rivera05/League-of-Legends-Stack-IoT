#!/bin/bash
echo "Iniciando InfluxDB y Node-RED..."
docker compose up -d --build
echo ""
echo "Servicios iniciados"
echo ""
echo "InfluxDB: http://localhost:8086"
echo "Node-RED: http://localhost:1880"
