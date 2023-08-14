#!/bin/bash

function validate_url(){
  if [[ `wget -S --spider $1  2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then return 0; else return 1; fi
}

CONFIG_PATHS_FILE="one_player_patching_filenames.txt"
URL="https://github.com/rdecart/sinden-barebones-configs/raw/main/home/pi/${CONFIG_PATHS_FILE}"


if validate_url $URL
then
    wget -q -O $CONFIG_PATHS_FILE $URL
    echo -e "\n\nDownloaded updated file list\n\n"
else echo -e "\n\nUnable to download updated file list, will try to use existing one\n\n"
fi

TIMESTAMP=$(date +%s)

readarray -t CONFIG_FILES < $CONFIG_PATHS_FILE

if [ ${#CONFIG_FILES[@]} == '0' ]
then
    echo "Unable to find any filenames to update in "
    exit 1
fi

read -p "How many Sinden Lightguns do you have? (1|2) " GUNS && [[ $GUNS == [1] || $GUNS == [2] ]] || exit 1
echo
if [ $GUNS == '1' ]
then
    read -p "Update configs to support 1 gun? (y|N) " CONFIRM && [[ $CONFIRM == [yY] ]] || exit 1
    for FILE in "${CONFIG_FILES[@]}"
    do
        echo -e "\nbacking up: ${FILE} to: ${FILE}_${TIMESTAMP}"
        cp "${FILE}" "${FILE}_${TIMESTAMP}"
        sed -i 's/^input_libretro_device_p2/# input_libretro_device_p2/g' "$FILE"
    done
    echo "Done"
    exit 0
else
    read -p "Update configs to support 2 guns (y|N) " CONFIRM && [[ $CONFIRM == [yY] || $CONFIRM == [yY][eE][sS] ]] || exit 1
    for FILE in "${CONFIG_FILES[@]}"
    do
        echo -e "\nbacking up: ${FILE} to: ${FILE}_${TIMESTAMP}"
        cp "${FILE}" "${FILE}_${TIMESTAMP}"
        sed -i 's/^# input_libretro_device_p2/input_libretro_device_p2/g' "$FILE"
    done
    echo "Done"
    exit 0
fi

