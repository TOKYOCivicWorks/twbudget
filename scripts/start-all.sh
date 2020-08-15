#!/bin/bash

THIS_DIR="$(cd $(dirname ${BASH_SOURCE}); pwd)"

main() {
    echo "[INFO] Starting mongod..."
    "${THIS_DIR}"/start-mongod.sh "$@" || exit
    sleep 1

    echo "[INFO] Starting brunch..."
    "${THIS_DIR}"/start-brunch.sh "$@" || exit
    sleep 5

    echo "[INFO] Starting server..."
    "${THIS_DIR}"/start-server.sh "$@" || exit

    echo "[INFO] Starting twitter proxy..."
    "${THIS_DIR}"/start-twitter-proxy.sh "$@" || exit
}
main "$@"
