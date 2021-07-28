#!/bin/bash

# Go up to the directory where .repo exists. 
# Similar effect with croot function defined in <android>/build/envsetup.sh
# Ref: https://unix.stackexchange.com/a/13474
function upsearch () {
    test / == "$PWD" && return || test -e "$1" && echo "found: " "$PWD" && return || cd .. && upsearch "$1"
}

