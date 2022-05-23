# Covid-19/Retail analysis with a modern data stack

<p>
<img alt="Docker" src="https://img.shields.io/badge/docker-%230db7ed.svg?&style=for-the-badge&logo=docker&logoColor=white"/>
<img alt="Apache Airflow" src="https://img.shields.io/badge/apacheairflow-%23017cee.svg?&style=for-the-badge&logo=apache-airflow&logoColor=white"/>
<img alt="dbt" src="https://img.shields.io/badge/DBT-%23ff694b.svg?&style=for-the-badge&logo=dbt&logoColor=white"/>
<img alt="Google Cloud" src="https://img.shields.io/badge/googlecloud-%234285f4.svg?&style=for-the-badge&logo=googlecloud&logoColor=white"/>
</p>


This projects aims to build a *lambda* data architecture using services and technologies from a modern data stack. So, some serverless or PaaS services are prefered than other IaaS services. The same for UI data wrangling services if possible instead of code technologies. The following architecture was developed thinking in this principles and possible main technologies:

<img align="center" alt="Tech architecture" src="./docs/tech.png" />

Locally, this architecture can run in the followeing endpoints with Docker containers:

- Marquez: http://localhost:3000
- Airflow: http://localhost:8080
- Superset: http://localhost:8088

With PaaS or serverless services, the following architecture aims to give more details about the implementation using GCP services, Airbyte Cloud, Astronomer platform + Datakin and DBT cloud services:

<img align="center" alt="Cloud architecture" src="./docs/cloud.png" />
