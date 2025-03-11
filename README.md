# ETL pipeline
Airflow with postgres ETL pipeline to load data to DB and create models on top of it

## How to run
1. Build the image:
```sh
cd airflow/src
docker build -t custom-airflow:V1 .
```
2. Run Docker in Swarm mode
```sh
cd ../../  # Back to root folder
docker swarm init --advertise-addr eth0
docker stack deploy --compose-file docker-compose.yml airflow
```