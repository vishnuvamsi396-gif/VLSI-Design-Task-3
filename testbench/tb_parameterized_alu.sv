`timescale 1ns/1ps
module tb_parameterized_alu;
    logic [7:0] a8,b8,r8;
    logic [15:0] a16,b16,r16;
    logic [31:0] a32,b32,r32;
    logic [3:0] op;
    logic z8,c8,v8,z16,c16,v16,z32,c32,v32;
    alu #(.DATA_WIDTH(8))  alu8  (a8,b8,op,r8,z8,c8,v8);
    alu #(.DATA_WIDTH(16)) alu16 (a16,b16,op,r16,z16,c16,v16);
    alu #(.DATA_WIDTH(32)) alu32 (a32,b32,op,r32,z32,c32,v32);
    initial begin
        $dumpfile("simulation/vcd/tb_parameterized_alu.vcd"); $dumpvars(0,tb_parameterized_alu);
        a8=8'hFE; b8=8'h02; a16=16'hFFFE; b16=16'h0002;
        a32=32'hFFFFFFFE; b32=32'h00000002; op=4'h0; #1;
        assert(r8==0 && c8) else $fatal(1,"8-bit parameterized add failed");
        assert(r16==0 && c16) else $fatal(1,"16-bit parameterized add failed");
        assert(r32==0 && c32) else $fatal(1,"32-bit parameterized add failed");
        op=4'h5; #1;
        assert(r8==8'hFC && r16==16'hFFFC && r32==32'hFFFFFFFC)
            else $fatal(1,"parameterized XOR failed");
        op=4'h7; b8=1; b16=1; b32=1; #1;
        assert(r8==8'hFC && r16==16'hFFFC && r32==32'hFFFFFFFC)
            else $fatal(1,"parameterized shift failed");
        $display("PASS tb_parameterized_alu: widths 8, 16, and 32");
        $finish;
    end
endmodule
