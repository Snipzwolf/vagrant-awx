#!/usr/bin/env bash

export DEBCONF_NONINTERACTIVE_SEEN="true";
export DEBIAN_FRONTEND="noninteractive";

set -xe;
whoami;
apt-get update -qq;
apt-get upgrade -qqy;
apt-get autoremove -qqy;
apt-get install -qqy linux-headers-generic software-properties-common python-software-properties htop mtr tmux curl git apt-transport-https ca-certificates p7zip-full python-pip gnupg-agent;

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -;

curl -sL $node_repo | sudo -E bash -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable";

apt-get update;
apt-get install docker-ce docker-ce-cli containerd.io nodejs;

pip install -q -I ansible==$ansible_version;
git clone -b $awx_version --single-branch --depth 1 https://github.com/ansible/awx.git;

cd awx/installer
ansible-playbook -i inventory install.yml
