#!/bin/bash

# Usage: ./wait-for-it.sh host:port [-t timeout]
# Example: ./wait-for-it.sh db:3306 -t 60

TIMEOUT=15
HOST=""
PORT=""

# Parse the host and port from the arguments
for i in "$@"
do
case $i in
    -t=*|--timeout=*)
    TIMEOUT="${i#*=}"
    shift # past argument=value
    ;;
    *:*)
    HOST=${i%:*}
    PORT=${i#*:}
    shift # past argument with no value
    ;;
esac
done

if [ -z "$HOST" ] || [ -z "$PORT" ]; then
  echo "Usage: $0 host:port [-t timeout]" >&2
  exit 1
fi

echo "Waiting for $HOST:$PORT for up to $TIMEOUT seconds."

# Attempt to connect to the host and port using nc (netcat)
for i in $(seq $TIMEOUT); do
  nc -z "$HOST" "$PORT" > /dev/null 2>&1

  result=$?
  if [ $result -eq 0 ]; then
    echo "$HOST:$PORT is available after $i seconds."
    exit 0
  fi

  sleep 1
done

echo "Timeout occurred after waiting $TIMEOUT seconds for $HOST:$PORT."
exit 1
