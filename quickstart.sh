#!/usr/bin/env bash

set -e

mode=$1

case "$mode" in
  airflow)
    echo "Starting Apache Airflow and Marquez services..."
    docker-compose \
      --file docker-compose.airflow.yaml \
      --file docker-compose.marquez.yaml \
      up --detach
    ;;
  dbt)
    cd dbt
    echo "Creating catalog.json..."
    dbt docs generate --profiles-dir profiles
    echo "Creating manifest.json..."
    dbt compile --profiles-dir profiles
    ;;
  superset)
    echo "Starting Apache Superset services..."
    docker-compose \
      --file docker-compose.superset.yaml \
      up --detach
    ;;
  stop)
    echo "Stopping services..."
    docker-compose \
      --file docker-compose.airflow.yaml \
      --file docker-compose.marquez.yaml \
      --file docker-compose.superset.yaml \
      stop
    ;;
  help)
    echo "Choose a group of services to start [airflow|dbt|stop]..."
    echo "An empty param will start Airflow, Marquez and Superset together"
    ;;
  *)
    cd dbt
    echo "Creating catalog.json..."
    dbt docs generate --profiles-dir profiles
    echo "Creating manifest.json..."
    dbt compile --profiles-dir profiles

    cd ..
    echo "Starting all services..."
    docker-compose \
      --file docker-compose.airflow.yaml \
      --file docker-compose.marquez.yaml \
      --file docker-compose.superset.yaml \
      up --detach
    ;;
esac
