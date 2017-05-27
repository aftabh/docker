FROM ubuntu/sshd:16.04

MAINTAINER aftabh

#
# environment variable
#
ENV ADMIN=admin \
NVM_VERSION='v0.33.2' \
NODE_DEFAULT='v6.10.3' \
NODE_VERSIONS='v4.8.3:v6.10.3'

#
# provision
#
COPY scripts/nodejs.sh /opt/nodejs.sh

RUN sed \
    -e "s|__ADMIN__|$ADMIN|" \
    -e "s|__NVM_VERSION__|$NVM_VERSION|" \
    -e "s|__NODE_DEFAULT__|$NODE_DEFAULT|" \
    -e "s|__NODE_VERSIONS__|$NODE_VERSIONS|" \
    -i /opt/nodejs.sh /opt/nodejs.sh && \
\
  chown $ADMIN:$ADMIN /opt/nodejs.sh && \
  chmod 555 /opt/nodejs.sh && \
\
  sudo -H -u $ADMIN /opt/nodejs.sh

#
# run container
#
CMD ["/usr/bin/supervisord"]
