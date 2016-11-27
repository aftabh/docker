FROM ubuntu/sshd:16.04

MAINTAINER aftabh

#
# environment variable
#
ENV ADMIN=admin \
REPO_SRC='deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' \
PG_VERSION='9.5' \
DB_PATH='/workspace/data/postgres' \
SOURCE_PATH='/etc/apt/sources.list.d/postgres.list' \
DB_LOGS='/workspace/logs/postgres'

#
# add config files
#
COPY config/postgres.conf /etc/supervisor/conf.d/
COPY config/postgres.sh /opt/postgres.sh

#
# provision
#
RUN echo $REPO_SRC > $SOURCE_PATH  && \
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
  apt-get update && \
  apt-get install -y postgresql-${PG_VERSION} && \
\
  adduser $ADMIN postgres && \
  mkdir -p $DB_PATH && \
  chown $ADMIN:$ADMIN $DB_PATH && \
\
  sed -i "s|__ADMIN__|$ADMIN|" /etc/supervisor/conf.d/postgres.conf && \
  sed /opt/postgres.sh \
    -e "s|__ADMIN__|$ADMIN|" \
    -e "s|__PG_VERSION__|$PG_VERSION|" \
    -e "s|__DB_PATH__|$DB_PATH|" \
    -e "s|__DB_LOGS__|$DB_LOGS|" > /opt/postgres.tmp.sh && \
  mv /opt/postgres.tmp.sh /opt/postgres.sh && \
  chown $ADMIN:$ADMIN /opt/postgres.sh && \
  chmod 555 /opt/postgres.sh && \
\
  locale-gen en_US en_US.UTF-8 && \
  dpkg-reconfigure locales && \
\
  sudo rm -rf /etc/postgresql && \
  sudo rm -rf /var/lib/postgresql

#
# container entry point
#

# ENTRYPOINT ["/usr/bin/supervisord"]
