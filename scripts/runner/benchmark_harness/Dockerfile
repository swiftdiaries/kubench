FROM tensorflow/tensorflow:1.7.0

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    git

RUN pip install --upgrade google-api-python-client pyyaml paramiko google-cloud

RUN mkdir -p /workspace/git

RUN git clone https://github.com/tfboyd/benchmark_harness.git \
    /workspace/git/benchmark_harness

WORKDIR /workspace/git/benchmark_harness

ENTRYPOINT ["python", "-m", "oss_bench.harness.controller"]
