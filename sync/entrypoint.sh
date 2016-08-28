#!/bin/bash

# extract machine name from $REMOTE_URL 
MACHINE=$(echo $REMOTE_URL | sed -e 's#.*://\([^/]*\)/.*#\1#')

# tell git which credentials to use for commit
cat <<EOF > /root/.git-credentials
https://$USERNAME:$TOKEN@$MACHINE
EOF
git config --global credential.helper store

# set name and email to use for commits made by this container
git config --global user.email "$EMAIL"
git config --global user.name "$USERNAME"

# test if "git init" has already been performed
# if not, do it now.
if [ ! -d .git ]; then
    git init
fi

# set new url for remote
git remote rm $REMOTE &> /dev/null
git remote add $REMOTE $REMOTE_URL

# execute CMD
exec "$@"
