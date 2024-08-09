#!/bin/bash

TIME_LIMIT="90s"

declare -a n_list=("256" "512" "1024" "2048" "4096" "8192" "16384" "32768" "65536")

# CPU serial
echo "Serial"
for N in ${n_list[@]}
do
    echo -n "${N}: "
    nvfortran src/matmul_loop.f90 -cpp -o tables/exec/mml_s.x -DN_VALUES=${N} -DBUILD_TYPE="'ser'"
    echo -n "[c] "
    timeout ${TIME_LIMIT} ./tables/exec/mml_s.x >> ./tables/block_opt.dat
    if [ $? -ne 0 ]
    then
        echo "Cancelled (exceeded ${TIME_LIMIT})"
        break
    fi
    echo "Done"
done

# CPU multicore
echo "Multicore"
for N in ${n_list[@]}
do
    echo -n "${N}: "
    nvfortran src/matmul_loop.f90 -cpp -o tables/exec/mml_m.x -DN_VALUES=${N} -DBLOCKS=8 -DBUILD_TYPE="'mul'" -stdpar=multicore
    echo -n "[c] "
    timeout ${TIME_LIMIT} ./tables/exec/mml_m.x >> ./tables/block_opt.dat
    if [ $? -ne 0 ]
    then
        echo "Cancelled (exceeded ${TIME_LIMIT})"
        break
    fi
    echo "Done"
done

# GPU
echo "GPU"
for N in ${n_list[@]}
do
    echo -n "${N}: "
    nvfortran src/matmul_loop.f90 -cpp -o tables/exec/mml_g.x -DN_VALUES=${N} -DBLOCKS=128 -DBUILD_TYPE="'gpu'" -stdpar=gpu -gpu=managed
    echo -n "[c] "
    timeout ${TIME_LIMIT} ./tables/exec/mml_g.x >> ./tables/block_opt.dat
    if [ $? -ne 0 ]
    then
        echo "Cancelled (exceeded ${TIME_LIMIT})"
        break
    fi
    echo "Done"
done


