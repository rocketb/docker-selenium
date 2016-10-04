#!/bin/bash

export GEOMETRY="$SCREEN_WIDTH""x""$SCREEN_HEIGHT""x""$SCREEN_DEPTH"

if [ -z "$HUB_PORT_4444_TCP_ADDR" ]; then
  echo Not linked with a running Hub container 1>&2
  exit 1
fi

REMOTE_HOST_PARAM=`hostname -I | awk '{print $1}'`:8080
if [ ! -z "$REMOTE_HOST" ]; then
  echo "REMOTE_HOST variable is set, appending ${REMOTE_HOST}"
  REMOTE_HOST_PARAM=$REMOTE_HOST
fi

if [ ! -z "$PHANTOMJS_OPTS" ]; then
  echo "appending phantomjs options: ${PHANTOMJS_OPTS}"
fi

function shutdown {
  kill -s SIGTERM $NODE_PID
  wait $NODE_PID
}

phantomjs --webdriver=$REMOTE_HOST_PARAM ${PHANTOMJS_OPTS} --webdriver-selenium-grid-hub=http://$HUB_PORT_4444_TCP_ADDR:$HUB_PORT_4444_TCP_PORT
NODE_PID=$!

trap shutdown SIGTERM SIGINT
wait $NODE_PID
