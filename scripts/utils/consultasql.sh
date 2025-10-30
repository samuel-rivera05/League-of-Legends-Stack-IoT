docker exec -it sqlserver /bin/bash \
-c "/opt/mssql-tools18/bin/sqlcmd \
-S localhost \
-U sa \
-P \$SA_PASSWORD \
-C \
-Q 'USE Reto0f1; SELECT * FROM Disputa;'"

