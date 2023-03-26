`timescale 1ns/1ps
`include "../core/rv32im_pc.v"
`include "../core/mem_ROM.v"

module tb_pc_ROM();

    reg clk, reset_n;
    reg en_ROM;
    reg [31:0] pc_next;

    wire [31:0] curr_pc, data_ROM;

    rv32im_pc pc_uut(
        .clk(clk),
        .reset_n(reset_n),
        .pc_next_i(pc_next),
        .pc(curr_pc)
    );

    mem_ROM ROM_uut(
        .clk(clk),
        .reset_n(reset_n),
        .en(en_ROM),
        .address_i(curr_pc),
        .data_o(data_ROM)
    );

    always #5 clk = ~clk;

    integer i;
    initial begin
        $dumpfile("../waveform/pc_ROM.vcd");
        $dumpvars();

        clk = 1'b0;
        reset_n = 1'b0;
        #10;
        reset_n = 1'b1;
        en_ROM = 1'b1;

        for(i=4; i<64; i=i+4) begin
            pc_next = i;
            #10;
        end

        reset_n = 1'b0;
        #10;
        reset_n = 1'b1;

        for(i=4; i<16; i=i+4) begin
            pc_next = i;
            #10;
        end

        $finish;
                
    end

endmodule