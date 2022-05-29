FROM apache/superset:1.5.0

COPY pythonpath_dev /app/docker/pythonpath_dev
COPY docker-bootstrap.sh /app/docker/docker-bootstrap.sh
COPY docker-init.sh /app/docker/docker-init.sh
COPY requirements.txt /app/docker/requirements.txt

USER root

RUN chmod +x /app/docker/*.sh \
    && pip install --requirement /app/docker/requirements.txt

USER superset
