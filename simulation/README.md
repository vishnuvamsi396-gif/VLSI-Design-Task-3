# Simulation evidence

Run `bash scripts/run_all.sh` from the project root. The script compiles and runs four self-checking SystemVerilog testbench tops using Icarus Verilog and VVP.

- `results/` contains the actual simulator transcripts from the passing run.
- `vcd/` contains the generated value-change traces for GTKWave review.
- `build/` contains local simulator executables and is excluded from version control.

The current run passes all four tops. GTKWave screenshot captures and human waveform observations are still pending.
