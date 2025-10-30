#!/bin/bash
# sqlserver/init.sh

set -e

SA_PASSWORD="${SA_PASSWORD}"
SCRIPTS_DIR="/docker-entrypoint-initdb.d"

# Detectar la ruta de sqlcmd (cambia entre versiones de SQL Server)
if [ -f "/opt/mssql-tools18/bin/sqlcmd" ]; then
    SQLCMD="/opt/mssql-tools18/bin/sqlcmd"
    SQLCMD_OPTS="-C"  # Confiar en certificado (SQL Server 2022+)
elif [ -f "/opt/mssql-tools/bin/sqlcmd" ]; then
    SQLCMD="/opt/mssql-tools/bin/sqlcmd"
    SQLCMD_OPTS=""
else
    echo "Error: sqlcmd no encontrado"
    exit 1
fi

echo "Usando sqlcmd: $SQLCMD"
echo "Esperando a que SQL Server esté completamente listo..."

# Esperar a que SQL Server acepte conexiones
for i in {1..50}; do
    if $SQLCMD -S localhost -U sa -P "$SA_PASSWORD" $SQLCMD_OPTS -Q "SELECT 1" &>/dev/null; then
        echo "SQL Server está listo para aceptar conexiones"
        break
    fi
    echo "Esperando... intento $i/50"
    sleep 2
done

# Ejecutar todos los scripts .sql en orden
if [ -d "$SCRIPTS_DIR" ]; then
    echo "Buscando scripts SQL en $SCRIPTS_DIR..."
    
    for script in $(find "$SCRIPTS_DIR" -name "*.sql" | sort); do
        echo "Ejecutando script: $script"
        
        $SQLCMD \
            -S localhost \
            -U sa \
            -P "$SA_PASSWORD" \
            $SQLCMD_OPTS \
            -i "$script"
        
        if [ $? -eq 0 ]; then
            echo "Script ejecutado correctamente: $script"
        else
            echo "Error al ejecutar el script: $script"
            exit 1
        fi
    done
    
    echo "Todos los scripts se ejecutaron correctamente"
else
    echo "No se encontró el directorio de scripts: $SCRIPTS_DIR"
fi
