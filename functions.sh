mkdir -p install.log
functon start {
    touch "$FILE"_started
}    
functon finish {
    touch "$FILE"_finished
    touch "$FILE"
}
