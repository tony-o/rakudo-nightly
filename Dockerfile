FROM ubuntu:21.10 as X1

MAINTAINER zef:tony-o

ENV DEBIAN_FRONTEND=noninteractive
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
  perl Configure.pl --gen-nqp --gen-moar --backends=moar --prefix=/root/bin && \
  make && \
  make install

ENV PATH="/root/bin/bin:${PATH}"
RUN git clone https://github.com/ugexe/zef.git /tmp/zef && \
  cd /tmp/zef && \
  perl6 -Ilib bin/zef install --/test .

RUN cd /tmp && \
    curl -Lo o.tar.gz https://github.com/openssl/openssl/archive/OpenSSL_1_1_1g.tar.gz && \
    tar xvf o.tar.gz && \
    cd openssl-OpenSSL_1_1_1g && \
    ./config --prefix=/usr --openssldir=/usr -Wl,-rpath=/usr/lib && \
    make && \
    make install && \
    cd /tmp && \
    curl -Lo c.tar.gz https://curl.haxx.se/download/curl-7.71.1.tar.gz && \
    tar xvf c.tar.gz && \
    cd curl-7.71.1 && \
    env CFLAGS=-Wl,-rpath=/usr/lib \
      PKG_CONFIG=/usr ./configure \
        --prefix=/usr \
        --disable-shared \
        --enable-static \
        --enable-threaded-resolver \
        --with-ssl && \
    make && \
    make install

RUN ls /usr/lib && ls /usr/lib64

FROM ubuntu:21.10 as X2

#COPY --from=X1 /usr /usr
#COPY --from=X1 /lib /lib
COPY --from=X1 /root/bin /root/bin
COPY --from=X1 /usr/bin/curl /usr/bin/curl
COPY --from=X1 /usr/lib/libcurl.* /usr/lib/
COPY --from=X1 /usr/lib/libssl.* /usr/lib/
COPY --from=X1 /usr/lib/libcrypto.* /usr/lib/
COPY --from=X1 /usr/bin/git /usr/bin/git
COPY --from=X1 /etc/ssl /etc/ssl

ENV PATH="/root/bin/bin:/root/bin/share/perl6/site/bin:${PATH}"

CMD ["/bin/bin/perl6"]
