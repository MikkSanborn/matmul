#!/bin/bash

DIR="/home/mgsanbor/matmul"

FC_VER=$(nvfortran --version | awk 'NR==2 {print $1 "-" $2}')

cd "${DIR}"
declare -a build_types=("accelerated" "serial" "multicore")
#declare -a build_types=("accelerated" "multicore")
#declare -a build_types=("accelerated")

if ! [ -f "tables/table_${FC_VER}.dat" ]
then
    echo "programname_compiletype time flops flops_time sum_c N" >> tables/table_${FC_VER}.dat
fi

for BUILD_TYPE in "${build_types[@]}"
do
    echo "${BUILD_TYPE}"

    cmake -B build -S . --install-prefix="${DIR}/install" --preset="${BUILD_TYPE}" && cmake --build build --target install || exit 1

    for j in {1..3}
    do
        ./install/bin/matmul.x | tee -a tables/table_${FC_VER}.dat
        ./install/bin/matmul_block.x | tee -a tables/table_${FC_VER}.dat
        echo 2048 | ./install/bin/matmul_interactive.x | tee -a tables/table_${FC_VER}.dat
    done
done

