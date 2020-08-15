#!/bin/bash

THIS_DIR="$(cd $(dirname ${BASH_SOURCE}); pwd)"
MONGO_DIR="${HOME}/.mongo"
SCREEN_LOG="/tmp/screen_mongod.$(date +%F-%H%M).$$.log"


usage() {
    echo "Usage: $(basename $0) [OPTION]"
    echo "OPTION:"
    echo "  -h : Print help."
}

main() {
    while getopts :h OPT; do
        case ${OPT} in
            h) usage
               return 0
               ;;
        esac
    done

    if [[ ! -d "${MONGO_DIR}" ]]; then
        mkdir -p "${MONGO_DIR}"
    fi

    cd "${THIS_DIR}/.."
    echo "[INFO] Save screen log ${SCREEN_LOG}"
    screen -d -m -S mongod script -f -c "mongod --dbpath ${MONGO_DIR}" ${SCREEN_LOG}
    sleep 0.5
    screen -ls mongod
}
main "$@"
