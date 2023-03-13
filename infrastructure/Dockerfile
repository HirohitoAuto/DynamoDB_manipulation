#=======================================
#=== Dummy implementation
#=======================================

FROM public.ecr.aws/lambda/python:3.9

# Copy function code
RUN touch app.py     ${LAMBDA_TASK_ROOT}
RUN "def handler(event, context):" >> echo app.py
RUN "\tprint(dummy)" >> echo app.py

CMD [ "app.handler" ]
