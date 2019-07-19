#!/usr/bin/env bash

export DEBCONF_NONINTERACTIVE_SEEN="true";
export DEBIAN_FRONTEND="noninteractive";

set -xe;
whoami;
apt-get update -qq;
apt-get install -qqy linux-headers-generic software-properties-common htop mtr tmux curl git apt-transport-https ca-certificates p7zip-full python-pip gnupg-agent;

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -;

curl -sL $node_repo | sudo -E bash -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable";

apt-get update -qq;
apt-get install -qqy docker-ce docker-ce-cli containerd.io nodejs;

pip install -q -I ansible==$ansible_version docker==$dockerpy_version docker-compose==$dockercompose_version;

if [ ! -d "./awx" ]; then
  git clone -b $awx_version --single-branch --depth 1 https://github.com/ansible/awx.git;
else
  echo "awx dir exists, skipping clone";
fi

cd awx/installer

ansible-playbook -i inventory install.yml

pip install -q -I ansible-tower-cli==$awx_cli_version;

#setup cli with the defaul config
tower-cli config host http://127.0.0.1;
tower-cli config username admin;
tower-cli config password password;
tower-cli config verify_ssl false;

echo "Waiting awx to launch on 80..."

while ! nc -z localhost 80; do
  sleep 1s;
done

echo "Waiting awx to ping to return 200..."
bash -c 'while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' http://127.0.0.1/api/v2/ping/)" != "200" ]]; do sleep 5; done'

echo "Waiting for 20s to allow awx to come up fully";
sleep 20s;
