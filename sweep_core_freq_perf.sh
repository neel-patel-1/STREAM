#!/bin/bash

FREQS=(800 1600 2400)
UC_FREQS=(800000 1200000 1600000 2000000 2400000)

for uc_freq in "${UC_FREQS[@]}"; do
  echo $uc_freq | sudo tee /sys/devices/system/cpu/intel_uncore_frequency/package_00_die_00/max_freq_khz
  echo $uc_freq | sudo tee /sys/devices/system/cpu/intel_uncore_frequency/package_00_die_00/min_freq_khz
  sleep 1
  for freq in "${FREQS[@]}"; do
    sudo cpupower --cpu all frequency-set --freq ${freq}MHz
    sleep 1
    make clean; make CFLAGS="-fopenmp -DSTREAM_ARRAY_SIZE=10000000 -g" ; export OMP_NUM_THREADS=52; ./stream_c.exe | tee stream_c_${uc_freq}_${freq}MHz.txt
  done
done