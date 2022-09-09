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
  raku -Ilib bin/zef install --/test .

RUN find /usr/lib/aarch64-linux-gnu | egrep 'lib(curl|z|c|nghttp2|idn2|rtmp|ssh|psl|ssl|crypto|gssapi|ldap|lber|zstd|brotlidec|unistring|gnutls|hogweed|nettle|gmp|krb5|k5crypto|com_err|krb5support|sasl2|brotlicommon|p11-kit|tasn1|keyutils|resolv|ffi|pcre)'

FROM ubuntu:22.04 as X2

COPY --from=X1 /root/bin /root/bin
COPY --from=X1 /usr/bin/git /usr/bin/git
COPY --from=X1 /etc/ssl /etc/ssl
COPY --from=X1 /usr/bin/curl /usr/bin/curl

COPY --from=X1 /usr/lib/aarch64-linux-gnu/libcurl.so.4 /usr/lib/aarch64-linux-gnu/libcurl.so.4
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libz.so.1 /usr/lib/aarch64-linux-gnu/libz.so.1
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libc.so.6 /usr/lib/aarch64-linux-gnu/libc.so.6
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libnghttp2.so.14 /usr/lib/aarch64-linux-gnu/libnghttp2.so.14
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libidn2.so.0 /usr/lib/aarch64-linux-gnu/libidn2.so.0
COPY --from=X1 /usr/lib/aarch64-linux-gnu/librtmp.so.1 /usr/lib/aarch64-linux-gnu/librtmp.so.1
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libssh.so.4 /usr/lib/aarch64-linux-gnu/libssh.so.4
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libpsl.so.5 /usr/lib/aarch64-linux-gnu/libpsl.so.5
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libssl.so.3 /usr/lib/aarch64-linux-gnu/libssl.so.3
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libcrypto.so.3 /usr/lib/aarch64-linux-gnu/libcrypto.so.3
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libgssapi_krb5.so.2 /usr/lib/aarch64-linux-gnu/libgssapi_krb5.so.2
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libldap-2.5.so.0 /usr/lib/aarch64-linux-gnu/libldap-2.5.so.0
COPY --from=X1 /usr/lib/aarch64-linux-gnu/liblber-2.5.so.0 /usr/lib/aarch64-linux-gnu/liblber-2.5.so.0
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libzstd.so.1 /usr/lib/aarch64-linux-gnu/libzstd.so.1
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libbrotlidec.so.1 /usr/lib/aarch64-linux-gnu/libbrotlidec.so.1
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libunistring.so.2 /usr/lib/aarch64-linux-gnu/libunistring.so.2
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libgnutls.so.30 /usr/lib/aarch64-linux-gnu/libgnutls.so.30
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libhogweed.so.6 /usr/lib/aarch64-linux-gnu/libhogweed.so.6
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libnettle.so.8 /usr/lib/aarch64-linux-gnu/libnettle.so.8
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libgmp.so.10 /usr/lib/aarch64-linux-gnu/libgmp.so.10
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libkrb5.so.3 /usr/lib/aarch64-linux-gnu/libkrb5.so.3
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libk5crypto.so.3 /usr/lib/aarch64-linux-gnu/libk5crypto.so.3
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libcom_err.so.2 /usr/lib/aarch64-linux-gnu/libcom_err.so.2
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libkrb5support.so.0 /usr/lib/aarch64-linux-gnu/libkrb5support.so.0
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libsasl2.so.2 /usr/lib/aarch64-linux-gnu/libsasl2.so.2
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libbrotlicommon.so.1 /usr/lib/aarch64-linux-gnu/libbrotlicommon.so.1
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libp11-kit.so.0 /usr/lib/aarch64-linux-gnu/libp11-kit.so.0
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libtasn1.so.6 /usr/lib/aarch64-linux-gnu/libtasn1.so.6
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libkeyutils.so.1 /usr/lib/aarch64-linux-gnu/libkeyutils.so.1
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libresolv.so.2 /usr/lib/aarch64-linux-gnu/libresolv.so.2
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libffi.so.8 /usr/lib/aarch64-linux-gnu/libffi.so.8
COPY --from=X1 /usr/lib/aarch64-linux-gnu/libpcre2-8.so.0 /usr/lib/aarch64-linux-gnu/libpcre2-8.so.0

ENV PATH="/root/bin/bin:/root/bin/share/perl6/site/bin:${PATH}"

RUN rakudo -v && zef update && zef -h

CMD ["rakudo"]
