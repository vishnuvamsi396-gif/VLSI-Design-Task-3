# Waveform analysis notes

The following observations are based on the included GTKWave screenshots and the displayed VCD traces. They document visible signal relationships; they do not replace the testbench checks or claim exhaustive visual review of every time point.

## ALU trace

The screenshot shows `a`, `b`, `operation`, `result`, `zero`, `carry_out`, and `overflow` changing through directed vectors and pseudo-random checks. Result and flag traces respond as the operation and operands change. The exact vector-by-vector pass/fail evidence is in `simulation/results/tb_alu.log`.

## Memory trace

The screenshot shows the address sequence, clock, write enable, input data, and RAM/ROM buses across the simulated address range. RAM values track the writes in the trace, while ROM values vary with address. Full address-by-address checks are recorded in `simulation/results/tb_memory.log`.

## Reset and FSM trace

The screenshot shows reset signals, clock, counter values, FSM `state` and `next_state`, and traffic-light outputs. The visible state sequence cycles through `00`, `01`, and `10`; the counter advances after reset is released. Detailed checks are recorded in `simulation/results/tb_systemverilog.log`. This trace is the Task 3 SystemVerilog example and does not establish Task 2 controller phase-duration coverage.

The screenshot files are `waveforms/alu_waveform.png`, `waveforms/memory_ram_rom.png`, and `waveforms/reset_fsm_counter.png`.
