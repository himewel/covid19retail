import datetime
import json
from glob import glob

from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.utils.dates import datetime, timedelta


class DBTDagParser:
    def __init__(dag_name, dag_conf, dbt_conf):
        self.dag_name = dag_name
        self.dag_conf = dag_conf
        self.dbt_conf = dbt_conf

    def load_manifest(local_filepath):
        with open(local_filepath) as f:
            data = json.load(f)
        return data

    def make_dbt_task(dag, node, dbt_verb):
        """Returns an Airflow operator either run and test an individual model"""
        DBT_DIR = self.dbt_conf["dbt_dir"]
        GLOBAL_CLI_FLAGS = self.dbt_conf["global_cli_flags"]
        TARGET = self.dbt_conf["target"]

        model = node.split(".")[-1]
        bash_command = f"""
            cd {DBT_DIR} &&
            dbt {GLOBAL_CLI_FLAGS} {dbt_verb} --target prod --models {model}
        """

        if dbt_verb == "run":
            task_name = node
        elif dbt_verb == "test":
            task_name = node.replace("model", "test")

        dbt_task = BashOperator(task_id=task_name, bash_command=bash_command, dag=dag)

        return dbt_task

    def make_dag():
        dag = DAG(self.dag_name, **self.dag_conf)
        data = load_manifest(self.dbt_conf["manifest_json"])

        dbt_tasks = {}
        for node in data["nodes"].keys():
            if node.split(".")[0] == "model":
                node_test = node.replace("model", "test")

                dbt_tasks[node] = make_dbt_task(node, "run")
                dbt_tasks[node_test] = make_dbt_task(node, "test")

        for node in data["nodes"].keys():
            if node.split(".")[0] == "model":

                # Set dependency to run tests on a model after model runs finishes
                node_test = node.replace("model", "test")
                dbt_tasks[node] >> dbt_tasks[node_test]

                # Set all model -> model dependencies
                for upstream_node in data["nodes"][node]["depends_on"]["nodes"]:

                    upstream_node_type = upstream_node.split(".")[0]
                    if upstream_node_type == "model":
                        dbt_tasks[upstream_node] >> dbt_tasks[node]
        return dag


if __name__ == "__main__":
    for template in glob("./templates/*.yaml"):
        with open(template, "r") as stream:
            dag_template = yaml.load(template)

        for dag_name, config in dag_template.items():
            if config["type"] != "dbt":
                break

        globals()[dag_name] = DBTDagParser(
            dag_name=dag_name,
            dag_conf=config["dag_conf"],
            dbt_conf=config["dbt_conf"],
        )
