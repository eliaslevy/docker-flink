#!/bin/sh

export FLINK_JOBMANAGER_RPC_ADDRESS=${FLINK_JOBMANAGER_RPC_ADDRESS:-$(hostname -f)}

if [ "$1" = "help" ]; then
  echo "Usage: $(basename "$0") (jobmanager|taskmanager|historyserver|local|help)"
  exit 0

elif [ "$1" = "jobmanager" ]; then
  export FLINK_JOBMANAGER=true
  confd -onetime -backend env || exit 1

  echo "Starting Job Manager"
  echo "config file: " && grep '^[^\n#]' /opt/flink/conf/flink-conf.yaml
  exec /opt/flink/bin/jobmanager.sh start-foreground cluster

elif [ "$1" = "taskmanager" ]; then
  export FLINK_TASKMANAGER=true
  export FLINK_TASKMANAGER__NUMBEROFTASKSLOTS="${FLINK_TASKMANAGER__NUMBEROFTASKSLOTS:-$(grep -c ^processor /proc/cpuinfo)}"
  confd -onetime -backend env || exit 1

  echo "Starting Task Manager"
  echo "config file: " && grep '^[^\n#]' /opt/flink/conf/flink-conf.yaml
  exec /opt/flink/bin/taskmanager.sh start-foreground

elif [ "$1" = "historyserver" ]; then
  export FLINK_HISTORYSERVER=true
  confd -onetime -backend env || exit 1

  echo "Starting History Server"
  echo "config file: " && grep '^[^\n#]' /opt/flink/conf/flink-conf.yaml
  exec /opt/flink/bin/historyserver.sh start-foreground

elif [ "$1" = "local" ]; then
  export FLINK_JOBMANAGER=true
  export FLINK_TASKMANAGER=true
  confd -onetime -backend env || exit 1

  echo "Starting local cluster"
  exec flink /opt/flink/bin/jobmanager.sh start-foreground local

else
  exec "$@"
fi

