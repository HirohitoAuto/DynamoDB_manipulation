cd app/
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin 718897870940.dkr.ecr.ap-northeast-1.amazonaws.com
docker build -t ecr_manupulate_dynamodb .
docker tag ecr_manupulate_dynamodb:latest 718897870940.dkr.ecr.ap-northeast-1.amazonaws.com/ecr_manupulate_dynamodb:latest
docker push 718897870940.dkr.ecr.ap-northeast-1.amazonaws.com/ecr_manupulate_dynamodb:latest