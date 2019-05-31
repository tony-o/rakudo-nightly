FROM alpine:edge

WORKDIR /usr/local/src

RUN apk update
RUN apk add --update curl openssl gnupg git build-base nodejs perl
RUN apk add openjdk9-jdk --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing
RUN ln -s /usr/lib/jvm/default-jvm/bin/javac /usr/bin/javac
RUN ln -s /usr/lib/jvm/default-jvm/bin/jar /usr/bin/jar

WORKDIR /app

RUN git clone https://github.com/rakudo/rakudo.git /usr/local/src/rakudo

RUN cd /usr/local/src/rakudo; perl Configure.pl --gen-moar --gen-nqp --backends=moar,jvm --prefix=/usr/local && make && make install

RUN git clone https://github.com/ugexe/zef.git /usr/local/src/zef
RUN ln -s "$(cd /usr/local/src/zef; perl6-m -I. bin/zef install . | egrep -A 1 'script .*? installed to:' | tail -n 1)/zef" /usr/local/bin/zef-m
RUN ln -s "$(cd /usr/local/src/zef; perl6-j -I. bin/zef install . | egrep -A 1 'script .*? installed to:' | tail -n 1)/zef" /usr/local/bin/zef-j
RUN ln -s "$(cd /usr/local/src/zef; perl6   -I. bin/zef install . | egrep -A 1 'script .*? installed to:' | tail -n 1)/zef" /usr/local/bin/zef

CMD ["/usr/local/bin/perl6"]

RUN apk del curl openssl gnupg git build-base nodejs perl
