FROM node:10.13.0-slim

LABEL org.label-schema.schema-version = 1.0.0 \
    org.label-schema.vendor = heitor.ramon@gmail.com \
    org.label-schema.vcs-url = https://github.com/bloodf/nodepdfdriver \
    org.label-schema.description = "Node 10 PDF TK & Puppeteer Docker" \
    org.label-schema.name = "NODEPDFDRIVER" \
    org.label-schema.url = https://github.com/bloodf/nodepdfdriver

#PDFTK

RUN apt-get update && apt-get install -y pdftk ghostscript imagemagick
# tools
RUN apt-get install -yyq gconf-service lsb-release wget xdg-utils
# and fonts
RUN apt-get install -yyq fonts-liberation

#Chrome
RUN apt-get update && \
apt-get install -yq gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 \
libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 \
libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 \
libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget && \
wget https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64.deb && \
dpkg -i dumb-init_*.deb && rm -f dumb-init_*.deb && \
apt-get clean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

# Set language to UTF8

#ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

#ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-unstable

#Node Globals

RUN npm install -g \
        npx \
        node-pdftk \
        dotenv \
        forever \
        puppeteer \
        --unsafe-perm

WORKDIR /usr/src/app
