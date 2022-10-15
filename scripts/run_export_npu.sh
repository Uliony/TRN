#!/bin/bash

if [ $# != 2 ]
then
    echo "Please run the script as: "
    echo "bash scripts/run_export_gpu.sh [DATASET_ROOT] [CKPT_PATH]"
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
CKPT_PATH=$(get_real_path "$2")

# Check the specified checkpoint path
if [ ! -f "$CKPT_PATH" ]
then
  echo "Cannot find the specified model checkpoint \"$CKPT_PATH\"."
  exit 1
fi

# Check the specified dataset root directory
if [ ! -d "$DATASET_ROOT" ]
then
  echo "The specified dataset root is not an existing directory: \"$DATASET_ROOT\"."
  exit 1
fi

# Run export
python export.py --dataset_root="$DATASET_ROOT" --ckpt_file="$CKPT_PATH"
