#!/bin/bash

declare -a blocks_arr=("1" "2" "3" "4" "5" "6" "7" "8" "12" "16" "32" "64" "72" "128")
N_VALUES=2048

for BLOCKS in "${blocks_arr[@]}"
do
    echo -n "$BLOCKS"
    nvfortran src/matmul_block_v2_loop.F90 -o tables/exec/mmbv2_${BLOCKS}.x -DN_VALUES=${N_VALUES} -DBLOCKS=${BLOCKS} -stdpar=gpu -gpu=managed
    if [ $? -ne 0 ]
    then
        exit 1
    fi
    echo " [c]"
    ./tables/exec/mmbv2_${BLOCKS}.x >> tables/block_size_gpu.dat
done

