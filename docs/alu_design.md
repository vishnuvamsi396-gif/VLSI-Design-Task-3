# Parameterized ALU design

## Interface and operation codes

`rtl/alu.sv` implements a combinational ALU with parameter `DATA_WIDTH` (default 8). Inputs are two unsigned operands and a 4-bit operation selector. The result has `DATA_WIDTH` bits. Supported operation codes:

| Code | Operation | Result |
|---|---|---|
| 0 | ADD | `operand_a + operand_b` |
| 1 | SUB | `operand_a - operand_b` |
| 2 | MUL | Low `DATA_WIDTH` bits of product |
| 3 | AND | Bitwise AND |
| 4 | OR | Bitwise OR |
| 5 | XOR | Bitwise XOR |
| 6 | NOT | Bitwise complement of A |
| 7 | SHL | A shifted left by low `$clog2(DATA_WIDTH)` bits of B |
| 8 | SHR | Logical right shift of A by the same shift amount |
| 9 | EQ | Result is 1 when A equals B, else 0 |
| A-F | Reserved/invalid | Result and flags default to zero |

`zero` is asserted when the result is zero. `carry_out` on addition is the unsigned carry bit; on subtraction it means no borrow; on multiplication it means the product has nonzero upper bits. `overflow` is the signed two's-complement overflow flag for add/subtract and is zero for other operations. The data result remains unsigned bit-vector arithmetic.

## Parameter-width exercise

`tb_parameterized_alu.sv` instantiates 8-, 16-, and 32-bit configurations. The ALU uses sized intermediate values so the multiply high-half and add carry are observable without changing the result width.

## Block-level data flow

Operands and selector feed parallel arithmetic/logic choices. A selector mux drives result; flag logic derives zero, carry, and overflow from the selected operation.
