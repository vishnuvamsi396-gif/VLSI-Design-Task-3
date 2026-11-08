# Functional coverage plan

This introduction uses scenario counts and bins in the testbench plan; it does not claim RTL code-coverage percentages.

## ALU functional bins

- Operation bins: ADD, SUB, MUL, AND, OR, XOR, NOT, SHL, SHR, EQ, and invalid selector.
- Operand bins: zero, one, all ones, sign-bit-only, equal operands, and unequal operands.
- Flag bins: zero result, add carry, signed add overflow, subtraction borrow/no-borrow, and multiply upper-half nonzero.
- Parameter bins: width 8, 16, and 32.
- Stimulus: 15 explicit directed vectors and 64 deterministic pseudo-random operand/selector vectors.

## Memory functional bins

- Address bins: all sixteen addresses, 0 through 15, independently covered for RAM and ROM.
- RAM control bins: write enabled at a rising edge and write disabled at a rising edge.
- Data patterns: each address receives a distinct deterministic byte.

## Sequential and assertion bins

- Reset: synchronous reset sampled on an active edge and asynchronous reset asserted between edges.
- Register: enabled capture and disabled hold.
- Counter: normal increment, maximum value, wrap to zero, and reset value.
- FSM: each enum state and legal one-hot light output.
- Clocking: output sample remains stable between active edges.

The current test run checks these directed scenarios. Future extensions may record counters or use a simulator with covergroup support; no covergroup run or structural code coverage result is claimed.
