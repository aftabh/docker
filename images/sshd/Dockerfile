FROM ubuntu:16.04

MAINTAINER aftabh

#
# environment variables
#
ENV ADMIN=admin

#
# port
#
EXPOSE 22

#
# provision
#
RUN adduser --disabled-password -gecos '' --shell /bin/bash $ADMIN && \
  adduser $ADMIN sudo && \
\
  apt-get update && apt-get install -y \
    aptitude \
    build-essential \
    curl \
    git-core \
    less \
    locate \
    net-tools \
    netcat \
    python-software-properties \
    software-properties-common \
    vim \
    wget \
    openssh-server \
    supervisor && \
\
  mkdir -p /var/run/sshd && \
  mkdir -p /var/log/supervisor && \
\
  apt-get install -y sudo && \
    chmod 440 /etc/sudoers && \
\
  locale-gen en_US.UTF-8

COPY config/sudoers /etc/sudoers
COPY config/supervisor.conf /etc/supervisor/conf.d/sshd.conf

#
# volume
#
VOLUME ["/home/$ADMIN/.ssh", "/admin", "/workspace"]


#
# entry-point
#

# ENTRYPOINT ["/usr/bin/supervisord"]
