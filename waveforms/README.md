# GTKWave screenshots

Representative screenshots captured from the generated VCD traces are saved here:

1. ALU operations and flags (`simulation/vcd/tb_alu.vcd`)
2. RAM write/read and ROM output (`simulation/vcd/tb_memory.vcd`)
3. Reset, FSM, counter overflow, and clock synchronization (`simulation/vcd/tb_systemverilog.vcd`)

- `alu_waveform.png` — ALU inputs, operation code, result, and flags.
- `memory_ram_rom.png` — address, clock, write control, input data, and RAM/ROM outputs.
- `reset_fsm_counter.png` — reset, counter, FSM state/next state, and traffic-light outputs.

These are screen captures of GTKWave displaying the project's VCD traces. See `docs/waveform_analysis.md` for observations and scope limits.
