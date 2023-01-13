LOGDIR=$(dirname "$0")/install.log
mkdir -p $LOGDIR
start() {
    touch "${LOGDIR}${STEP}"_started
}    
finish() {
    touch "${LOGDIR}${STEP}"_finished
    touch "${LOGDIR}${STEP}"
}
