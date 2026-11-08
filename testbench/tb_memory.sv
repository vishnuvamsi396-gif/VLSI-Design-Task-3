`timescale 1ns/1ps
module tb_memory;
    logic clk=0, write_enable;
    logic [3:0] address;
    logic [7:0] data_in, ram_data, rom_data;
    logic [7:0] expected_rom [0:15];
    logic [7:0] expected_ram [0:15];
    integer i;
    always #5 clk=~clk;
    single_port_ram_16x8 ram(clk,write_enable,address,data_in,ram_data);
    rom_16x8 rom(address,rom_data);
    initial begin
        $dumpfile("simulation/vcd/tb_memory.vcd"); $dumpvars(0,tb_memory);
        write_enable=0; address=0; data_in=0;
        expected_rom[0]=8'h3C; expected_rom[1]=8'hA5;
        expected_rom[2]=8'h5A; expected_rom[3]=8'hC3;
        expected_rom[4]=8'h0F; expected_rom[5]=8'hF0;
        expected_rom[6]=8'h33; expected_rom[7]=8'hCC;
        expected_rom[8]=8'h55; expected_rom[9]=8'hAA;
        expected_rom[10]=8'h12; expected_rom[11]=8'h24;
        expected_rom[12]=8'h48; expected_rom[13]=8'h81;
        expected_rom[14]=8'h69; expected_rom[15]=8'h96;
        for (i=0;i<16;i=i+1) begin
            @(negedge clk); address=i; data_in=(i*13+7); write_enable=1;
            @(posedge clk); #1; expected_ram[i]=data_in;
            @(negedge clk); write_enable=0; address=i; #1;
            assert(ram_data===expected_ram[i])
                else $fatal(1,"RAM address %0d got %h expected %h",i,ram_data,expected_ram[i]);
            assert(rom_data===expected_rom[i])
                else $fatal(1,"ROM address %0d got %h expected %h",i,rom_data,expected_rom[i]);
        end
        // With write disabled, stored data must remain unchanged.
        @(negedge clk); address=4'd7; data_in=8'h00; write_enable=0;
        @(posedge clk); #1;
        assert(ram_data===expected_ram[7]) else $fatal(1,"RAM changed while write disabled");
        $display("PASS tb_memory: 16 RAM write/read locations, write inhibit, 16 ROM words");
        $finish;
    end
endmodule
