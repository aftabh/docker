FROM ubuntu/sshd:16.04

MAINTAINER aftabh

#
# environment variable
#
ENV ADMIN=admin \
NVM_VERSION='v0.32.1' \
NODE_DEFAULT='v4.6.2' \
NODE_VERSIONS='v4.6.2:v6.9.1'

#
# provision
#
COPY config/nodejs.sh /opt/nodejs.sh

RUN sed /opt/nodejs.sh \
     -e "s|__ADMIN__|$ADMIN|" \
     -e "s|__NVM_VERSION__|$NVM_VERSION|" \
     -e "s|__NODE_DEFAULT__|$NODE_DEFAULT|" \
     -e "s|__NODE_VERSIONS__|$NODE_VERSIONS|" > /tmp/nodejs.sh && \
  mv /tmp/nodejs.sh /opt/nodejs.sh && \
  chown $ADMIN:$ADMIN /opt/nodejs.sh && \
  chmod 555 /opt/nodejs.sh && \
\
  sudo -H -u $ADMIN /opt/nodejs.sh
