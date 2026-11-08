// Icarus-compatible immediate assertion monitors. Concurrent SVA examples
// are explained in docs/assertions.md because Icarus support varies by build.
module counter_range_assertion #(
    parameter integer WIDTH = 8,
    parameter logic [WIDTH-1:0] MAX_VALUE = {WIDTH{1'b1}}
) (
    input logic clk, input logic [WIDTH-1:0] count
);
    always @(negedge clk)
        assert (count <= MAX_VALUE)
            else $error("counter value %0d exceeds maximum %0d", count, MAX_VALUE);
endmodule

module counter_overflow_assertion #(
    parameter integer WIDTH = 4,
    parameter logic [WIDTH-1:0] MAX_VALUE = {WIDTH{1'b1}}
) (
    input logic clk, input logic reset, input logic enable,
    input logic [WIDTH-1:0] count
);
    logic initialized = 1'b0;
    logic previous_reset, previous_enable;
    logic [WIDTH-1:0] previous_count;
    always @(negedge clk) begin
        if (initialized && !previous_reset && previous_enable &&
            (previous_count == MAX_VALUE))
            assert (count == '0)
                else $error("counter failed to wrap after maximum value");
        previous_count <= count;
        previous_enable <= enable;
        previous_reset <= reset;
        initialized <= 1'b1;
    end
endmodule

module traffic_state_assertion (
    input logic clk, input logic [1:0] state
);
    always @(negedge clk)
        assert ((state == 2'b00) || (state == 2'b01) || (state == 2'b10))
            else $error("invalid traffic-light state %b", state);
endmodule

module reset_assertion (
    input logic clk, input logic reset, input logic [7:0] observed_value
);
    // Sample after the active edge so nonblocking assignments have settled.
    always @(negedge clk)
        if (reset) assert (observed_value == 8'h00)
            else $error("reset behavior failed: observed %h", observed_value);
endmodule

module alu_known_result_assertion #(
    parameter integer WIDTH = 8
) (
    input logic clk, input logic [WIDTH-1:0] result
);
    always @(negedge clk)
        assert ((^result) !== 1'bx)
            else $error("ALU result contains X/Z: %b", result);
endmodule

module clock_synchronization_assertion (
    input logic clk, input logic observed_value
);
    logic sampled_value;
    always @(posedge clk) begin
        #1 sampled_value = observed_value;
    end
    always @(negedge clk) begin
        #1 assert (observed_value === sampled_value)
            else $error("synchronous output changed away from a clock edge");
    end
endmodule
