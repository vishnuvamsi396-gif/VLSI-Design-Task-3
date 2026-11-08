# Memory design

## Single-port RAM

`single_port_ram_16x8` stores sixteen 8-bit words. It has one address, one data input, one data output, and a write enable. Writes occur on the rising clock edge when `write_enable` is high. Reads are asynchronous from the selected address. The block has no reset or initialization; software/testbench writes a location before relying on its value.

## ROM

`rom_16x8` is a combinational lookup table with sixteen fixed bytes. Its values are declared directly in `rtl/memory.sv` and mirrored in `tb_memory.sv` as the expected table. Every 4-bit address is valid.

## Test intent

The memory test writes a distinct deterministic value to every RAM address, reads it back, checks that a disabled write leaves a word unchanged, and checks all sixteen ROM words. There is no out-of-range address for a 4-bit address port; X/Z address behavior is not claimed as a functional use case.
