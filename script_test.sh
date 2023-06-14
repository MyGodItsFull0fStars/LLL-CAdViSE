#!/bin/bash
docker stop prometheus
docker rm prometheus

docker run -d \
--name=prometheus \
-p 9091:9090 \
-v ~/LLL-CAdViSE/prometheus.yml:/opt/prometheus/prometheus.yml \
prom/prometheus