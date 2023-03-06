`timescale 1ns/1ps
`include "../core/rv32_program_counter.v"

module rv32im_pc_tb();

    reg clk, reset_n;
    reg [31:0] pc_next;
    // output 
    wire [31:0] pc;

    localparam PERIOD = 10;

    rv32im_pc uut(
        .clk(clk),
        .reset_n(reset_n),
        .pc_next_i(pc_next),
        .pc(pc)
    );  

    initial begin
        clk = 1'b0;
        reset_n = 1'b1;
        pc_next = 32'bz;
    end

    always
    #(PERIOD/2) clk = ~clk;

    integer i;
    initial begin
        // reset_n = 1'b0;
        // #(PERIOD);
        reset_n = 1'b1;

        // start
        // load from ALU
        for (i=0;i<100;i=i+1) begin
            pc_next = i;
            #(PERIOD);
        end

        #(PERIOD*100);
        $finish;
    end

    initial begin
        $dumpfile("../waveform/rv32_programCounter.vcd");
        $dumpvars();
    end

endmodule