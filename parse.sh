#!/bin/bash

#File:  stream_c_*MHz.txt

# Each kernel will be executed 10 times.
#  The *best* time for each kernel (excluding the first iteration)
#  will be used to compute the reported bandwidth.
# -------------------------------------------------------------
# Number of Threads requested = 52
# Number of Threads counted = 52
# -------------------------------------------------------------
# Your clock granularity/precision appears to be 1 microseconds.
# Each test below will take on the order of 1752 microseconds.
#    (= 1752 clock ticks)
# Increase the size of the arrays if this shows that
# you are not getting at least 20 clock ticks per test.
# -------------------------------------------------------------
# WARNING -- The above is only a rough guideline.
# For best results, please be sure you know the
# precision of your system timer.
# -------------------------------------------------------------
# Function    Best Rate MB/s  Avg time     Min time     Max time
# Copy:          119219.9     0.001383     0.001342     0.001474
# Scale:          90345.8     0.001794     0.001771     0.001919
# Add:           166550.8     0.001535     0.001441     0.001778
# Triad:         128005.2     0.001880     0.001875     0.001882
# -------------------------------------------------------------
# Solution Validates: avg error less than 1.000000e-13 on all three arrays

FREQS=(800 1600 2400)
UC_FREQS=(800000 1600000 2400000)

for uc_freq in ${UC_FREQS[@]}; do

  for freq in "${FREQS[@]}"; do
    copy_rate=$(grep "Copy:" stream_c_${uc_freq}_${freq}MHz.txt | awk '{print $2}')
    scale_rate=$(grep "Scale:" stream_c_${uc_freq}_${freq}MHz.txt | awk '{print $2}')
    add_rate=$(grep "Add:" stream_c_${uc_freq}_${freq}MHz.txt | awk '{print $2}')
    triad_rate=$(grep "Triad:" stream_c_${uc_freq}_${freq}MHz.txt | awk '{print $2}')
    echo "${copy_rate} ${scale_rate} ${add_rate} ${triad_rate}"
  done
  echo ""
done