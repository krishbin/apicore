`timescale 1ns/1ps
`include "../core/DEFINITIONS.v"
`include "../core/rv32im_exu.v"
`include "../core/mem_RAM.v"
`include "../core/mem_ROM.v"
`include "../core/rv32im_decoder.v"

module tb();

    //decoder module
    reg clk;
    reg [31:0] instruction;
    wire [1:0] data_origin, data_target;
    wire [31:0] imm;
    wire [4:0] rs1_addr, rs2_addr, rd_addr;
    wire [4:0] alu_opcode;
    wire [7:0] lsu_opcode;
    wire [2:0] br_opcode;
    wire is_branch, is_condition;
    wire [2:0] csr_opcode;
    wire [11:0] csr_addr;
    wire [31:0] csr_data;
    wire mem_w;
    wire reg_w;

    //execution unit
    reg  [31:0] curr_pc,rs1, rs2;
    wire [31:0] new_pc,data, val_memdatawr, val_memdatard, val_memaddr;
    wire [3:0] wr_mask;

    wire [31:0] exu_data_o, ROM_data;

    reg reset_n;
    wire enable_RAM;
    wire enable_ROM;

    rv32im_decoder_and_cu decoder_uut(
        .clk(clk),
        .instruction(instruction),
        .data_origin_o(data_origin),
        .data_target_o(data_target),
        .imm_o(imm),
        .rs1_addr_o(rs1_addr),
        .rs2_addr_o(rs2_addr),
        .rd_addr_o(rd_addr),
        .alu_opcode_o(alu_opcode),
        .lsu_opcode_o(lsu_opcode),
        .br_opcode_o(br_opcode),
        .is_branch_o(is_branch),
        .is_condition_o(is_condition),
        .csr_opcode_o(csr_opcode),
        .csr_addr_o(csr_addr),
        .csr_data_o(csr_data),
        .mem_w_o(mem_w),
        .reg_w_o(reg_w)
    );

    rv32im_exu exu_uut(
        .alu_opcode_i(alu_opcode),
        .lsu_opcode_i(lsu_opcode),
        .br_opcode_i(br_opcode),
        .rs1_i(rs1),
        .rs2_i(rs2),
        .imm_i(imm),
        .data_origin_i(data_origin),
        .data_target_i(data_target),
        .val_memdatard_i(val_memdatard),
        .val_memdatawr_o(val_memdatawr),
        .val_memaddr_o(val_memaddr),
        .is_branch_i(is_branch),
        .is_condition_i(is_condition),
        .curr_pc_i(curr_pc),
        .new_pc_o(new_pc),
        .csr_output_i(csr_data),
        .data_o(exu_data_o)
    );

    mem_RAM RAM_uut(
        .clk(clk),
        .reset_n(reset_n),
        .en(enable_RAM),
        .address_i(val_memaddr),
        .data_in_i(val_memdatawr),
        .data_out_o(val_memdatard),
        .wr_mask_i(wr_mask)
    );

    mem_ROM ROM_uut(
        .clk(clk),
        .reset_n(reset_n),
        .en(enable_ROM),
        .address_i(new_pc),
        .data_o(ROM_data)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("../waveform/int.vcd");
        $dumpvars();

        clk = 1'b0;
        reset_n = 1'b0;
        #10;
        reset_n = 1'b1;

        instruction = 32'habcde237; // lui x4,0xabcde
        curr_pc = 32'h0 ;rs1 = 32'h44; rs2 = 32'h45;
        #10;
        instruction = 32'habcde217; // auipc x4,0xabcde
        #10;
        instruction = 32'h00c000ef; // jal x1,0x0000000c
        #10;
        instruction = 32'h00808267; // jalr x4,8(x1)
        #10;
        instruction = 32'hff808267; // jalr x4,-8(x1)
        #10;
        instruction = 32'h00000263; // beq x0,x0,0x00000018
        #10;
        instruction = 32'hfe001ee3; // bne x0,x0,0x00000014
        #10;
        instruction = 32'h00004263; // blt x0,x0,0x00000020
        #10;
        instruction = 32'h00005263; // bge x0,x0,0x00000024
        #10;
        instruction = 32'h00006263; // bltu x0,x0,0x00000028
        #10;
        instruction = 32'h00007263; // bgeu x0,x0,0x0000002c
        #10;
        instruction = 32'h4d200203; // lb x4,1234(x0)
        #10;
        instruction = 32'hb2e01203; // lh x4,-1234(x0)
        #10;
        instruction = 32'h4d202203; // lw x4,1234(x0)
        #10;
        instruction = 32'h80004203; // lbu x4,-2048(x0)
        #10;
        instruction = 32'h00005203; // lhu x4,0(x0)
        #10;
        instruction = 32'h4c400923; // sb x4,1234(x0)
        #10;
        instruction = 32'h4c401923; // sh x4,1234(x0)
        #10;
        instruction = 32'h4c402923; // sw x4,1234(x0)
        #10;
        $finish;
    end


endmodule