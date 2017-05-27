#!/bin/bash

. /opt/postgres-env.sh

db_mkdir() {
    echo 'Preparing postgres database directories ...'

    sudo mkdir -p $PG_DATA_DIR $PG_LOGS
    sudo chown -R $PG_ADMIN:$PG_ADMIN $PG_DATA_DIR $PG_LOGS

    sudo grep $PG_ADMIN /etc/passwd > /dev/null || sudo adduser --home $PG_HOME $PG_ADMIN
    sudo usermod -d $PG_HOME $PG_ADMIN

    echo 'Done.'
}

db_init() {
    echo 'Initializing postgres database cluster ...'

    sudo -u $PG_ADMIN $PG_INSTALL_DIR/bin/initdb \
        --auth=trust \
        --auth-host=trust \
        --encoding=UTF8 \
        --pgdata=$PG_DATA_DIR

    echo 'Done.'
}

db_config() {
    echo 'Updating postgres server configuration files ...'

    if [[ ! -f $PG_DATA_DIR/postgresql.conf ]]; then
        return
    fi

    sed -i "s|#listen_addresses = 'localhost'|listen_addresses = '*'|" $PG_DATA_DIR/postgresql.conf

    UPDATE_HBA=$( grep 'IPv4 custom local connections' $PG_DATA_DIR/pg_hba.conf)

    if [[ -z $UPDATE_HBA ]]; then
        echo ''                                                                      >> $PG_DATA_DIR/pg_hba.conf
        echo '#'                                                                     >> $PG_DATA_DIR/pg_hba.conf
        echo '# IPv4 custom local connections:'                                      >> $PG_DATA_DIR/pg_hba.conf
        echo '#'                                                                     >> $PG_DATA_DIR/pg_hba.conf
        echo 'host    all             all             172.0.0.0/8             trust' >> $PG_DATA_DIR/pg_hba.conf
        echo 'host    all             all             192.168.2.0/16          trust' >> $PG_DATA_DIR/pg_hba.conf
    fi

    echo 'Done.'
}

db_create() {
    echo 'Creating postgres database and user ...'

    sudo -u $PG_ADMIN $PG_INSTALL_DIR/bin/pg_ctl -D $PG_DATA_DIR start

    sleep 5

    if [[ ! -z $PG_DATABASE ]]; then
        sudo -u $PG_ADMIN $PG_INSTALL_DIR/bin/createdb $PG_DATABASE
    fi

    if [[ ! -z $PG_USER ]]; then
        sudo -u $PG_ADMIN $PG_INSTALL_DIR/bin/createuser $PG_USER
    fi

    sudo -u $PG_ADMIN $PG_INSTALL_DIR/bin/pg_ctl stop -D $PG_DATA_DIR

    echo 'Done.'
}

cleanup() {
    echo 'Cleanup ...'

    sudo rm -rf /etc/postgresql
    sudo rm -rf /var/lib/postgresql

    echo 'Done.'
}

IS_INITIALIZED=$( sudo ls -l $PG_DATA_DIR | grep -v total | wc -l | awk '{ print $1 }' )

if [[ $IS_INITIALIZED = 0 ]]; then
    db_mkdir
    db_init
    db_config
    db_create
    cleanup
fi

exec sudo -u $PG_ADMIN $PG_INSTALL_DIR/bin/postmaster -D $PG_DATA_DIR
