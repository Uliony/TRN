#!/bin/bash

if [ $# != 3 ]
then
    echo "Please run the script as: "
    echo "bash scripts/run_standalone_train_gpu.sh [DEVICE_ID] [DATASET_ROOT] [PRETRAIN_BNINCEPTION_CKPT]"
    exit 1
fi

get_real_path(){
    if [ "${1:0:1}" == "/" ]; then
        echo "$1"
    else
        realpath -m "$PWD/$1"
    fi
}

DEVICE_ID=$1
DATASET_ROOT=$(get_real_path "$2")
PRETRAIN_BNINCEPTION_CKPT=$(get_real_path "$3")

# Check the pre-trained model checkpoint
if [ ! -f "$PRETRAIN_BNINCEPTION_CKPT" ]
then
  echo "Cannot find the specified pre-trained BNInception model \"$PRETRAIN_BNINCEPTION_CKPT\"."
  exit 1
fi

# Check the specified dataset root directory
if [ ! -d "$DATASET_ROOT" ]
then
  echo "The specified dataset root is not an existing directory: \"$DATASET_ROOT\"."
  exit 1
fi

# Specifying the log file
LOGS_DIR="train-logs"
LOG_FILE="./$LOGS_DIR/train.log"

# Create a directory for logs if necessary
if [ ! -d "$LOGS_DIR" ]
then
  mkdir "$LOGS_DIR"
fi

# Run the training
echo "Start standalone training in the background."

export CUDA_VISIBLE_DEVICES=$DEVICE_ID
python train.py --dataset_root="$DATASET_ROOT" \
  --device_id=0 \
  --pre_trained_backbone="$PRETRAIN_BNINCEPTION_CKPT" > "$LOG_FILE" 2>&1 &
