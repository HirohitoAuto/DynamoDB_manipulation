# Manipulation Dynamo DB



## System Architecture

![](pics/architecture.png)





## How to Use

### build infrastructure

This bash file build whole infrastructure on AWS, using Terraform files in `infrastracture/`.

```bash
sh build.sh
```

### deploy app image

This bash file works like below:

* Build Docker Image for lambda using python code in `app/`.

* Push the image to ECR repository.

```bash
sh deploy.sh
```
