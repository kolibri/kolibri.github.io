#!/bin/bash

    echo $GID
set -e
IMAGE_NAME='website'

run_action() {
  action=$1
  if [[ "run" = "$action" ]]; then ## run default or command
    docker_run ${@:2}

  elif [[ "build" = "$action" ]]; then ## docker container
    run_cmd docker build -t "$IMAGE_NAME" .

  elif [[ "help" = "$action" ]]; then ## displays help
    fn=$(basename "$0")
    echo "## Available targets:"
    grep -E 'if\s.*##' $fn | sed 's/.*"\(.*\)" = "$action".*## \(.*\)$/\1: \2/g'
  else
    run_action help
  fi
}

docker_run() {
    set -x
    run_cmd docker run -ti --volume `pwd`/:/website -p 8009:8009 "$IMAGE_NAME" "$@"
    sudo chown -R ko:users ./
    set +x
}

run_cmd() {
  set -x
  "$@"
  set +x
}

run_action "$@"
