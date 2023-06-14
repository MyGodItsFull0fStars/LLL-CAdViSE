#!/bin/bash
docker stop prometheus
docker rm prometheus

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
  --hostname netdata \
  --network monitoring \
  --restart unless-stopped \
  --cap-add SYS_PTRACE \
  --security-opt apparmor=unconfined \
  netdata/netdata

docker run -d \
--name=prometheus \
-p 9091:9090 \
-v ~/LLL-CAdViSE/prometheus_test.yml:/opt/prometheus/prometheus.yml \
--network monitoring \
prom/prometheus