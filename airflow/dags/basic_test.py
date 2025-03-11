from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.operators.python import PythonOperator


def test_python():
    print("python oprator works!!")

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2023, 12, 10),
    'email': ['khalid@deriv.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 5,
    'retry_delay': timedelta(minutes=2),
}

dag_params = {
    'dag_id': 'test_exec',
    'default_args': default_args,
    'schedule_interval': None,
    'catchup': False,
    'max_active_runs': 5,
}

with DAG(**dag_params) as dag:

    t1 = PythonOperator(
        task_id='test_python',
        python_callable=test_python,
        dag=dag,
    )

    t2 = EmptyOperator(task_id='end')

    t1 >> t2