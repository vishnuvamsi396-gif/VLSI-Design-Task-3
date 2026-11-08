# SystemVerilog conversion notes

Selected sequential examples use `logic` for 4-state variables, `always_ff` for edge-triggered state updates, and an enumerated `state_t` type in the traffic-light example. The FSM's output and next-state decode uses `always_comb` with safe defaults. `enabled_register` demonstrates a parameterized packed vector and a hold condition.

The code favors one writer per variable and nonblocking assignments in sequential blocks. These choices improve intent and make simulation scheduling easier to reason about. The design examples are educational and do not claim a full conversion of every Task 2 source module.

The assignment introduces structures; no packed structure is needed by the selected examples, so this repository explains the construct rather than adding a structure solely for appearance.
