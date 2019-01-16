FROM ubuntu:18.04

RUN apt-get update \
    && apt-get install -y curl gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_8.x -o /tmp/node_setup.sh \
    && bash /tmp/node_setup.sh \
    && rm /tmp/node_setup.sh \
    && apt-get install -y nodejs git make g++ libboost-dev libboost-system-dev libboost-date-time-dev \
    && git clone https://github.com/mineqrl/xmr-node-proxy-qrl.git /xmr-node-proxy \
##    && mkdir xmr-node-proxy \
    && cd /xmr-node-proxy
    
WORKDIR /xmr-node-proxy
ADD . .
COPY config_example.json config.json
#    && cd /xmr-node-proxy \
RUN npm install \
    && openssl req -subj "/C=IT/ST=Pool/L=Daemon/O=Mining Pool/CN=mining.proxy" -newkey rsa:2048 -nodes -keyout cert.key -x509 -out cert.pem -days 36500

EXPOSE 8900 8443 4545 8081 18081
#EXPOSE 9080 9443 9333 9081

#WORKDIR /xmr-node-proxy
#CMD ./update.sh && node proxy.js
CMD node proxy.js
