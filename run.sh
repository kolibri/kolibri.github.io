#!/bin/bash

    echo $GID
set -e
IMAGE_NAME='website'

run_action() {
  action=$1
  if [[ "run" = "$action" ]]; then ## run default or command
    docker_run ${@:2}

  elif [[ "build" = "$action" ]]; then ## docker container
    run_cmd docker build -t "$IMAGE_NAME:creator" --target creator .
    run_cmd docker build -t "$IMAGE_NAME:webserver" --target webserver .

  elif [[ "create" = "$action" ]]; then ## docker container
    docker_run creator python website.py
    cp styles.css out/styles.css

  elif [[ "serve" = "$action" ]]; then ## docker container
    run_cmd docker run -ti --volume `pwd`/:/website -p 8009:80 "$IMAGE_NAME:webserver"

  elif [[ "help" = "$action" ]]; then ## displays help
    fn=$(basename "$0")
    echo "## Available targets:"
    grep -E 'if\s.*##' $fn | sed 's/.*"\(.*\)" = "$action".*## \(.*\)$/\1: \2/g'
  else
    run_action help
  fi
}

docker_run() {
    target=${1:?'target required'}

    set -x
    run_cmd docker run -ti --volume `pwd`/:/website "$IMAGE_NAME:$target" "${@:2}"
    #sudo chown -R ko:users ./
    set +x
}

run_cmd() {
  set -x
  "$@"
  set +x
}

run_action "$@"
