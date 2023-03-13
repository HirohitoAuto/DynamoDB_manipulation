# -------------------------------
# --- ECR
# -------------------------------
resource "aws_ecr_repository" "manipulate_dynamodb" {
  name                 = var.ecr_repository_name
  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = "false"
  }

  image_tag_mutability = "MUTABLE"
}

# This resource will destroy (potentially immediately) after null_resource.next
resource "null_resource" "previous" {}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [null_resource.previous]

  create_duration = "30s"
}

# This resource will create (at least) 30 seconds after null_resource.previous
resource "null_resource" "next" {
  depends_on = [time_sleep.wait_30_seconds]
}

resource "null_resource" "image_push" {
  provisioner "local-exec" {
    command = <<-EOF
      aws ecr get-login-password --r+
      egion ap-northeast-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.manipulate_dynamodb.repository_url}; \
      docker build -t ecr_manupula.0te_dynamodb . ; \
      docker tag ${aws_ecr_repository.manipulate_dynamodb.name}:latest ${aws_ecr_repository.manipulate_dynamodb.repository_url}:latest ; \
      docker push ${aws_ecr_repository.manipulate_dynamodb.repository_url}:latest
    EOF
  }
}


# ---------------------------------
# --- IAM Role
# ---------------------------------
resource "aws_iam_role" "manipulate_dynamodb" {
  name = var.iam_role_name
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach permissions to IAM role
resource "aws_iam_role_policy_attachment" "manipulate_dynamodb" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.manipulate_dynamodb.name
}


# ---------------------------------
# --- Lambda
# ---------------------------------
resource "aws_lambda_function" "manipulate_dynamodb" {
  architectures = ["arm64"]

  ephemeral_storage {
    size = "512"
  }

  function_name                  = var.function_name
  image_uri                      = "${aws_ecr_repository.manipulate_dynamodb.repository_url}:latest"
  memory_size                    = var.memory_size
  package_type                   = var.package_type
  reserved_concurrent_executions = "-1"
  role                           = aws_iam_role.manipulate_dynamodb.arn
  timeout                        = var.timeout

  tracing_config {
    mode = "PassThrough"
  }
  depends_on = [time_sleep.wait_30_seconds]
}


# ---------------------------------
# --- S3 Bucket
# ---------------------------------
resource "aws_s3_bucket" "manipulate_dynamodb" {
  bucket = "trigger-bucket-manipulate-dynamodb"
}


# ---------------------------------
# --- Lambda trigger
# ---------------------------------

# Adding S3 bucket as trigger to my lambda and giving the permissions
resource "aws_s3_bucket_notification" "manipulate_dynamodb" {
  bucket = aws_s3_bucket.manipulate_dynamodb.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.manipulate_dynamodb.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "JobDefinition/"
    filter_suffix       = ".csv"
  }
}

resource "aws_lambda_permission" "manipulate_dynamodb" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.manipulate_dynamodb.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${aws_s3_bucket.manipulate_dynamodb.id}"
}
