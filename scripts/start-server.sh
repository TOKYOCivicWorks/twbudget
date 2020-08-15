#!/bin/bash

THIS_DIR="$(cd $(dirname ${BASH_SOURCE}); pwd)"
SCREEN_LOG="/tmp/screen_server.$(date +%F-%H%M).$$.log"


usage() {
    echo "Usage: $(basename $0) [OPTION]"
    echo "OPTION:"
    echo "  -h : Print help."
    echo "  -l : For local development (Use twitter proxy host at localhost)."
    echo "  -p : Use production environment (Set NODE_ENV as production)."
    echo "  -s : Use staging environment (Set NODE_ENV as staging)."
}

main() {
    cd "${THIS_DIR}/.."
    if [[ -e "${THIS_DIR}/.setuprc" ]]; then
        . "${THIS_DIR}/.setuprc"
    fi

    prefix=""
    while getopts hlps OPT; do
        case ${OPT} in
            h) usage
               return 0
               ;;
            # Use externally accessible IP for access from devices in the same network.
            l) DEFAULT_IF="$(netstat -nr | grep '^0.0.0.0' | awk '{print $8}')"
               IP="$(ifconfig | grep -A1 ^${DEFAULT_IF} | tail -1 | awk '{print $2}')"

               if [[ "${prefix}" = "" ]]; then
                   prefix="env"
               fi
               prefix="${prefix} TWITTER_PROXY_HOST=${IP} WEB_HOST=${IP}"
               echo "[INFO] Set TWITTER_PROXY_HOST=${IP} WEB_HOST=${IP}"
               ;;
            p) if [[ "${prefix}" = "" ]]; then
                   prefix="env"
               fi
               prefix="${prefix} NODE_ENV=production"
               ;;
            s) if [[ "${prefix}" = "" ]]; then
                   prefix="env"
               fi
               prefix="${prefix} NODE_ENV=staging"
               ;;
        esac
    done

    echo "[INFO] Save screen log ${SCREEN_LOG}"
    screen -d -m -S server script -f -c "${prefix} make run" ${SCREEN_LOG}
    sleep 0.5
    screen -ls server
}
main "$@"
