#!/bin/bash

# test if "git init" has already been performed
# if not, do it now:
if [ ! -d .git ]; then
    git init
fi

# set name and email to use for commits made by this container
git config --global user.email "$GIT_EMAIL"
git config --global user.name "$GIT_USERNAME"

if [ $REMOTE_NAME ]  && [ $REMOTE_URL ]  && [ $TOKEN ]; then
    git config --global credential.helper store

    # extract machine name from $REMOTE_URL 
    MACHINE=$(echo $REMOTE_URL | sed -e 's#.*://\([^/]*\)/.*#\1#')

    # tell git which credentials to use for commit
    echo "https://$GIT_USERNAME:$TOKEN@$MACHINE" > /root/.git-credentials

    # set new url for remote
    git remote rm $REMOTE_NAME &> /dev/null
    git remote add $REMOTE_NAME $REMOTE_URL
fi

# execute CMD
exec "$@"
