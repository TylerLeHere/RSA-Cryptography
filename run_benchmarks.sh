
#!/bin/bash
set -e

mkdir -p benchmark

# Compile with O3 - runtime
gcc -O3 -g main.c montgomery.c modular_exponentiation.c -o benchmark/prog_runtime

# Compile with O3 and debug for cachegrind
gcc -O3 -g main.c montgomery.c modular_exponentiation.c -o benchmark/prog_cachegrind

REPORT_FILE="benchmark/benchmark_report.txt"

echo "Benchmark Report - $(date)" > "$REPORT_FILE"
echo "==========================" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "Running perf stat for runtime and instructions..."
perf stat -r 100 -o benchmark/perf_stat.txt \
    ./benchmark/prog_runtime 100000

echo "Recording perf for top function time (perf record)..."
perf record -o benchmark/perf.data ./benchmark/prog_runtime 1000000



echo "Generating perf report (top 30 functions)..."
perf report --stdio -n --sort comm,dso,symbol -i benchmark/perf.data | head -n 80 > benchmark/perf_report.txt

echo "Running valgrind cachegrind for cache misses (10,000 iterations)..."
CACHEGRIND_OUTPUT=$(valgrind --tool=cachegrind ./benchmark/prog_cachegrind 10000 2>&1)


valgrind --tool=cachegrind --cachegrind-out-file=benchmark/cachegrind.out ./benchmark/prog_cachegrind 10000

echo "Annotating cachegrind output..."
cg_annotate benchmark/cachegrind.out > benchmark/cachegrind_report.txt

# Amalgamate reports into one file
{
  echo "=== perf stat summary ==="
  cat benchmark/perf_stat.txt
  echo
  echo "=== Top 30 functions by CPU time (perf report) ==="
  cat benchmark/perf_report.txt
  echo
  echo "=== Cachegrind annotation summary ==="
  head -n 60 benchmark/cachegrind_report.txt
  echo
} >> "$REPORT_FILE"

echo "Benchmarking complete."
echo "Combined report available at $REPORT_FILE"


#--- Quick console summary ---

# Extract runtime in seconds from perf stat output
RUNTIME=$(grep "seconds time elapsed" benchmark/perf_stat.txt | awk '{print $1}')

echo ""
echo "===== Quick Benchmark Summary ====="
echo "Runtime (wall clock):     ${RUNTIME}s"



PERF_STAT_FILE="benchmark/perf_stat.txt"
CACHEGRIND_OUT="benchmark/cachegrind.out"

# Now grep for key stats from this output string
I_REFS=$(echo "$CACHEGRIND_OUTPUT" | grep -Po '^==\d+== I   refs:\s+\K[\d,]+')
I1_MISSES=$(echo "$CACHEGRIND_OUTPUT" | grep -Po '^==\d+== I1  misses:\s+\K[\d,]+')
LLI_MISSES=$(echo "$CACHEGRIND_OUTPUT" | grep -Po '^==\d+== LLi misses:\s+\K[\d,]+')
D_REFS=$(echo "$CACHEGRIND_OUTPUT" | grep -Po '^==\d+== D   refs:\s+\K[\d,]+')
D1_MISSES=$(echo "$CACHEGRIND_OUTPUT" | grep -Po '^==\d+== D1  misses:\s+\K[\d,]+')
LLD_MISSES=$(echo "$CACHEGRIND_OUTPUT" | grep -Po '^==\d+== LLd misses:\s+\K[\d,]+')
LL_REFS=$(echo "$CACHEGRIND_OUTPUT" | grep -Po '^==\d+== LL refs:\s+\K[\d,]+')
LL_MISSES=$(echo "$CACHEGRIND_OUTPUT" | grep -Po '^==\d+== LL misses:\s+\K[\d,]+')

# Remove commas for better formatting (optional)
I_REFS=${I_REFS//,/}
I1_MISSES=${I1_MISSES//,/}
LLI_MISSES=${LLI_MISSES//,/}
D_REFS=${D_REFS//,/}
D1_MISSES=${D1_MISSES//,/}
LLD_MISSES=${LLD_MISSES//,/}
LL_REFS=${LL_REFS//,/}
LL_MISSES=${LL_MISSES//,/}

# Print a compact summary
echo "Cachegrind stats summary from stdout:"
echo "Instruction refs: $I_REFS"
echo "I1 misses: $I1_MISSES"
echo "LLi misses: $LLI_MISSES"
echo "Data refs: $D_REFS"
echo "D1 misses: $D1_MISSES"
echo "LLd misses: $LLD_MISSES"
echo "LL refs: $LL_REFS"
echo "LL misses: $LL_MISSES"
