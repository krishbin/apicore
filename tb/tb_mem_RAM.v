`timescale 1ns/1ps
`include "../core/mem_RAM.v"

module mem_RAM_testbench();

    reg clk;
    reg reset_n;
    reg en;

    reg  [31:0] address_i, data_in;
    wire [31:0] data_out;
    reg  [3:0] wr_mask_i;

    mem_RAM uut(
        .clk(clk),
        .reset_n(reset_n),
        .en(en),
        .address_i(address_i),
        .data_in_i(data_in),
        .data_out_o(data_out),
        .wr_mask_i(wr_mask_i)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        reset_n = 1'b1;
        en = 1'b0;
        #10;
        reset_n = 1'b0; #10;
        reset_n = 1'b1;
        en = 1'b1;

        address_i = 32'h0; data_in = 32'habcdef89; wr_mask_i = 4'b1111; #10;
        address_i = 32'h4; data_in = 32'h12569034; wr_mask_i = 4'b1111; #10;
        address_i = 32'h8; data_in = 32'h12347812; wr_mask_i = 4'b1111; #10;
        address_i = 32'hc; data_in = 32'h12569034; wr_mask_i = 4'b1111; #10;
        address_i = 32'h10; data_in = 32'h12347812; wr_mask_i = 4'b1111; #10;
        address_i = 32'h14; data_in = 32'h12569034; wr_mask_i = 4'b1111; #10;
        address_i = 32'h18; data_in = 32'h12347812; wr_mask_i = 4'b1111; #10;

        en = 1'b1;
        wr_mask_i = 4'b0;
        address_i = 32'h0;  #10;
        address_i = 32'h4;  #10;
        address_i = 32'h8;  #10;
        address_i = 32'hc;  #10;
        address_i = 32'h10; #10;
        address_i = 32'h14; #10;
        address_i = 32'h18; #10;

        address_i = 32'h0; data_in = 32'h123478ff; wr_mask_i = 4'b0001; #10;
        address_i = 32'h0; wr_mask_i = 4'b0000; #10;
        #100;
        $finish;
    end

    initial begin
        $dumpfile("../waveform/ram.vcd");
        $dumpvars();
    end

endmodule