#!/bin/bash

FREQS=(800 1600 2400)
UC_FREQS=(800000 1600000 2400000)

for uc_freq in "${UC_FREQS[@]}"; do
  echo $uc_freq | sudo tee /sys/devices/system/cpu/intel_uncore_frequency/package_00_die_00/max_freq_khz
  echo $uc_freq | sudo tee /sys/devices/system/cpu/intel_uncore_frequency/package_00_die_00/min_freq_khz
  sleep 1
  for freq in "${FREQS[@]}"; do
    sudo cpupower --cpu all frequency-set --freq ${freq}MHz
    sleep 1
    make clean; make CFLAGS="-fopenmp -O3 -mavx512f -DSTREAM_ARRAY_SIZE=10000000 -g" ; export OMP_NUM_THREADS=10; taskset -c 0-10 ./stream_c.exe | tee stream_c_${uc_freq}_${freq}MHz.txt
  done
done

    #             a[j] = 2.0E0 * a[j];
    # 1e50:       c5 fd 10 01             vmovupd (%rcx),%ymm0
    # 1e54:       48 83 c1 20             add    $0x20,%rcx
    # 1e58:       c5 fd 58 c0             vaddpd %ymm0,%ymm0,%ymm0
    # 1e5c:       c5 fd 11 41 e0          vmovupd %ymm0,-0x20(%rcx)
    # 1e61:       48 39 f9                cmp    %rdi,%rcx
    # 1e64:       75 ea                   jne    1e50 <main._omp_fn.3+0x70>
    # 1e66:       48 89 c1                mov    %rax,%rcx
    # 1e69:       48 83 e1 fc             and    $0xfffffffffffffffc,%rcx
    # 1e6d:       48 01 ca                add    %rcx,%rdx
    # 1e70:       48 39 c8                cmp    %rcx,%rax
    # 1e73:       74 63                   je     1ed8 <main._omp_fn.3+0xf8>
    # 1e75:       c5 f8 77                vzeroupper
    # 1e78:       48 29 c8                sub    %rcx,%rax
    # 1e7b:       48 83 f8 01             cmp    $0x1,%rax
    # 1e7f:       74 1e                   je     1e9f <main._omp_fn.3+0xbf>
    # 1e81:       4c 01 c1                add    %r8,%rcx
    # 1e84:       48 8d 0c ce             lea    (%rsi,%rcx,8),%rcx
    # 1e88:       c5 f9 10 01             vmovupd (%rcx),%xmm0
    # 1e8c:       c5 f9 58 c0             vaddpd %xmm0,%xmm0,%xmm0
    # 1e90:       c5 f9 11 01             vmovupd %xmm0,(%rcx)
    # 1e94:       a8 01                   test   $0x1,%al
    # 1e96:       74 15                   je     1ead <main._omp_fn.3+0xcd>
    # 1e98:       48 83 e0 fe             and    $0xfffffffffffffffe,%rax
    # 1e9c:       48 01 c2                add    %rax,%rdx
    # 1e9f:       c5 fb 10 04 d6          vmovsd (%rsi,%rdx,8),%xmm0
    # 1ea4:       c5 fb 58 c0             vaddsd %xmm0,%xmm0,%xmm0
    # 1ea8:       c5 fb 11 04 d6          vmovsd %xmm0,(%rsi,%rdx,8)