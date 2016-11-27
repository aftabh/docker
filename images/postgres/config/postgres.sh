#!/bin/bash

ADMIN=__ADMIN__
PG_VERSION=__PG_VERSION__
DB_PATH=__DB_PATH__
DB_LOGS=__DB_LOGS__

DB_PATH=${DB_PATH}/${PG_VERSION}


initdb() {
	mkdir -p $DB_PATH $DB_LOGS

	chown $ADMIN:$ADMIN $DB_PATH $DB_LOGS

	sudo -u $ADMIN /usr/lib/postgresql/${PG_VERSION}/bin/initdb \
		--auth=trust \
		--auth-host=trust \
		--encoding=UTF8 \
		--pgdata=$DB_PATH > $DB_LOGS/initdb.log
}

check-config() {
	sed -i "s|#listen_addresses = 'localhost'|listen_addresses = '*'|" $DB_PATH/postgresql.conf

	UPDATE_HBA=$( grep 'IPv4 custom local connections' $DB_PATH/pg_hba.conf)

	if [[ -z $UPDATE_HBA ]]; then
        echo ''                                                                      >> $DB_PATH/pg_hba.conf
        echo '#'                                                                     >> $DB_PATH/pg_hba.conf
        echo '# IPv4 custom local connections:'                                      >> $DB_PATH/pg_hba.conf
        echo '#'                                                                     >> $DB_PATH/pg_hba.conf
        echo 'host    all             all             172.0.0.0/8             trust' >> $DB_PATH/pg_hba.conf
        echo 'host    all             all             192.168.2.0/16          trust' >> $DB_PATH/pg_hba.conf
	fi
}

if [[ ! -d $DB_PATH ]]; then
	initdb
fi

check-config

exec sudo -u $ADMIN /usr/lib/postgresql/${PG_VERSION}/bin/postmaster -D $DB_PATH
