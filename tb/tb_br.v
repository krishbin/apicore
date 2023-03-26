`timescale 1ns/1ps
`include "../core/DEFINITIONS.v"
`include "../core/rv32im_br.v"

module rv32im_br_tb();

    reg alu_zero;
    reg br_en;
    reg br_conditional;
    reg [`API_ADDR_WIDTH-1:0] alu_result;
    reg [`BR_OPCODE_WIDTH-1:0] br_opcode;
    reg [`API_ADDR_WIDTH-1:0] curr_pc;
    reg [`API_DATA_WIDTH-1:0] imm;
    wire [`API_ADDR_WIDTH-1:0] br_pc;
    wire [`API_ADDR_WIDTH-1:0] nxt_pc;

    rv32im_br uut(
        .alu_zero_i(alu_zero),
        .br_en_i(br_en),
        .br_conditional_i(br_conditional),
        .exu_calc_addr(alu_result),
        .br_opcode_i(br_opcode),
        .curr_pc_i(curr_pc),
        .imm_i(imm),
        .br_pc_o(br_pc),
        .nxt_pc_o(nxt_pc)
    );

    initial begin
        $dumpfile("../waveform/br.vcd");
        $dumpvars();

        br_en=1'b1;br_conditional=1'b0;alu_zero=1'b0;alu_result=32'hffeeddcc  ;   imm=32'h00000000;curr_pc=32'h001ffff3;#10;

        // beq
        br_en=1'b1;br_conditional=1'b1;alu_zero=1'b0;alu_result=32'h1  ;br_opcode=`BR_OPCODE_BEQ;   imm=32'h00abcdef;curr_pc=32'h001ffff3;#10;  // no branch
        br_en=1'b1;br_conditional=1'b1;alu_zero=1'b1;alu_result=32'h0  ;br_opcode=`BR_OPCODE_BEQ;   imm=32'h00abcdef;curr_pc=32'h001ffff3;#10;  // branch
        // bne
        br_en=1'b1;br_conditional=1'b1;alu_zero=1'b1;alu_result=32'h0  ;br_opcode=`BR_OPCODE_BNE;   imm=32'h00abcdee;curr_pc=32'h00000003;#10;  // no branch
        br_en=1'b1;br_conditional=1'b1;alu_zero=1'b0;alu_result=32'h5  ;br_opcode=`BR_OPCODE_BNE;   imm=32'h00abcdee;curr_pc=32'h00000003;#10;  // branch

        // blt
        br_en=1'b1;br_conditional=1'b1;alu_zero=1'b0;alu_result=32'h9  ;br_opcode=`BR_OPCODE_BLT;  imm=32'h00abcdef;curr_pc=32'h001ffff3;#10;  // no branch
        br_en=1'b1;br_conditional=1'b1;alu_zero=1'b1;alu_result=32'h0  ;br_opcode=`BR_OPCODE_BLT;  imm=32'h00abcdef;curr_pc=32'h001ffff3;#10;  // no branch
        br_en=1'b1;br_conditional=1'b1;alu_zero=1'b0;alu_result=-32'h9 ;br_opcode=`BR_OPCODE_BLT;  imm=32'h00abcdef;curr_pc=32'h001ffff3;#10;  // branch branch
        // bge
        br_en=1'b1;br_conditional=1'b1;alu_zero=1'b0;alu_result=-32'h9 ;br_opcode=`BR_OPCODE_BGE;   imm=32'h00abcdef;curr_pc=32'h001ffff3;#10; // no branch
        br_en=1'b1;br_conditional=1'b1;alu_zero=1'b1;alu_result=32'h0  ;br_opcode=`BR_OPCODE_BGE;   imm=32'h00abcdef;curr_pc=32'h001ffff3;#10; // branch
        br_en=1'b1;br_conditional=1'b1;alu_zero=1'b0;alu_result=32'h9  ;br_opcode=`BR_OPCODE_BGE;   imm=32'h00abcdef;curr_pc=32'h001ffff3;#10; // branch

        // bltu
        br_en=1'b1;br_conditional=1'b1;alu_zero=1'b1;alu_result=32'h0  ;br_opcode=`BR_OPCODE_BLTU;  imm=32'h00abcdef;curr_pc=32'h001ffff3;#10;
        // bgeu
        br_en=1'b1;br_conditional=1'b1;alu_zero=1'b1;alu_result=32'h0  ;br_opcode=`BR_OPCODE_BGEU;  imm=32'h00abcdef;curr_pc=32'h001ffff3;#10;

    

        $finish;
    end

endmodule