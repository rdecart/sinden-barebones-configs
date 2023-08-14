wget https://github.com/rdecart/sinden-barebones-configs/tree/main/home/pi/one_player_patching_filenames.txt

readarray -t configFiles < one_player_patching_filenames.txt
timestamp=$(date +%s)

read -p "How many Sinden Lightguns do you have? (1|2) " guns && [[ $guns == [1] || $guns == [2] ]] || exit 1
if [ $guns == '1' ]
then
    read -p "Update configs to support 1 gun? (y|N) " confirm && [[ $confirm == [yY] ]] || exit 1
    for file in "${configFiles[@]}"
    do
        echo "backing up: ${file} to: ${file}_${timestamp}"
        cp "${file}" "${file}_${timestamp}"
        sed -i 's/^input_libretro_device_p2/# input_libretro_device_p2/g' "$file"
    done
    echo "Done"
    exit 0
else
    read -p "Update configs to support 2 guns (y|N) " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
    for file in "${configFiles[@]}"
    do
        echo "backing up: ${file} to: ${file}_${timestamp}"
        cp "${file}" "${file}_${timestamp}"
        sed -i 's/^# input_libretro_device_p2/input_libretro_device_p2/g' "$file"
    done
    echo "Done"
    exit 0
fi

