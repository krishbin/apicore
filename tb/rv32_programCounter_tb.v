`timescale 1ns/1ps
`include "../core/rv32_program_counter.v"

module programCounter_tb();

    reg clk, reset_n;
    reg [31:0] alu_imm_pc_next, imm_offset;

    // control signals
    reg pc_alu_sel, pc_next_sel;

    // output 
    wire [31:0] pc_value, pc_alu;

    localparam PERIOD = 10;

    programCounter uut(
        .clk(clk), 
        .reset_n(reset_n), 
        .alu_imm_pc_next(alu_imm_pc_next), 
        .imm_offset(imm_offset),
        .pc_alu_sel(pc_alu_sel),
        .pc_next_sel(pc_next_sel),
        .pc_value(pc_value),
        .pc_alu(pc_alu)
    );  

    initial begin
        clk = 1'b0;
        reset_n = 1'b0;
        pc_alu_sel = 1'b0;
        pc_next_sel = 1'b0;
        alu_imm_pc_next = 32'b0;
        imm_offset = 32'b0;
    end

    always
    #(PERIOD/2) clk = ~clk;

    initial begin
        #PERIOD;
        reset_n = 1'b1;

        // start
        #(PERIOD*10);

        // load from ALU
        pc_next_sel = 1'b1;
        alu_imm_pc_next = 32'hff00ff00;
        #(PERIOD);
        pc_next_sel = 1'b0;

        // reset
        reset_n = 1'b0;
        #(PERIOD);
        reset_n = 1'b1;

        // immediate offset
        #(PERIOD*10);
        pc_alu_sel = 1'b1;
        imm_offset = 32'd400;

        #(PERIOD*4);
        $finish;
    end

    initial begin
        $dumpfile("../waveform/rv32_programCounter.vcd");
        $dumpvars();
    end

endmodule