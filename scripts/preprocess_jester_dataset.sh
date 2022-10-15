#!/bin/bash

if [ $# != 1 ]
then
    echo "Please run the script as: "
    echo "bash scripts/preprocess_jester_dataset.sh [DATASET_ROOT]"
    exit 1
fi

get_real_path(){
    if [ "${1:0:1}" == "/" ]; then
        echo "$1"
    else
        realpath -m "$PWD/$1"
    fi
}

DATASET_ROOT=$(get_real_path "$1")

# Check the specified dataset root directory
if [ ! -d "$DATASET_ROOT" ]
then
  echo "The specified dataset root is not a directory: \"$DATASET_ROOT\"."
  exit 1
fi

python src/preprocess_jester_dataset.py "$DATASET_ROOT"
