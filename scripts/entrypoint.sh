#!/bin/bash

# set name and email to use for commits made by this container
git config --global user.email "$GIT_EMAIL"
git config --global user.name "$GIT_USERNAME"

# configure access to remote git repo if defined
mkdir ~/.ssh
if [ -n "$GIT_RSA_DEPLOY_KEY" ]; then
  echo "Installing rsa key from var"
  echo "$GIT_RSA_DEPLOY_KEY" > ~/.ssh/id_rsa
fi
if [ -n "$GIT_RSA_DEPLOY_KEY_FILE" ]; then
  echo "Installing rsa key from file"
  cp $GIT_RSA_DEPLOY_KEY_FILE ~/.ssh/id_rsa
fi
chmod -R go-rx ~/.ssh

# Init ssh connection to git repo
if [ -n "$REMOTE_NAME" ]  && [ -n "$REMOTE_URL" ]; then
    git_hostname=`echo $REMOTE_URL | sed -e 's#.*\@\(.*\):.*#\1#'`
    ssh-keyscan -H $git_hostname >> ~/.ssh/known_hosts
fi

# test if local git repo already exists, if not clone or init
if [ ! -d .git ]; then

  # clone remote repo if defined
  if [ -n "$REMOTE_NAME" ] && [ -n "$REMOTE_URL" ]; then

    # check if there is something in directory
    files_count=`ls -a | wc -l`
    if [ $files_count -gt 2 ]; then
      if [ -n "$FORCE_CLONE" ] && [ $FORCE_CLONE = "yes" ]; then
        rm -fr ./*
        rm -fr ./.*
      else
        echo "Directory not empty and FORCE_CLONE not set so stopping"
        exit 1
      fi
    fi

    echo "Cloning from $REMOTE_URL"
    git clone -b $REMOTE_BRANCH $REMOTE_URL .

  else
    echo "No remote configured, just init"
    git init
  fi

fi

# Fetch last commits of remote repo if defined
if [ -n "$REMOTE_NAME" ] && [ -n "$REMOTE_URL" ]; then
  # set new url for remote
  echo "Setup remote $REMOTE_NAME to $REMOTE_URL"
  git remote rm $REMOTE_NAME &> /dev/null
  git remote add $REMOTE_NAME $REMOTE_URL

  echo "Fetch remote repo"
  git fetch $REMOTE_NAME
  echo "Reset to upstream state"
  git reset --hard $REMOTE_NAME/$REMOTE_BRANCH
fi

# execute CMD
exec "$@"
