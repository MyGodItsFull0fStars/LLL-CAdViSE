#!/usr/bin/env bash

MONITORING_NETWORK="monitoring"
PROMETHEUS_CONFIG_PATH="<path/to/prometheus.yml>"

docker stop netdata
docker rm netdata

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
  --network $MONITORING_NETWORK \
  --restart unless-stopped \
  --cap-add SYS_PTRACE \
  --security-opt apparmor=unconfined \
  netdata/netdata

docker stop prometheus
docker rm prometheus

docker run -d \
    --name=prometheus \
    --network $MONITORING_NETWORK \
    -p 9090:9090 \
    -v $PROMETHEUS_CONFIG_PATH:/etc/prometheus/prometheus.yml \
    prom/prometheus
