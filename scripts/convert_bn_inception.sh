#!/bin/bash

if [ $# != 2 ]
then
    echo "Please run the script as: "
    echo "bash scripts/convert_bn_inception.sh [TORCH_CKPT_PATH] [MS_CKPT_OUT_PATH]"
    exit 1
fi

get_real_path(){
    if [ "${1:0:1}" == "/" ]; then
        echo "$1"
    else
        realpath -m "$PWD/$1"
    fi
}

TORCH_CKPT_PATH=$(get_real_path "$1")
MS_CKPT_OUT_PATH=$(get_real_path "$2")

echo "Convert ${TORCH_CKPT_PATH}"
python src/convert_bn_inception.py --torch_ckpt_path "$TORCH_CKPT_PATH" --ms_ckpt_out_path "$MS_CKPT_OUT_PATH"

echo "Saved to ${MS_CKPT_OUT_PATH}"

