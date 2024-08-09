#!/bin/bash

FC_VER=$(nvfortran --version | awk 'NR==2 {print $1 "-" $2}')

cd /home/mgsanbor/matmul
BUILD_TYPE="accelerated"
#BUILD_TYPE="serial"
#BUILD_TYPE="multicore"

if ! [ -f "tables/table_${FC_VER}.dat" ]
then
    echo "programname_compiletype time flops flops_time sum_c N" >> tables/table_${FC_VER}.dat
fi

echo "${BUILD_TYPE}"

rm -f ./install/bin/matmul_interactive.x

cmake -B build -S . --install-prefix=/home/mgsanbor/matmul/install --preset="${BUILD_TYPE}" && cmake --build build --target install || exit 1

for j in {1000..10000..1000}
do
    echo "${j}" | ./install/bin/matmul_interactive.x | tee -a tables/table_b128_${FC_VER}.dat
done

