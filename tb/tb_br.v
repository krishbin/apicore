`timescale 1ns/1ps
`include "../core/DEFINITIONS.v"
`include "../core/br.v"

module rv32im_br_tb();

    reg alu_zero;
    reg br_en;
    reg br_conditional;
    reg [`API_ADDR_WIDTH-1:0] exu_calc_addr;
    reg [`BR_OPCODE_WIDTH-1:0] br_opcode;
    reg [`API_ADDR_WIDTH-1:0] curr_pc;
    reg [`API_DATA_WIDTH-1:0] imm;
    wire [`API_ADDR_WIDTH-1:0] br_pc;
    wire [`API_ADDR_WIDTH-1:0] nxt_pc;

    rv32im_br uut(
        .alu_zero_i(alu_zero),
        .br_en_i(br_en),
        .br_conditional_i(br_conditional),
        .exu_calc_addr(exu_calc_addr),
        .br_opcode_i(br_opcode),
        .imm_i(imm),
        .br_pc_o(br_pc),
        .nxt_pc_o(nxt_pc)
    );

    initial begin
        $dumpfile("../waveform/br.vcd");
        $dumpvars();

        alu_zero = 1'b0;
        br_en    = 1'b0;
        br_conditional = 1'b0;
        // exu_calc_addr = 
        br_opcode = 'b0;
        curr_pc = 32'h001ffff3;
        imm = 'b0;
        #10;

        alu_zero = 1'b0;
        br_opcode = `BR_OPCODE_BEQ;
        br_en    = 1'b1;
        br_conditional = 1'b1;
        imm = 'd15;
        #10;

        alu_zero = 1'b1;
        br_opcode = `BR_OPCODE_BEQ;
        br_en    = 1'b1;
        br_conditional = 1'b1;
        imm = 'd15;
        #10;

        $finish;
    end

endmodule