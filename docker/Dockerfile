FROM python:3.10 as base
ARG VERSION=2.1.12
# ENV EGGNOG_DATA_DIR=/db

RUN apt-get update && apt-get install -y \
    wget \
    sqlite3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip

RUN pip install \
    biopython \
    psutil==5.7.0 \
    eggnog-mapper==${VERSION}

# Set the working directory
RUN mkdir -p /opt/work
WORKDIR /opt/work

CMD ["/bin/sh","-c","/bin/bash"]