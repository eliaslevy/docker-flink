#!/bin/sh

FLINK_VERSION=1.3.2

docker build -f flink/Dockerfile        --build-arg "FLINK_VERSION=$FLINK_VERSION" -t "elevy/flink:v$FLINK_VERSION"              flink       && \
docker build -f jobmanager/Dockerfile   --build-arg "FLINK_VERSION=$FLINK_VERSION" -t "elevy/flink_jobmanager:v$FLINK_VERSION"   jobmanager  && \
docker build -f taskmanager/Dockerfile  --build-arg "FLINK_VERSION=$FLINK_VERSION" -t "elevy/flink_taskmanager:v$FLINK_VERSION"  taskmanager
