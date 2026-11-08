// Parameterized combinational ALU. Arithmetic is unsigned; carry_out on
// subtraction means no borrow. Multiplication returns the low DATA_WIDTH bits
// and flags a nonzero upper half in carry_out.
module alu #(
    parameter integer DATA_WIDTH = 8
) (
    input  logic [DATA_WIDTH-1:0] operand_a,
    input  logic [DATA_WIDTH-1:0] operand_b,
    input  logic [3:0]            operation,
    output logic [DATA_WIDTH-1:0] result,
    output logic                 zero,
    output logic                 carry_out,
    output logic                 overflow
);
    localparam logic [3:0] OP_ADD = 4'h0, OP_SUB = 4'h1, OP_MUL = 4'h2,
                           OP_AND = 4'h3, OP_OR  = 4'h4, OP_XOR = 4'h5,
                           OP_NOT = 4'h6, OP_SHL = 4'h7, OP_SHR = 4'h8,
                           OP_EQ  = 4'h9;
    localparam integer SHIFT_WIDTH = (DATA_WIDTH <= 2) ? 1 : $clog2(DATA_WIDTH);

    logic [DATA_WIDTH:0] extended_sum;
    logic [2*DATA_WIDTH-1:0] full_product;

    always_comb begin
        result = '0;
        carry_out = 1'b0;
        overflow = 1'b0;
        extended_sum = '0;
        full_product = '0;
        case (operation)
            OP_ADD: begin
                extended_sum = {1'b0, operand_a} + {1'b0, operand_b};
                result = extended_sum[DATA_WIDTH-1:0];
                carry_out = extended_sum[DATA_WIDTH];
                overflow = (~(operand_a[DATA_WIDTH-1] ^ operand_b[DATA_WIDTH-1])) &
                           (result[DATA_WIDTH-1] ^ operand_a[DATA_WIDTH-1]);
            end
            OP_SUB: begin
                result = operand_a - operand_b;
                carry_out = (operand_a >= operand_b);
                overflow = (operand_a[DATA_WIDTH-1] ^ operand_b[DATA_WIDTH-1]) &
                           (result[DATA_WIDTH-1] ^ operand_a[DATA_WIDTH-1]);
            end
            OP_MUL: begin
                full_product = operand_a * operand_b;
                result = full_product[DATA_WIDTH-1:0];
                carry_out = |full_product[2*DATA_WIDTH-1:DATA_WIDTH];
            end
            OP_AND: result = operand_a & operand_b;
            OP_OR:  result = operand_a | operand_b;
            OP_XOR: result = operand_a ^ operand_b;
            OP_NOT: result = ~operand_a;
            OP_SHL: result = operand_a << operand_b[SHIFT_WIDTH-1:0];
            OP_SHR: result = operand_a >> operand_b[SHIFT_WIDTH-1:0];
            OP_EQ:  result = {{(DATA_WIDTH-1){1'b0}}, (operand_a == operand_b)};
            default: result = '0;
        endcase
        zero = (result == '0);
    end
endmodule
