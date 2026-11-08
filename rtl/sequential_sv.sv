// Selected Task 2 sequential blocks rewritten in SystemVerilog style.
module dff_sync_reset (
    input logic clk, input logic reset, input logic d, output logic q
);
    always_ff @(posedge clk)
        if (reset) q <= 1'b0;
        else       q <= d;
endmodule

module dff_async_reset (
    input logic clk, input logic reset_n, input logic d, output logic q
);
    always_ff @(posedge clk or negedge reset_n)
        if (!reset_n) q <= 1'b0;
        else          q <= d;
endmodule

module enabled_register #(
    parameter integer WIDTH = 8
) (
    input logic clk, input logic reset, input logic enable,
    input logic [WIDTH-1:0] data_in, output logic [WIDTH-1:0] data_out
);
    always_ff @(posedge clk)
        if (reset) data_out <= '0;
        else if (enable) data_out <= data_in;
endmodule

module sync_counter #(
    parameter integer WIDTH = 4
) (
    input logic clk, input logic reset, input logic enable,
    output logic [WIDTH-1:0] count
);
    always_ff @(posedge clk)
        if (reset) count <= '0;
        else if (enable) count <= count + 1'b1;
endmodule
