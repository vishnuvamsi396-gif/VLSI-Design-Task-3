# VLSI Design and Semiconductor Engineering - Task 3

Task 3 develops a parameterized ALU and small memory blocks, demonstrates SystemVerilog RTL style, and builds a structured verification environment with assertions and documentation.

## Contents

- `rtl/alu.sv` - 8-bit-default parameterized ALU for add, subtract, multiply, bitwise operations, shifts, and equality.
- `rtl/memory.sv` - 16 x 8 single-port RAM and 16 x 8 ROM.
- `rtl/sequential_sv.sv`, `rtl/traffic_light_sv.sv` - selected SystemVerilog rewrites and enum FSM example.
- `testbench/` - directed checks for ALU operations and widths, RAM/ROM addressing, and sequential behavior.
- `assertions/` - immediate assertion monitors; the concurrent SVA limitation is documented.
- `docs/` - verification plan, test matrix, functional coverage plan, design notes, waveform analysis plan, bug report, and diagrams.
- `simulation/results/`, `simulation/vcd/` - generated logs and traces after running the suite.
- `waveforms/` - three genuine GTKWave screenshots: ALU, RAM/ROM, and reset/FSM/counter traces.
- `progress_log/` - daily record of completed work.

## Tools and simulation

Use Icarus Verilog with SystemVerilog support, VVP, GTKWave, Git, and a text editor. From this repository's root:

```sh
bash scripts/run_all.sh
```

The script builds and runs four testbenches and saves simulator logs and VCD traces. Open a generated trace with `gtkwave simulation/vcd/tb_alu.vcd`.

## ALU operation codes

| Code | Operation |
|---|---|
| 0-2 | ADD, SUB, MUL |
| 3-6 | AND, OR, XOR, NOT |
| 7-8 | logical left/right shift |
| 9 | equality comparison |
| A-F | reserved; result defaults to zero |

The default width is 8 bits. The parameterized testbench instantiates 8-, 16-, and 32-bit versions. Flag semantics, memory behavior, verification scope, and known tool limits are in `docs/`.

## Verification status

The RTL test suite was run in Ubuntu/WSL with Icarus Verilog. All four testbench tops passed: directed and 64 repeatable pseudo-random ALU checks, width checks at 8/16/32 bits, all 16 RAM and ROM addresses plus write inhibit, and sequential reset/enable/FSM/counter-overflow/clock-synchronization checks. The runner saved simulator logs and VCD traces. Three genuine GTKWave screenshots are included in `waveforms/`; signal selections and visible behaviors are summarized in `docs/waveform_analysis.md`.

