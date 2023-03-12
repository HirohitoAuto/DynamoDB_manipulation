resource "aws_dynamodb_table" "tfer--job_info" {
  attribute {
    name = "job_id"
    type = "N"
  }

  attribute {
    name = "yyyymmdd"
    type = "N"
  }

  billing_mode = "PROVISIONED"
  hash_key     = "job_id"
  name         = "job_info"

  point_in_time_recovery {
    enabled = "false"
  }

  range_key      = "yyyymmdd"
  read_capacity  = "1"
  stream_enabled = "false"
  table_class    = "STANDARD"
  write_capacity = "1"
}