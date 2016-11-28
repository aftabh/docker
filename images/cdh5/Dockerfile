FROM ubuntu/sshd:16.04

MAINTAINER aftabh

#
# environment variable
#
ENV ADMIN=admin \
REPO_URL='http://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh/cloudera.list' \
SOURCE_PATH='/etc/apt/sources.list.d/cloudera.list' \
REPO_KEY_URL='http://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh/archive.key' \
REPO_KEY_PATH=/tmp/archive.key \
CDH_PREF_FILE='/etc/apt/preferences.d/cloudera.pref' \
JAVE_VERSION=7


#
# provision
#
RUN add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  echo debconf shared/accepted-oracle-license-v1-1 seen   true | debconf-set-selections && \
  apt-get -y -q install "oracle-java${JAVE_VERSION}-installer"


RUN wget $REPO_URL -O $SOURCE_PATH && \
\
  wget $REPO_KEY_URL -O $REPO_KEY_PATH && \
  apt-key add $REPO_KEY_PATH && \
  rm $REPO_KEY_PATH && \
\
  echo 'Package: *'                           >> $CDH_PREF_FILE && \
  echo 'Pin: release o=Cloudera, l=Cloudera'  >> $CDH_PREF_FILE && \
  echo 'Pin-Priority: 501'                    >> $CDH_PREF_FILE && \
\
  apt-get update

#
# container entry point
#

# ENTRYPOINT ["/usr/bin/supervisord"]
