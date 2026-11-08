// 16-word x 8-bit single-port RAM: synchronous write, asynchronous read.
module single_port_ram_16x8 (
    input  logic       clk,
    input  logic       write_enable,
    input  logic [3:0] address,
    input  logic [7:0] data_in,
    output logic [7:0] data_out
);
    logic [7:0] memory [0:15];
    always_ff @(posedge clk)
        if (write_enable) memory[address] <= data_in;
    always_comb data_out = memory[address];
endmodule

// Read-only 16-word x 8-bit ROM. Contents are deterministic and documented.
module rom_16x8 (
    input  logic [3:0] address,
    output logic [7:0] data_out
);
    always_comb begin
        case (address)
            4'h0: data_out = 8'h3C; 4'h1: data_out = 8'hA5;
            4'h2: data_out = 8'h5A; 4'h3: data_out = 8'hC3;
            4'h4: data_out = 8'h0F; 4'h5: data_out = 8'hF0;
            4'h6: data_out = 8'h33; 4'h7: data_out = 8'hCC;
            4'h8: data_out = 8'h55; 4'h9: data_out = 8'hAA;
            4'hA: data_out = 8'h12; 4'hB: data_out = 8'h24;
            4'hC: data_out = 8'h48; 4'hD: data_out = 8'h81;
            4'hE: data_out = 8'h69; 4'hF: data_out = 8'h96;
            default: data_out = 8'h00;
        endcase
    end
endmodule
