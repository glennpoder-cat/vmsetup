mkdir -p install.log
start() {
    touch "$FILE"_started
}    
finish() {
    touch "$FILE"_finished
    touch "$FILE"
}
