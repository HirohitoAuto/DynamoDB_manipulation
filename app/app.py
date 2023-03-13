"""
================================================
=== Libraries
================================================
"""
import pandas as pd

from datetime import datetime
from pathlib import Path

from src.myClass import JobSys


"""
================================================
=== Functions
================================================
"""


def read_definition(filename):
    df = pd.read_csv(filename)
    colum_names = df.columns

    keys = df[colum_names[0]]
    values = df[colum_names[1]]

    data_in = {k: v for k, v in zip(keys, values)}
    data_difinition = {}
    for key in data_in.keys():
        data_difinition.update({str(key): {"S": data_in[key]}})
    return data_difinition


"""
================================================
=== Lambda Handler
================================================
"""


def handler(event, content):
    # set path
    parent_folder = Path(__file__).parents[0]
    filename_job_definition = Path(parent_folder, "job_definition.csv")

    # set job info
    this_job = JobSys()
    job_id = this_job.job_id
    yyyymmdd_str = today = str(datetime.today().strftime("%Y%m%d"))

    # read job definition
    data = read_definition(filename_job_definition)
    data.update({"job_id": {"N": str(job_id)}})
    data.update({"yyyymmdd": {"N": yyyymmdd_str}})

    # write into DynamoDB
    response = this_job.put_item(data)
    print(f"\njob_id:{job_id}")
    print(response, "\n")
