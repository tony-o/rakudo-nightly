FROM alpine:edge

WORKDIR /usr/local/src

RUN apk update
RUN apk search gzip
RUN apk search gunzip
RUN apk add --update curl openssl gnupg git build-base nodejs perl gzip wget

RUN wget -O /opt/jdk.tar.gz https://zef.pm/openjdk-9_linux-x64_bin.tar.gz 2>/dev/null
RUN tar xvf /opt/jdk.tar.gz -C /opt
CMD ["/opt/jdk-9/javac", "--version"]
CMD ["/opt/jdk-9/bin/jlink", "--module-path /opt/jdk-9/jmods", "--verbose", "--add-modules java.base,java.logging,java.xml,jdk.unsupported", "--compress 2", "--no-header-files", "--output /opt/jdk-9-minimal"]

WORKDIR /app

ENV JAVA_HOME=/opt/jdk-9
ENV PATH="$PATH:${JAVA_HOME}/bin"

RUN javac --version

RUN node -v

RUN git clone https://github.com/rakudo/rakudo.git /usr/local/src/rakudo

RUN cd /usr/local/src/rakudo; perl Configure.pl --gen-moar --gen-nqp --backends=moar --prefix=/usr/local && make && make install
RUN cd /usr/local/src/rakudo; perl Configure.pl --gen-moar --gen-nqp --backends=jvm  --prefix=/usr/local && make && make install
RUN cd /usr/local/src/rakudo; perl Configure.pl --gen-moar --gen-nqp --backends=js   --prefix=/usr/local && make && make install

RUN git clone https://github.com/ugexe/zef.git /usr/local/src/zef
#RUN cd /usr/local/src/zef; perl6-m -I. bin/zef install .
RUN ln -s "$(cd /usr/local/src/zef; perl6-m -I. bin/zef install . | egrep -A 1 'script .*? installed to:' | tail -n 1)/zef" /usr/local/bin/zef

CMD ["/usr/local/bin/perl6", "-v"]
CMD ["/usr/local/bin/zef", "-v"]

RUN apk del curl openssl gnupg git build-base nodejs openjdk8-jre perl
