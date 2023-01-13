SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
LOGDIR=$SCRIPTPATH/install.log
mkdir -p $LOGDIR
start() {
    touch "${LOGDIR}/${STEP}"_started
}    
finish() {
    touch "${LOGDIR}/${STEP}"_finished
    touch "${LOGDIR}/${STEP}"
}
