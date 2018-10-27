FROM mkenney/npm:node-10-alpine

LABEL org.label-schema.schema-version = 1.0.0 \
    org.label-schema.vendor = heitor.ramon@gmail.com \
    org.label-schema.vcs-url = https://github.com/bloodf/nodepdfdriver \
    org.label-schema.description = "Node PDF TK & Puppeteer" \
    org.label-schema.name = "NODEPDF" \
    org.label-schema.url = https://github.com/bloodf/nodepdfdriver

ENV TERM=xterm \
    NLS_LANG=American_America.AL32UTF8 \
    LANG=C.UTF-8 \
    LANGUAGE=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TIMEZONE=America/Sao_Paulo

RUN apk add python py-pip
RUN pip install --upgrade pip
RUN pip install --upgrade awscli==1.14.5 s3cmd==2.0.1 python-magic

RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "@community http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk add --no-cache pdftk@community libgcj@edge

ENV CHROME_BIN=/usr/bin/chromium-browser
RUN echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
    apk add --no-cache \
      chromium@edge \
      nss@edge

WORKDIR /src

CMD ["node"]
