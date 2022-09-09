FROM ubuntu:22.04 as X1

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

FROM ubuntu:22.04 as X2

COPY --from=X1 /root/bin /root/bin
COPY --from=X1 /usr/bin/git /usr/bin/git
COPY --from=X1 /etc/ssl /etc/ssl
COPY --from=X1 /usr/bin/curl /usr/bin/curl

COPY --from=X1 /usr/lib/aarch64-linux-gnu/libcurl.* /usr/lib/aarch64-linux-gnu/libcurl
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libz.* /usr/lib/aarch64-linux-gnu/libz
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libc.* /usr/lib/aarch64-linux-gnu/libc
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libnghttp2.* /usr/lib/aarch64-linux-gnu/libnghttp2
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libidn2.* /usr/lib/aarch64-linux-gnu/libidn2
COPY --from=X1 /usr/lib/aarch64-linux-gnu/librtmp.* /usr/lib/aarch64-linux-gnu/librtmp
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libssh.* /usr/lib/aarch64-linux-gnu/libssh
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libpsl.* /usr/lib/aarch64-linux-gnu/libpsl
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libssl.* /usr/lib/aarch64-linux-gnu/libssl
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libcrypto.* /usr/lib/aarch64-linux-gnu/libcrypto
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libgssapi_krb5.* /usr/lib/aarch64-linux-gnu/libgssapi_krb5
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libldap-2.5.* /usr/lib/aarch64-linux-gnu/libldap-2.5
COPY --from=X1 /usr/lib/aarch64-linux-gnu/liblber-2.5.* /usr/lib/aarch64-linux-gnu/liblber-2.5
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libzstd.* /usr/lib/aarch64-linux-gnu/libzstd
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libbrotlidec.* /usr/lib/aarch64-linux-gnu/libbrotlidec
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libunistring.* /usr/lib/aarch64-linux-gnu/libunistring
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libgnutls.* /usr/lib/aarch64-linux-gnu/libgnutls
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libhogweed.* /usr/lib/aarch64-linux-gnu/libhogweed
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libnettle.* /usr/lib/aarch64-linux-gnu/libnettle
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libgmp.* /usr/lib/aarch64-linux-gnu/libgmp
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libkrb5.* /usr/lib/aarch64-linux-gnu/libkrb5
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libk5crypto.* /usr/lib/aarch64-linux-gnu/libk5crypto
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libcom_err.* /usr/lib/aarch64-linux-gnu/libcom_err
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libkrb5support.* /usr/lib/aarch64-linux-gnu/libkrb5support
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libsasl2.* /usr/lib/aarch64-linux-gnu/libsasl2
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libbrotlicommon.* /usr/lib/aarch64-linux-gnu/libbrotlicommon
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libp11-kit.* /usr/lib/aarch64-linux-gnu/libp11-kit
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libtasn1.* /usr/lib/aarch64-linux-gnu/libtasn1
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libkeyutils.* /usr/lib/aarch64-linux-gnu/libkeyutils
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libresolv.* /usr/lib/aarch64-linux-gnu/libresolv
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libffi.* /usr/lib/aarch64-linux-gnu/libffi

ENV PATH="/root/bin/bin:/root/bin/share/perl6/site/bin:${PATH}"

RUN rakudo -v && zef update

CMD ["rakudo"]
