#!/bin/bash

THIS_DIR="$(cd $(dirname ${BASH_SOURCE}); pwd)"
SCREEN_LOG="/tmp/screen_brunch.$(date +%F-%H%M).$$.log"


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

    cd "${THIS_DIR}/.."
    echo "[INFO] Save screen log ${SCREEN_LOG}"
    screen -d -m -S brunch script -f -c "./node_modules/.bin/brunch watch" ${SCREEN_LOG}
    sleep 0.5
    screen -ls brunch
}
main "$@"
