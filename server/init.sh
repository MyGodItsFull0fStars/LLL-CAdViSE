#!/bin/bash

mkdir -p /home/ec2-user/dataset/live/

curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -
sudo yum -y install nodejs jq git docker &>/dev/null

config=$(cat /home/ec2-user/config.json)
QoECalc=$(echo "$config" | jq -r '.QoECalc')

if [[ $QoECalc == 1 ]]; then
  sudo yum -y install gcc72 gcc72-c++ python38 python38-pip python38-devel &>/dev/null
fi

docker run -d --name=netdata \
  -p 19999:19999 \
  -v netdataconfig:/etc/netdata \
  -v netdatalib:/var/lib/netdata \
  -v netdatacache:/var/cache/netdata \
  -v /etc/passwd:/host/etc/passwd:ro \
  -v /etc/group:/host/etc/group:ro \
  -v /proc:/host/proc:ro \
  -v /sys:/host/sys:ro \
  -v /etc/os-release:/host/etc/os-release:ro \
  --restart unless-stopped \
  --cap-add SYS_PTRACE \
  --security-opt apparmor=unconfined \
  netdata/netdata

git clone --depth 1 --single-branch --branch master https://github.com/cd-athena/wondershaper.git /home/ec2-user/wondershaper

if [[ $QoECalc == 1 ]]; then
  git clone --depth 1 --single-branch --branch master https://github.com/itu-p1203/itu-p1203.git /home/ec2-user/p1203
fi

cd /home/ec2-user/ || exit 1
sudo npm i && sudo npm i -g pm2
sudo ln -s /home/ec2-user/node_modules/ffmpeg-static/ffmpeg /bin/ffmpeg
sudo ln -s /home/ec2-user/node_modules/ffprobe-static/bin/linux/x64/ffprobe /bin/ffprobe

if [[ $QoECalc == 1 ]]; then
  sudo pip-3.8 install Cython ./p1203/
fi

exit 0
