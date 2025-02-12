#!/bin/bash

FREQS=(800 1600 2400)

for freq in "${FREQS[@]}"; do
    sudo cpupower --cpu all frequency-set --freq ${freq}MHz
    sleep 1
    make clean; make CFLAGS="-fopenmp -DSTREAM_ARRAY_SIZE=10000000 -g" ; export OMP_NUM_THREADS=52; ./stream_c.exe | tee -a stream_c_${freq}MHz.txt
done