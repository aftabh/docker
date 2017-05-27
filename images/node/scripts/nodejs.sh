#!/bin/bash

ADMIN=__ADMIN__
NVM_VERSION=__NVM_VERSION__
NVM_URL="https://raw.githubusercontent.com/creationix/nvm/$NVM_VERSION/install.sh"
NODE_VERSIONS=__NODE_VERSIONS__
NODE_DEFAULT=__NODE_DEFAULT__


#
# provisioning
#

sudo chown -R $ADMIN:$ADMIN /home/$ADMIN

curl $NVM_URL | bash

sed -i 's|MANPATH=$(manpath)|: # MANPATH=$(manpath)|' /home/$ADMIN/.nvm/nvm.sh

source /home/$ADMIN/.nvm/nvm.sh


NODE_VERSIONS_ARRAY=(${NODE_VERSIONS//:/ })


for NODE_VERSION in "${NODE_VERSIONS_ARRAY[@]}"
do
    echo ""
    echo "Version: $NODE_VERSION"
    echo ""

    nvm install $NODE_VERSION
done

nvm alias default $NODE_DEFAULT
nvm use   default
