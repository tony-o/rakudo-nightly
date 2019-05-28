FROM alpine:edge

WORKDIR /usr/local/src

RUN apk update
RUN apk add --update curl openssl gnupg git build-base openjdk9-jdk nodejs

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
