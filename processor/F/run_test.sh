#1/bin/bash

while getopts ":t:" option; do
    case $option in
        t)
            cat tests/$OPTARG > test_t.v
            ;;
    esac
done

vcs -full64 -debug_all -v2005 -f master_fetch
./simv
dve -full64
