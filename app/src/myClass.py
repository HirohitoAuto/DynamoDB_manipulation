import boto3


class JobSys(object):
    """
    ------------------------
    JobSys
        : basic info of job definition
    ------------------------
    """

    def __init__(self):
        self.dynamodb = boto3.client("dynamodb")
        self.table_name = "job_info"
        self.parttition_key = "job_id"
        self.job_id = self.get_job_id()

    def get_job_id(self) -> int:
        """
        ------------------------
        get_job_id
        ------------------------
        """
        partition_keys = set()
        response = self.dynamodb.scan(
            TableName=self.table_name,
            ProjectionExpression=self.parttition_key,
            Select="SPECIFIC_ATTRIBUTES",
        )
        while "LastEvaluatedKey" in response:
            for item in response["Items"]:
                partition_keys.add(int(item["job_id"]["N"]))
            response = self.dynamodb.scan(
                TableName=self.table_name,
                ProjectionExpression="job_id",
                Select="SPECIFIC_ATTRIBUTES",
                ExclusiveStartKey=response["LastEvaluatedKey"],
            )
        for item in response["Items"]:
            partition_keys.add(int(item["job_id"]["N"]))

        job_id_max = max(partition_keys)
        job_id = job_id_max + 1
        return job_id

    def put_item(self, data: dict) -> dict:
        """
        ------------------------
        put item
        ------------------------
        """
        response = self.dynamodb.put_item(TableName=self.table_name, Item=data)
        return response
