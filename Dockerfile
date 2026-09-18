FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app/

# Agregamos esto para forzar que liste el contenido y verifique el wsgi antes de arrancar
RUN python -c "import os; print(os.listdir('.')); print(os.listdir('endpoint'))"

EXPOSE 10000

CMD ["python", "-m", "gunicorn", "endpoint.wsgi:application", "--bind", "0.0.0.0:10000"]