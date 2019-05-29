FROM alpine:edge

WORKDIR /usr/local/src

RUN apk update
RUN apk add --update curl openssl gnupg git build-base nodejs perl

ENV JAVA_HOME=/opt/jdk \
    PATH=${PATH}:/opt/jdk/bin \
    LANG=C.UTF-8

RUN set -ex && \
    apk add --no-cache bash && \
    wget http://download.java.net/java/jdk9-alpine/archive/181/binaries/jdk-9-ea+181\_linux-x64-musl\_bin.tar.gz -O jdk.tar.gz && \
    mkdir -p /opt/jdk && \
    tar zxvf jdk.tar.gz -C /opt/jdk --strip-components=1 && \
    rm jdk.tar.gz && \
    rm /opt/jdk/lib/src.zip

WORKDIR /app

COPY backend-module/target/backend-module-1.0-SNAPSHOT.jar .
COPY frontend-module/target/frontend-module-1.0-SNAPSHOT.jar .

RUN jlink --module-path backend-module-1.0-SNAPSHOT.jar:frontend-module-1.0-SNAPSHOT.jar:$JAVA\_HOME/jmods \
        --add-modules com.jdriven.java9runtime.frontend \
        --launcher run=com.jdriven.java9runtime.frontend/com.jdriven.java9runtime.frontend.FrontendApplication \
        --output dist \
        --compress 2 \
        --strip-debug \
        --no-header-files \
        --no-man-pages

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
