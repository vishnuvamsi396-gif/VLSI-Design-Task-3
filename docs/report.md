# Task 3 project report

## Project summary

This project focuses on RTL verification and subsystem building blocks. It includes a parameterized ALU, small RAM and ROM examples, selected SystemVerilog rewrites, assertion monitors, directed testbench sources, and a verification plan.

## Design contents

- ALU operations: add, subtract, multiply, AND, OR, XOR, NOT, logical shifts, and equality compare; parameterized for 8-, 16-, and 32-bit use.
- Memory: 16 x 8 single-port RAM with synchronous write/asynchronous read, and 16 x 8 constant ROM.
- SystemVerilog: `logic`, `always_comb`, `always_ff`, an enum-based FSM, and parameterized register examples.
- Assertions: immediate checks for value expectations, reset, legal state encodings, counter bounds, and unknown outputs.

## Verification approach

`docs/verification_plan.md` defines the strategy and Task 2 traffic-light scenarios. `docs/test_case_matrix.md` maps scenarios to testbench files; `docs/coverage_plan.md` records functional bins without claiming code coverage. The provided runner builds four testbench tops in Icarus SystemVerilog mode and writes logs and VCDs. Concurrent SVA examples are described separately because tool support differs.

## Current evidence status

The four testbench tops were run under Ubuntu/WSL with Icarus Verilog. The ALU bench passed 15 directed and 64 repeatable pseudo-random checks; the parameterized bench passed at 8, 16, and 32 bits; the memory bench passed all 16 RAM write/read locations, write inhibit, and all 16 ROM words; the SystemVerilog bench passed reset, flip-flop capture, register enable/hold, enum FSM, counter overflow, and clock synchronization checks. Logs and VCD traces are saved under `simulation/`.

Three GTKWave screenshots are included for ALU, RAM/ROM, and reset/FSM/counter traces. Concise observations are in `docs/waveform_analysis.md`; detailed pass evidence remains in the simulator logs. No confirmed design bug has been observed yet. The bug report document provides the fields for recording a real failure and its regression fix.

## Reproduction

From the project root run:

```sh
bash scripts/run_all.sh
```

The runner expects `iverilog` and `vvp` in `PATH`. GTKWave can open any generated trace, for example `simulation/vcd/tb_alu.vcd`.
