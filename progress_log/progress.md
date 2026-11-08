# Task 3 daily progress log

## 2026-11-08

- Read the Task 3 PDF and extracted the practical activities, required deliverables, and expected output.
- Started a separate Task 3 project draft so Task 1 and Task 2 repositories remain untouched.
- Added parameterized ALU, 16 x 8 RAM and ROM, selected SystemVerilog sequential/FSM examples, assertion monitors, and directed testbenches.
- Added verification plan, test matrix, design notes, assertion notes, waveform analysis plan, and honest bug-report template.
- Added a functional coverage plan covering ALU operations/flags/widths, all memory addresses, reset and sequential behaviors.
- Ran all four testbench tops in Ubuntu/WSL with Icarus Verilog; all passed, including 64 repeatable pseudo-random ALU vectors and counter overflow/clock assertions, and generated simulator logs and VCD traces.
- Genuine GTKWave screenshots and waveform review notes were added in the continuation below.

## 2026-11-08 (continued)

- Captured genuine GTKWave screenshots for the ALU, RAM/ROM, and reset/FSM/counter traces in `waveforms/`.
- Updated the README, waveform guide, and report notes to identify the screenshots and describe only the visible trace behavior.
- Regenerated the PDF report with one page per GTKWave screenshot and reviewed its page layout.
