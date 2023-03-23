`timescale 1ns/1ps
`include "../core/DEFINITIONS.v"
`include "../core/rv32im_core.v"


// testbench
module tb();
    reg clk;
    reg reset_n;
    reg en_ROM;

    wire [`API_PC_WIDTH-1:0] pc_curr;
    wire en_RAM;
    wire [`API_DATA_WIDTH-1:0] data_ROM;
    wire [`API_DATA_WIDTH-1:0] mem2core_din, core2mem_dout;
    wire [`API_ADDR_WIDTH-1:0] RAM_addr;
    wire [3:0] wr_mask;

    core core_uut(
        .clk(clk),
        .reset_n(reset_n),
        .data_ROM(data_ROM),
        .pc_curr(pc_curr),
        .data_RAM_i(mem2core_din),
        .data_RAM_o(core2mem_dout),
        .addr_RAM_o(RAM_addr),
        .mem_wr_mask_o(wr_mask),
        .mem_RAM_enable(en_RAM)
    );

    mem_ROM ROM(
        .clk(clk),
        .reset_n(reset_n),
        .en(en_ROM),
        .address_i(pc_curr),
        .data_o(data_ROM)
    );

    mem_RAM RAM(
        .clk(clk),
        .reset_n(reset_n),
        .en(en_RAM),
        .address_i(RAM_addr),
        .data_in_i(core2mem_dout),
        .data_out_o(mem2core_din),
        .wr_mask_i(wr_mask)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("../waveform/core.vcd");
        $dumpvars();

        clk = 1'b0;
        en_ROM = 1'b1;
        reset_n = 1'b0;
        #10;
        reset_n = 1'b1;

        #1400;
        $finish;
    end
endmodule