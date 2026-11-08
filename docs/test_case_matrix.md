# Test case matrix

| ID | Block | Category | Inputs / action | Expected result | Implemented in |
|---|---|---|---|---|---|
| ALU-01 | ALU | Normal | `12 + 23` | `35`, no carry/overflow | `tb_alu.sv` |
| ALU-02 | ALU | Boundary | `FF + 01` | `00`, carry=1, zero=1 | `tb_alu.sv` |
| ALU-03 | ALU | Boundary | signed `7F + 01` | `80`, overflow=1 | `tb_alu.sv` |
| ALU-04 | ALU | Boundary | `00 - 01` | `FF`, borrow indicated by carry=0 | `tb_alu.sv` |
| ALU-05 | ALU | Normal | `10 * 10` | low result `00`, upper-product flag=1 | `tb_alu.sv` |
| ALU-06 | ALU | Normal | AND / OR / XOR / NOT | truth-table result | `tb_alu.sv` |
| ALU-07 | ALU | Boundary | Shift `81` by one | left=`02`, right=`40` | `tb_alu.sv` |
| ALU-08 | ALU | Compare | Equal and unequal operands | result 1 and 0 respectively | `tb_alu.sv` |
| ALU-09 | ALU | Invalid | Opcode `A` | deterministic zero result | `tb_alu.sv` |
| ALU-10 | ALU | Width | Add/XOR/shift at 8/16/32 bits | Correct result at each width | `tb_parameterized_alu.sv` |
| ALU-11 | ALU | Repeatable pseudo-random | 64 seeded operand/operation vectors | Match independent reference function | `tb_alu.sv` |
| MEM-01 | RAM | Address boundary | Write/read addresses 0 through 15 | Each byte is retained at its address | `tb_memory.sv` |
| MEM-02 | RAM | Control | Write enable low at an edge | Stored byte unchanged | `tb_memory.sv` |
| MEM-03 | ROM | Address coverage | Read addresses 0 through 15 | Match constant lookup table | `tb_memory.sv` |
| SV-01 | Sequential | Reset | Assert sync and async reset | Outputs clear according to reset style | `tb_systemverilog.sv` |
| SV-02 | Register | Enable | Enable captures, disabled holds | Correct captured byte is retained | `tb_systemverilog.sv` |
| SV-03 | FSM | State/output | Release reset and clock enum-based traffic cycle | Green, then yellow, then red; outputs remain legal and one-hot | `tb_systemverilog.sv` |
| SV-04 | Counter | Overflow boundary | Enable 4-bit counter through `F` | Wrap to zero; immediate overflow assertion passes | `tb_systemverilog.sv` |
| SV-05 | Clocking | Synchronization | Change D between active edges | Sampled FF output changes only after rising clock | `tb_systemverilog.sv` |
| TLC-01..07 | Task 2 controller | Reset, phase, corner | See verification plan | Match Task 2's timed Moore behavior and one-hot output decode | Black-box plan only; not rerun by this Task 3 suite |

## Verification gaps

The ALU testbench includes 64 seeded, repeatable pseudo-random checks, alongside directed coverage for every ALU operation. Structural code coverage is not measured. The Task 2 traffic-light black-box scenarios are documented with the actual interface and phase values from the Task 2 project; they were not rerun by this Task 3 suite.
