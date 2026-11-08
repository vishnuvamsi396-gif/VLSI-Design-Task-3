`timescale 1ns/1ps
module tb_alu;
    logic clk = 0;
    logic [7:0] a, b;
    logic [3:0] operation;
    logic [7:0] result;
    logic zero, carry_out, overflow;
    integer checks = 0;
    integer i;
    logic [31:0] prng = 32'h51A3_7C29;
    logic [7:0] random_a, random_b, random_expected;
    logic [3:0] random_op;

    always #5 clk = ~clk;
    alu #(.DATA_WIDTH(8)) dut (
        .operand_a(a), .operand_b(b), .operation(operation), .result(result),
        .zero(zero), .carry_out(carry_out), .overflow(overflow));
    alu_known_result_assertion #(.WIDTH(8)) result_check (.clk(clk), .result(result));

    function automatic logic [7:0] reference_result(input logic [7:0] x, y,
                                                      input logic [3:0] op);
        begin
            case (op)
                4'h0: reference_result = x + y;
                4'h1: reference_result = x - y;
                4'h2: reference_result = x * y;
                4'h3: reference_result = x & y;
                4'h4: reference_result = x | y;
                4'h5: reference_result = x ^ y;
                4'h6: reference_result = ~x;
                4'h7: reference_result = x << y[2:0];
                4'h8: reference_result = x >> y[2:0];
                4'h9: reference_result = (x == y) ? 8'h01 : 8'h00;
                default: reference_result = 8'h00;
            endcase
        end
    endfunction

    task automatic check_result(input logic [7:0] av, bv,
                                input logic [3:0] op,
                                input logic [7:0] expected,
                                input string label_text);
        begin
            @(negedge clk); a=av; b=bv; operation=op; #1;
            assert (result === expected)
                else $fatal(1, "%s: got %h expected %h", label_text, result, expected);
            checks = checks + 1;
        end
    endtask

    initial begin
        $dumpfile("simulation/vcd/tb_alu.vcd"); $dumpvars(0,tb_alu);
        a='0; b='0; operation='0;
        check_result(8'h12,8'h23,4'h0,8'h35,"addition");
        if (carry_out || overflow || zero) $fatal(1,"addition flags incorrect");
        check_result(8'hFF,8'h01,4'h0,8'h00,"addition carry boundary");
        if (!carry_out || !zero) $fatal(1,"addition carry/zero flags incorrect");
        check_result(8'h7F,8'h01,4'h0,8'h80,"signed overflow boundary");
        if (!overflow || carry_out) $fatal(1,"addition overflow flags incorrect");
        check_result(8'h00,8'h01,4'h1,8'hFF,"subtraction underflow");
        if (carry_out) $fatal(1,"subtraction carry should indicate no-borrow");
        check_result(8'h0A,8'h03,4'h1,8'h07,"subtraction");
        if (!carry_out) $fatal(1,"subtraction no-borrow flag incorrect");
        check_result(8'h10,8'h10,4'h2,8'h00,"multiplication low result");
        if (!carry_out || !zero) $fatal(1,"multiplication overflow/zero flags incorrect");
        check_result(8'hA5,8'h3C,4'h3,8'h24,"AND");
        check_result(8'hA5,8'h3C,4'h4,8'hBD,"OR");
        check_result(8'hA5,8'h3C,4'h5,8'h99,"XOR");
        check_result(8'h0F,8'h00,4'h6,8'hF0,"NOT");
        check_result(8'h81,8'h01,4'h7,8'h02,"left shift");
        check_result(8'h81,8'h01,4'h8,8'h40,"right shift");
        check_result(8'h55,8'h55,4'h9,8'h01,"equality true");
        check_result(8'h55,8'h54,4'h9,8'h00,"equality false");
        check_result(8'hAA,8'h00,4'hA,8'h00,"invalid operation default");
        for (i=0; i<64; i=i+1) begin
            prng = prng * 32'd1664525 + 32'd1013904223;
            random_a = prng[7:0];
            prng = prng * 32'd1664525 + 32'd1013904223;
            random_b = prng[7:0];
            prng = prng * 32'd1664525 + 32'd1013904223;
            random_op = prng[11:8] % 10;
            random_expected = reference_result(random_a,random_b,random_op);
            check_result(random_a,random_b,random_op,random_expected,"repeatable pseudo-random");
        end
        $display("PASS tb_alu: %0d checks (15 directed + 64 repeatable pseudo-random)", checks);
        $finish;
    end
endmodule
