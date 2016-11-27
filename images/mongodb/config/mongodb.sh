#!/bin/bash

ADMIN=__ADMIN__
DB_PATH=__DB_PATH__
DB_LOGS=__DB_LOGS__


initdb() {
	mkdir -p $DB_PATH $DB_LOGS && chown $ADMIN:$ADMIN $DB_PATH $DB_LOGS
}

check-config() {
	sed -e "s|^  dbPath:[-\.\_/ a-zA-Z0-9]*$|  dbPath: $DB_PATH|" \
        -e "s|^  path:[-\.\_/ a-zA-Z0-9]*$|  path: $DB_LOGS/mongod.log|" \
        -e "s|^  bindIp|#  bindIp|" \
		/etc/mongod.conf > /tmp/mongod.conf && \
\
	sudo mv /tmp/mongod.conf /etc/mongod.conf
}

if [[ ! -d $DB_PATH ]]; then
	initdb
fi

check-config

exec sudo -u $ADMIN /usr/bin/mongod --config /etc/mongod.conf
