FROM ubuntu:16.04

ENV S3QL_VERSION 2.32
ENV S3QL_MOUNTPOINT /mnt/s3ql
ENV CACHESIZE 10485760
ENV TIMEOUT 3600

RUN apt-get update \
    && apt-get install -y wget cifs-utils open-iscsi ntfs-3g libsystemd-dev gcc python3-dev pkg-config python3-pip psmisc libsqlite3-dev libfuse-dev libattr1-dev fuse \
    git jq curl vim \
    && ulimit -n 65536 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN pip3 install setuptools pycrypto requests defusedxml apsw llfuse dugong pytest envtpl
RUN wget https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64.deb && dpkg -i dumb-init_*.deb &&  rm dumb-init_*.deb

WORKDIR /root




RUN wget https://bitbucket.org/nikratio/s3ql/downloads/s3ql-${S3QL_VERSION}.tar.bz2 && tar xf s3ql-${S3QL_VERSION}.tar.bz2 && rm s3ql-${S3QL_VERSION}.tar.bz2
WORKDIR /root/s3ql-${S3QL_VERSION}/
RUN python3 setup.py build_ext --inplace \
    && python3 -m pytest tests/ \
    && python3 setup.py install


COPY /run.sh /
COPY /s3ql.ini.envtpl /root/
COPY /scripts/* /scripts/

RUN chmod -R 500 /run.sh /scripts


ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/run.sh"]


