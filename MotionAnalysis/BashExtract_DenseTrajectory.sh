#!/bin/bash

# This code is used to bash compute densetrajectory of multiple videos;
# You should put this .sh file in the same folder with the videos.
# Videos should be named like: " cloth1.mov, cloth2.mov, cloth3.mov..."
# If videos are with other names or other extensions, change the "cloth*" AND ".mov" in this script.


# To run this code, open terminal, cd to "example" folder
# type in:
# bash BashDenseTrajectory.sh

# 11/20/2016 wenyan bi <wb1918a@student.american.edu> wrote it
# ------------------------------------------------------------------------------------------------------------------------------#


# [wb]: 1. Move video files into seperate folders
for file in vid*; do
if [[ -f "$file" ]]; then
mkdir "${file%.*}"
mv "$file" "${file%.*}"
fi
done





# [wb]: 2. Bash compute multiple video files
DIRS=$(find . -name "vid*" -type d ) # find all folders start with cloth
                                                              # count=0
for i in $DIRS; do
    echo ################################################################################ \\
    echo ################################################################################ \\
    echo currently working folder: ${i##*/}    # show only folder name but not path
    # echo folder: $i          # show both folder name and path
    cd $i


    # If an effective feature already exists (feature_SIZE larger than 1MB), don't run the code
    count=`ls -1 *.gz 2>/dev/null | wc -l`
    if [ $count != 0 ]
    then
        feature_SIZE=`stat -f "%z" "${i##*/}.gz"`
        if [ "$feature_SIZE" -gt 1024 ]
        then
            echo "!!!!!! Attention:Features (${i##*/}.gz) already exists! Codes didn't run."
        else
            ../../release/DenseTrack ./${i##*/}.mov | gzip > ./${i##*/}.gz
        fi
    else
        ../../release/DenseTrack ./${i##*/}.mov | gzip > ./${i##*/}.gz
    fi



    # If an effective faeture already exists (feature_SIZE larger than 1MB): remove the original video to save space
    feature_SIZE=`stat -f "%z" "${i##*/}.gz"`

    if [ "$feature_SIZE" -gt 1024 ]
    then
        # echo $feature_SIZE
        rm -f ${i##*/}.mov
    else
        echo "!!!!!! ATTENTION:feature_SIZE (${i##*/}.gz) is smaller than 1MB in size, might be wrong."
        echo ################################################################################ \\
    fi
    cd ..
done
