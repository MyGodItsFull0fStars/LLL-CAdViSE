#!/bin/bash

sudo yum -y install docker jq git &>/dev/null

sudo service docker start
sudo git clone --depth 1 --single-branch --branch master https://github.com/cd-athena/wondershaper.git /home/ec2-user/wondershaper

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

sudo docker pull babakt/lll-cadvise-client:latest &>/dev/null
sudo docker run --rm -d --name "lll-cadvise-client" -p 5900:5900 -v /dev/shm:/dev/shm babakt/lll-cadvise-client:latest

sudo docker cp /home/ec2-user/config.json "lll-cadvise-client:/home/seluser/cadvise/config.json"
sudo docker exec -d "lll-cadvise-client" sudo pm2 start server.js

exit 0
