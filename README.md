
# Matrix Multiplication Benchmark

This is a simple test suite to compare different compilers and compile options using a matmul program.
- matmul.F90 : Basic matmul prgram (note: cubic, not squared)
- matmul\_loop.F90 : Basic matmul prgram (note: cubic, not squared), looped
- matmul\_block.F90 : matmul using blocking to split work -- generates incorrent results
- matmul\_block\_loop.F90 : matmul using blocking to split work, looped -- generates incorrent results
- matmul\_interactive.F90 : matmul program that takes N at runtime (stdin)
- matmul\_block\_v2.F90 : a corrected version of matmul using blocks
- matmul\_block\_v2\_loop.F90 : a corrected version of matmul using blocks, looped

Note: the looped versions were created to account for the first iteration on a GPU being slow.

## Building

This can be built by running the following two commands:

```bash
cmake -B build -S . --install-prefix=$(pwd)/install --preset=<preset>
cmake --build build --target install
```

Where `<preset>` is an existing preset (default are "accelerated" (GPU build), "serial" (no parallelization), and "multicore" (CPU parallelization)). Presets can be modified in the CMakePresets.json file.

Altrnatively, one can modify the CMakeLists.txt file to generate one of each of these builds each time.

## Testing

There are some test scripts that can be used to partially automate the testing process:
- `tables/run_test.sh` is a script that will re-build matmul to the selected presets and then run them each three times and save the output data to `table_<fortran_compiler>.dat`
- `tables/run_block_test.sh` is the same as `run_test.sh` except it runs `matmul_block.x` instead of `matmul.x`
- `tables/run_typed_test.sh` will instead only build once (with the selected preset) and then run `matmul_interactive.x` multiple times with different input sizes for N
- `tables/auto_block.sh` compiles and runs `matmul_block_v2_loop` with different block sizes
- `tables/original_auto.sh` compiles and runs `matmul_loop` with different input sizes and a time limit of 90s
- `tables/optimal_block.sh` compiles and runs `matmul_block_v2_loop` with different input sizes and a time limit of 90s
- `tables/orig_vs_block.sh` compiles and runs both `matmul_loop` and `matmul_block_v2_loop` with different input sizes and a time limit of 90s

### Interpreting Results

The primary data point collected from these tests is the runtime. Comparing these can be done using an external program like Excel or with a plotting library. An example data viewer is provided in `tables/viewer.py` (though it is a limited implementation).

Another data point some may find useful is the flops per time metric to see how well your hardware is running this problem.

