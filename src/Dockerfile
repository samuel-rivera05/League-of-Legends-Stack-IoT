# src/Dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY riot_collector.py .

CMD ["python", "riot_collector.py"]
