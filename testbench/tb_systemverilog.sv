`timescale 1ns/1ps
module tb_systemverilog;
    logic clk=0, reset=1, reset_n=1, enable=0, d=0;
    logic q_sync,q_async;
    logic [7:0] data_in=0,data_out;
    logic red,yellow,green;
    logic [3:0] count4;
    logic count_enable=0;
    always #5 clk=~clk;
    dff_sync_reset sync_ff(clk,reset,d,q_sync);
    dff_async_reset async_ff(clk,reset_n,d,q_async);
    enabled_register #(.WIDTH(8)) reg8(clk,reset,enable,data_in,data_out);
    traffic_light_sv fsm(clk,reset,red,yellow,green);
    sync_counter #(.WIDTH(4)) counter_dut(clk,reset,count_enable,count4);
    counter_range_assertion #(.WIDTH(4),.MAX_VALUE(4'hF)) cnt4_assert(clk,count4);
    counter_overflow_assertion #(.WIDTH(4),.MAX_VALUE(4'hF)) overflow_assert(clk,reset,count_enable,count4);
    traffic_state_assertion fsm_assert(clk,fsm.state);
    reset_assertion reset_check(clk,reset,data_out);
    clock_synchronization_assertion sync_clock_assert(clk,q_sync);
    initial begin
        $dumpfile("simulation/vcd/tb_systemverilog.vcd"); $dumpvars(0,tb_systemverilog);
        @(negedge clk); reset=1; reset_n=0; #1;
        assert(q_sync==0 && q_async==0 && data_out==0 && count4==0 && red)
            else $fatal(1,"reset behavior failed");
        @(negedge clk); reset=0; reset_n=1; d=1; enable=1; data_in=8'hA6;
        @(posedge clk); #1;
        assert(q_sync==1 && q_async==1 && data_out==8'hA6)
            else $fatal(1,"sequential capture failed");
        assert(green) else $fatal(1,"FSM did not leave reset for green state");
        @(negedge clk); enable=0; data_in=8'h3C;
        @(posedge clk); #1;
        assert(data_out==8'hA6) else $fatal(1,"register enable hold failed");
        assert(yellow) else $fatal(1,"FSM yellow phase incorrect");
        @(posedge clk); #1;
        assert(red) else $fatal(1,"FSM red phase incorrect");
        repeat (3) @(negedge clk);
        assert(({red,yellow,green}==3'b100) || ({red,yellow,green}==3'b010) ||
               ({red,yellow,green}==3'b001)) else $fatal(1,"FSM output not one-hot");
        count_enable=1;
        repeat (16) @(negedge clk);
        #1 assert(count4==0) else $fatal(1,"counter did not wrap at overflow");
        $display("PASS tb_systemverilog: reset, FFs, enable hold, enum FSM, counter overflow");
        $finish;
    end
endmodule
