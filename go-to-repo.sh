#!/bin/bash
#set -xv

if [ -z "$1" ]
  then
    echo "No repo name supplied."
    echo -e "\nUsage: $0 <repo name> \n"
    exit
fi

REPO_NAME=$1
REPO_MANIFESTS_RELATIVE_PATH=".repo/manifests/"

cd $REPO_MANIFESTS_RELATIVE_PATH
repo_path=$(grep -R "$REPO_NAME" .  |  sed 's/.*path="//; s/" .*//')
echo "Going to " $repo_path " ..."

cd -  > /dev/null 2>&1
cd $repo_path
exec $SHELL
