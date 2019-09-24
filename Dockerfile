FROM ubuntu:latest as X1

MAINTAINER zef:tony-o

RUN apt update && apt install -y --no-install-recommends \
  autoconf \
  automake \
  build-essential \
  curl \
  g++ \
  gcc \
  git \
  gzip \
  libcurl4-openssl-dev \
  libpq-dev \
  libssl-dev \
  libxml2-dev \
  make \
  openjdk-11-jdk \
  postgresql-server-dev-all \
  python3-pip \
  python3-setuptools \
  tar \
  wget \
  && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/rakudo/rakudo.git /tmp/rakudo && \
  cd /tmp/rakudo && \
  perl Configure.pl --gen-nqp --gen-moar --backends=moar --prefix=/usr/local && \
  make && \
  make install

RUN git clone https://github.com/ugexe/zef.git /tmp/zef && \
  cd /tmp/zef && \
  perl6 -Ilib bin/zef install --/test .

FROM ubuntu:latest as X2

COPY --from=X1 /usr /usr
COPY --from=X1 /lib /lib

ENV PATH="/usr/local/share/perl6/site/bin:${PATH}"

CMD ["/usr/local/bin/perl6"]
