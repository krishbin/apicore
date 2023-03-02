`timescale 1ns/1ps
`include "../core/mem_ROM.v"

module mem_ROM_testbench();

    reg clk, reset_n, en_n;
    reg [31:0] address_i;
    wire [31:0] data_o;

    mem_ROM myROM(
        .clk(clk),
        .reset_n(reset_n),
        .en_n(en_n),
        .address_i(address_i),
        .data_o(data_o)
    );

    always #5 clk = ~clk;

    integer i;
    initial begin
        $dumpfile("ROM.vcd");
        $dumpvars();

        clk = 1'b0;
        reset_n = 1'b1;
        en_n = 1'b1;
        #10;
        reset_n = 1'b0;
        #10;
        reset_n = 1'b1;
        #10;

        for(i=0;i<2048;i=i+1) begin
            if (i%16===0) 
                en_n = 1'b1;
            else 
                en_n = 1'b0;
            address_i = 4*i;
            #10;
        end

        $finish;
    end

endmodule