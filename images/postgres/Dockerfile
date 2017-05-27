FROM ubuntu/sshd:16.04

MAINTAINER aftabh

#
# environment variable
#
ENV \
  ADMIN=admin \
\
  REPO_SRC='deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' \
  SOURCE_PATH='/etc/apt/sources.list.d/postgres.list' \
\
  PG_VERSION='9.6' \
  PG_ADMIN='postgres'

ENV \
  PG_HOME="/workspace/data/postgres/${PG_VERSION}" \
  PG_LOGS="/workspace/logs/postgres/${PG_VERSION}" \
  LANG='en_US.utf8'

#
# provision
#
RUN echo $REPO_SRC > $SOURCE_PATH  && \
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
  apt-get update && \
  apt-get install -y postgresql-${PG_VERSION}

#
# add config files
#
COPY config/postgres.conf /etc/supervisor/conf.d/
COPY scripts/postgres.sh /opt/postgres.sh
COPY scripts/postgres-env.sh /opt/postgres-env.sh

#
# update
#
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
  sed \
    -e "s|__ADMIN__|$ADMIN|" \
    -e "s|__PG_LOGS__|$PG_LOGS|" \
    -i /etc/supervisor/conf.d/postgres.conf /etc/supervisor/conf.d/postgres.conf && \
  sed \
    -e "s|__PG_ADMIN__|$PG_ADMIN|" \
    -e "s|__PG_VERSION__|$PG_VERSION|" \
    -e "s|__PG_HOME__|$PG_HOME|" \
    -e "s|__PG_LOGS__|$PG_LOGS|" \
    -i /opt/postgres-env.sh /opt/postgres-env.sh && \
  chown $ADMIN:$ADMIN /opt/postgres.sh /opt/postgres-env.sh && \
  chmod 555 /opt/postgres.sh /opt/postgres-env.sh

#
# port
#
EXPOSE 5432

#
# volume
#
VOLUME ["/home/$ADMIN/.ssh", "/workspace", "$PG_HOME", "$PG_LOGS"]

#
# run container
#
ENTRYPOINT ["/usr/bin/supervisord"]
