FROM ubuntu/sshd:16.04

MAINTAINER aftabh

#
# environment variable
#
ENV ADMIN=admin \
REPO_SRC='deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse' \
DB_PATH='/workspace/data/mongodb' \
SOURCE_PATH='/etc/apt/sources.list.d/mongodb-org-3.0.list' \
DB_LOGS='/workspace/logs/mongodb'

#
# add config files
#
COPY config/mongodb.conf /etc/supervisor/conf.d/
COPY config/mongodb.sh   /opt/mongodb.sh

#
# provision
#
RUN echo $REPO_SRC > $SOURCE_PATH  && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
  apt-get update && \
  apt-get install -y mongodb-org && \
\
  adduser $ADMIN mongodb && \
  mkdir -p $DB_PATH && \
  chown $ADMIN:$ADMIN $DB_PATH && \
\
  sed -i "s|__ADMIN__|$ADMIN|" /etc/supervisor/conf.d/mongodb.conf && \
  sed /opt/mongodb.sh \
    -e "s|__ADMIN__|$ADMIN|" \
    -e "s|__DB_PATH__|$DB_PATH|" \
    -e "s|__DB_LOGS__|$DB_LOGS|" > /opt/mongodb.tmp.sh && \
  mv /opt/mongodb.tmp.sh /opt/mongodb.sh && \
  chown $ADMIN:$ADMIN /opt/mongodb.sh && \
  chmod 555 /opt/mongodb.sh && \
\
  locale-gen en_US en_US.UTF-8 && \
  dpkg-reconfigure locales && \
\
  rm -rf /var/lib/mongodb/ && \
\
  locale-gen en_US.UTF-8


#
# container entry point
#

# ENTRYPOINT ["/usr/bin/supervisord"]
