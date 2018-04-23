FROM python:alpine3.7

RUN apk add --update --no-cache build-base

RUN mkdir -p /workspace
COPY . /workspace
WORKDIR /workspace

RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python", "manifest_generator.py"]
