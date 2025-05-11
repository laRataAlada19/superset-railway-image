FROM apache/superset:latest

USER root

ARG DATABASE_URL
ARG SUPERSET_SECRET_KEY
ARG SUPERSET_PORT=8088

ENV PYTHONPATH="/app/pythonpath:/app/docker/pythonpath_prod"
ENV SUPERSET_CACHE_REDIS_URL=${REDIS_URL}
ENV SUPERSET_ENV="production"
ENV SUPERSET_LOAD_EXAMPLES="no"
ENV SUPERSET_SECRET_KEY="${SUPERSET_SECRET_KEY}"
ENV CYPRESS_CONFIG=False
ENV SUPERSET_PORT="${SUPERSET_PORT}"
ENV SQLALCHEMY_DATABASE_URI="${DATABASE_URL}"
ENV SUPERSET_CONFIG_PATH=/app/docker/superset_config.py

EXPOSE 8088

# Install dependencies including PostgreSQL driver
RUN pip install --no-cache-dir \
    google \
    google-api-core \
    google-api-python-client \
    google.cloud.bigquery \
    google.cloud.storage \
    psycopg2-binary

# Copy configuration and startup files
COPY startup.sh ./startup.sh
COPY bootstrap.sh /app/docker/docker-bootstrap.sh
COPY superset_config.py superset_config.py

# Install gettext for envsubst
RUN apt-get update && apt-get install -y gettext

# Interpolate env variables into config
RUN envsubst < "superset_config.py" > "/app/docker/superset_config.py"

# Set permissions
RUN chmod +x ./startup.sh
RUN chmod +x /app/docker/docker-bootstrap.sh

# Start Superset
CMD sh -c "./startup.sh"
