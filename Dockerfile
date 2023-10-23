FROM alpine:latest
ARG VERSION=latest
RUN apk add postgresql16-client --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main
RUN apk add mongodb-tools --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community
RUN apk add \
  curl \
  openssl \
  mariadb-connector-c \
  mysql-client \
  redis \
  sqlite \
  # replace busybox utils
  tar \
  gzip \
  pigz \
  bzip2 \
  # there is no pbzip2 yet
  lzip \
  xz-dev \
  lzop \
  xz \
  # pixz is in edge atm
  zstd \
  # microsoft sql dependencies \
  libstdc++ \
  gcompat \
  icu \
  && \
  rm -rf /var/cache/apk/*
  RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/* 


WORKDIR /tmp
RUN wget https://aka.ms/sqlpackage-linux && \
    unzip sqlpackage-linux -d /opt/sqlpackage && \
    rm sqlpackage-linux && \
    chmod +x /opt/sqlpackage/sqlpackage

ENV PATH="${PATH}:/opt/sqlpackage"

ADD install /install
RUN /install ${VERSION} && rm /install

CMD ["/usr/local/bin/gobackup", "run"]
