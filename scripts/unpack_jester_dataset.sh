#!/bin/bash

if [ $# != 2 ]
then
    echo "Please run the script as: "
    echo "bash scripts/unpack_jester_dataset.sh [DATA_PATH] [TARGET_PATH]"
    exit 1
fi

get_real_path(){
    if [ "${1:0:1}" == "/" ]; then
        echo "$1"
    else
        realpath -m "$PWD/$1"
    fi
}

DATA_PATH=$(get_real_path "$1")
TARGET_PATH=$(get_real_path "$2")

# Check the specified dataset root directory
if [ ! -d "$DATA_PATH" ]
then
  echo "The specified dataset root is not a directory: \"$DATA_PATH\"."
  exit 1
fi

echo "Target data folder: $TARGET_PATH"
mkdir -p "$TARGET_PATH"

echo "Unzip..."
unzip "$DATA_PATH/20bn-jester-download-package-labels.zip" -d "$TARGET_PATH"
unzip "$DATA_PATH/20bn-jester-v1-??.zip" -d "$TARGET_PATH"

cd "$TARGET_PATH" || exit 1
echo "Extract tar archives ..."
cat ./20bn-jester-v1-?? | tar zx -v

echo "Remove unnecessary data..."
rm ./20bn-jester-v1-??.md5
rm ./20bn-jester-v1-??

echo "DONE!"
