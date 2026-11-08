# Verification plan

## Purpose and scope

This plan defines how the Task 3 ALU, 16 x 8 single-port RAM, 16 x 8 ROM, selected SystemVerilog sequential blocks, and the Task 2 traffic-light controller are checked. It covers directed functional behavior, boundaries, resets, invalid ALU opcodes, and assertion monitors. The traffic-light section treats the Task 2 timed Moore controller as a black box. Its interface is `clk`, `reset`, and active-high `red`, `yellow`, and `green` outputs; the Task 2 testbench uses RED/GREEN/YELLOW durations of 2/3/1 cycles. The scenarios below are a plan and are not reported as rerun by this Task 3 simulation suite.

## Verification strategy

1. Compile each design with Icarus Verilog in SystemVerilog mode.
2. Apply directed vectors to each ALU operation, then 64 repeatable pseudo-random vectors against an independent reference function.
3. Instantiate 8-, 16-, and 32-bit ALUs to check width scalability.
4. Write and read every RAM address, verify write inhibit, and compare all ROM addresses to the documented constant table.
5. Check synchronous and asynchronous reset, register enable/hold, and legal traffic-light FSM outputs.
6. Run immediate assertion monitors on sampled values, including counter overflow, state validity, reset, and clock synchronization. Use GTKWave on generated VCD traces to review reset, state, and datapath transitions.
7. Save each simulator transcript and waveform file; record any failure as a bug before fixing and rerunning.

## Traffic-light controller scenarios (Task 2 black-box reuse)

| ID | Scenario | Stimulus | Expected observation |
|---|---|---|---|
| TLC-01 | Reset entry | Assert reset across an active clock edge | Controller enters its documented reset state and outputs match that state |
| TLC-02 | Normal phase sequence | Release reset and allow a full cycle | State/output sequence follows the Task 2 phase order |
| TLC-03 | Phase duration | Count active clock edges in each phase | With RED/GREEN/YELLOW parameters 2/3/1, each phase lasts its configured number of cycles |
| TLC-04 | Reset during operation | Assert reset in a non-reset phase | State and outputs return to reset behavior at the specified reset timing |
| TLC-05 | State validity | Observe state on every sample | State remains in the documented legal state set |
| TLC-06 | Output exclusivity | Observe all signal outputs | Mutually exclusive outputs never assert together, where required by the Task 2 spec |
| TLC-07 | Boundary transition | Assert reset just before/after a clock edge | Sync/async response matches the implemented reset type |

## Pass criteria

- All directed expected values match exactly, including flags whose semantics are defined in `alu_design.md`.
- All repeatable pseudo-random ALU result checks match the reference function.
- Each RAM address retains its written byte; a disabled write does not alter stored data.
- Every ROM address returns its documented constant.
- Immediate assertion monitors produce no failures on legal stimuli.
- Logs end in a `PASS` line and GTKWave review notes are recorded.

## Known tool boundary

The provided immediate assertions are portable simulation checks. Concurrent SVA is introduced conceptually in `assertions.md`; the default Icarus flow may not support all concurrent property syntax. A simulator with full IEEE SystemVerilog Assertions support is required to execute those examples as SVA.
