import json
from glob import glob

from airflow import DAG
from airflow.operators.bash import BashOperator
import yaml


class DBTDagParser:
    def __init__(self, dag_name, dag_conf, dbt_conf):
        self.dag_name = dag_name
        self.dag_conf = dag_conf
        self.dbt_conf = dbt_conf

    def load_manifest(self, local_filepath):
        with open(local_filepath) as f:
            data = json.load(f)
        return data

    def make_dbt_task(self, dag, node, dbt_verb):
        """Returns an Airflow operator either run and test an individual model"""
        DBT_DIR = self.dbt_conf["dbt_dir"]
        GLOBAL_CLI_FLAGS = self.dbt_conf.get("global_cli_flags", "")
        TARGET = self.dbt_conf["target"]
        PROFILE_DIR = self.dbt_conf["profile_dir"]

        model = node.split(".")[-1]

        date_execution = "{{ ds }}"
        task_name = "{{ task_instance_key_str }}"
        bash_command = rf"""
            EXECUTION_DATE={date_execution} \
            dbt-ol {dbt_verb} {GLOBAL_CLI_FLAGS} \
                --profiles-dir {PROFILE_DIR} \
                --target {TARGET} \
                --models {model} 2>&1 \
            | tee /tmp/{task_name}.txt
            if grep -e ERROR\=0 /tmp/{task_name}.txt; then
                rm -rf /tmp/{task_name}.txt
                exit 0
            else
                rm -rf /tmp/{task_name}.txt
                exit 1
            fi
        """

        if dbt_verb == "run":
            task_name = node
        elif dbt_verb == "test":
            task_name = node.replace("model", "test")

        dbt_task = BashOperator(
            task_id=task_name,
            bash_command=bash_command,
            cwd=DBT_DIR,
            dag=dag,
        )

        return dbt_task

    def make_dag(self):
        dag = DAG(self.dag_name, **self.dag_conf)
        data = self.load_manifest(self.dbt_conf["manifest_json"])

        dbt_tasks = {}
        for node in data["nodes"].keys():
            if node.split(".")[0] == "model":
                node_test = node.replace("model", "test")

                dbt_tasks[node] = self.make_dbt_task(dag, node, "run")
                dbt_tasks[node_test] = self.make_dbt_task(dag, node, "test")

        for node in data["nodes"].keys():
            if node.split(".")[0] == "model":

                # Set dependency to run tests on a model after model runs finishes
                node_test = node.replace("model", "test")
                dbt_tasks[node] >> dbt_tasks[node_test]

                # Set all model -> model dependencies
                for upstream_node in data["nodes"][node]["depends_on"]["nodes"]:
                    upstream_node_type = upstream_node.split(".")[0]
                    upstream_node_test = upstream_node.replace("model", "test")
                    if upstream_node_type == "model":
                        dbt_tasks[upstream_node_test] >> dbt_tasks[node]
        return dag


for template in glob("/opt/airflow/dags/templates/*.yaml"):
    with open(template, "r") as stream:
        dag_template = yaml.load(stream, Loader=yaml.FullLoader)

    for dag_name, config in dag_template.items():
        if config["type"] != "dbt":
            break

        try:
            dag_parser = DBTDagParser(
                dag_name=dag_name,
                dag_conf=config["dag_conf"],
                dbt_conf=config["dbt_conf"],
            )
            globals()[dag_name] = dag_parser.make_dag()
            print(f"Succeed to parse {template}: {globals()[dag_name]}")
        except Exception as e:
            import traceback

            print(f"Fail to parse {template} with the following exception:")
            traceback.print_exc()
