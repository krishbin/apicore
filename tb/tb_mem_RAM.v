`timescale 1ns/1ps
`include "../core/mem_RAM.v"

module mem_RAM_testbench();

    reg clk;
    reg reset_n;
    reg en_n;

    reg  [31:0] address_i, data_in;
    wire [31:0] data_out;
    reg  [3:0] wr_mask_i;

    mem_RAM uut(
        .clk(clk),
        .reset_n(reset_n),
        .en_n(en_n),
        .address_i(address_i),
        .data_in_i(data_in),
        .data_out_o(data_out),
        .wr_mask_i(wr_mask_i)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        reset_n = 1'b1;
        en_n = 1'b1;
        #10;
        reset_n = 1'b0; #10;
        reset_n = 1'b1;
        en_n = 1'b0;

        address_i = 32'h0; data_in = 32'habcdef89; wr_mask_i = 4'b1111; #10;
        address_i = 32'h1; data_in = 32'h12569034; wr_mask_i = 4'b1111; #10;
        address_i = 32'h2; data_in = 32'h12347812; wr_mask_i = 4'b1111; #10;
        address_i = 32'h3; data_in = 32'h12569034; wr_mask_i = 4'b1111; #10;
        address_i = 32'h4; data_in = 32'h12347812; wr_mask_i = 4'b1111; #10;
        address_i = 32'h5; data_in = 32'h12569034; wr_mask_i = 4'b1111; #10;
        address_i = 32'h6; data_in = 32'h12347812; wr_mask_i = 4'b1111; #10;

        en_n = 1'b0;
        wr_mask_i = 4'b0;
        address_i = 32'h0; #10;
        address_i = 32'h1; #10;
        address_i = 32'h2; #10;
        address_i = 32'h3; #10;
        address_i = 32'h4; #10;
        address_i = 32'h5; #10;
        address_i = 32'h6; #10;

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