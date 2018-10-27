FROM node:10-alpine

LABEL org.label-schema.schema-version = 1.0.0 \
    org.label-schema.vendor = heitor.ramon@gmail.com \
    org.label-schema.vcs-url = https://github.com/bloodf/nodepdfdriver \
    org.label-schema.description = "Node 10 PDF TK & Puppeteer Docker" \
    org.label-schema.name = "NODEPDFDRIVER" \
    org.label-schema.url = https://github.com/bloodf/nodepdfdriver

ENV TERM=xterm \
    NLS_LANG=American_America.AL32UTF8 \
    LANG=C.UTF-8 \
    LANGUAGE=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TIMEZONE=America/Sao_Paulo

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

RUN set -x \
    && apk update \
    && apk add \
        acl \
        ca-certificates \
        curl \
        git \
        gnupg \
        mercurial \
        rsync \
        shadow \
        subversion \
        sudo

RUN set -x \
    && touch /root/.profile \
    && npm install --silent -g \
        gulp-cli \
        grunt-cli \
        bower \
        markdown-styles \
        npx \
        puppeteer \
        node-pdftk \
        dotenv \
        nodemon \
        forever \
    && echo "export NLS_LANG=$(echo $NLS_LANG)"                >> /root/.profile \
    && echo "export LANG=$(echo $LANG)"                        >> /root/.profile \
    && echo "export LANGUAGE=$(echo $LANGUAGE)"                >> /root/.profile \
    && echo "export LC_ALL=$(echo $LC_ALL)"                    >> /root/.profile \
    && echo "export TERM=xterm"                                >> /root/.profile \
    && echo "export PATH=$(echo $PATH)"                        >> /root/.profile \
    && echo "cd /src"                                          >> /root/.profile \
    && addgroup dev \
    && adduser -D -s /bin/sh -G dev dev \
    && echo "dev:password" | chpasswd \
    && curl --compressed -o- -L https://yarnpkg.com/install.sh | sh \
    && rsync -a /root/ /home/dev/ \
    && chown -R dev:dev /home/dev/ \
    && chmod 0777 /home/dev \
    && chmod -R u+rwX,g+rwX,o+rwX /home/dev \
    && setfacl -R -d -m user::rwx,group::rwx,other::rwx /home/dev

RUN set -x \
    && apk del \
        curl \
        gnupg \
        linux-headers \
        paxctl \
        python \
        rsync \
        tar \
    && rm -rf \
        /var/cache/apk/* \
        ${NODE_PREFIX}/lib/node_modules/npm/man \
        ${NODE_PREFIX}/lib/node_modules/npm/doc \
        ${NODE_PREFIX}/lib/node_modules/npm/html

RUN apk add --update bash && rm -rf /var/cache/apk/*

RUN apk add python py-pip
RUN pip install --upgrade pip
RUN pip install --upgrade awscli==1.14.5 s3cmd==2.0.1 python-magic

RUN apk --no-cache add msttcorefonts-installer fontconfig && \
    update-ms-fonts && \
    fc-cache -f

RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "@community http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk add --no-cache pdftk@community libgcj@edge

ENV CHROME_BIN=/usr/bin/chromium-browser

RUN echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
    apk add --no-cache \
      chromium@edge \
      nss@edge

ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

COPY fonts/*.* /usr/share/fonts/truetype/

RUN mkfontscale && mkfontdir && fc-cache

RUN npm cache clear --force

WORKDIR /usr/src/app
