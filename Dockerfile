FROM node:10-alpine

RUN apk add python py-pip && \
        pip install --upgrade awscli==1.14.5 s3cmd==2.0.1 python-magic \

RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "@community http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk add --no-cache pdftk@community libgcj@edge

ENV CHROME_BIN=/usr/bin/chromium-browser
RUN echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
    apk add --no-cache \
      chromium@edge \
      nss@edge

WORKDIR /usr/src/app

CMD ["node"]