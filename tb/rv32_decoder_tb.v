`timescale 1ns/1ps
`include "../core/rv32im_decoder.v"

module decoder_tb();
    reg clk;
    reg [31:0] instruction;

    // Execution Unit 
    wire [`DATA_ORIGIN_WIDTH-1:0] data_origin;
    wire [`DATA_TARGET_WIDTH-1:0] data_target;
    wire [`API_DATA_WIDTH-1:0] imm;
    // register file
    wire [`API_REGISTER_ADDR_WIDTH-1:0] rs1_addr;
    wire [`API_REGISTER_ADDR_WIDTH-1:0] rs2_addr;
    wire [`API_REGISTER_ADDR_WIDTH-1:0] rd_addr;
    // alu
    wire [`ALU_OPCODE_WIDTH-1:0] alu_opcode;
    wire [`LSU_OPCODE_WIDTH-1:0] lsu_opcode;
    //branch
    wire [`BR_OPCODE_WIDTH-1:0] br_opcode;
    wire is_branch;
    wire is_condition;
    //CSR Unit
    wire [`CSR_OPCODE_WIDTH-1:0] csr_opcode;
    wire [`CSR_WIDTH-1:0] csr_addr;
    wire [`API_DATA_WIDTH-1:0] csr_data;
    // memory
    wire mem_w;
    wire reg_w;

    rv32im_decoder_and_cu uut(
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

    localparam PERIOD = 10;

    always
    #(PERIOD/2) clk = ~clk;

    initial begin
        clk = 1'b0;

        instruction = 32'habcde237; // lui x4,0xabcde
        #(PERIOD);
        instruction = 32'habcde217; // auipc x4,0xabcde
        #(PERIOD);
        instruction = 32'h00c000ef; // jal x1,0x0000000c
        #(PERIOD);
        instruction = 32'h00808267; // jalr x4,8(x1)
        #(PERIOD);
        instruction = 32'hff808267; // jalr x4,-8(x1)
        #(PERIOD);
        instruction = 32'h00000263; // beq x0,x0,0x00000018
        #(PERIOD);
        instruction = 32'hfe001ee3; // bne x0,x0,0x00000014
        #(PERIOD);
        instruction = 32'h00004263; // blt x0,x0,0x00000020
        #(PERIOD);
        instruction = 32'h00005263; // bge x0,x0,0x00000024
        #(PERIOD);
        instruction = 32'h00006263; // bltu x0,x0,0x00000028
        #(PERIOD);
        instruction = 32'h00007263; // bgeu x0,x0,0x0000002c
        #(PERIOD);
        instruction = 32'h4d200203; // lb x4,1234(x0)
        #(PERIOD);
        instruction = 32'hb2e01203; // lh x4,-1234(x0)
        #(PERIOD);
        instruction = 32'h4d202203; // lw x4,1234(x0)
        #(PERIOD);
        instruction = 32'h80004203; // lbu x4,-2048(x0)
        #(PERIOD);
        instruction = 32'h00005203; // lhu x4,0(x0)
        #(PERIOD);
        instruction = 32'h4c400923; // sb x4,1234(x0)
        #(PERIOD);
        instruction = 32'h4c401923; // sh x4,1234(x0)
        #(PERIOD);
        instruction = 32'h4c402923; // sw x4,1234(x0)
        #(PERIOD);
        instruction = 32'h4d228213; // addi x4,x5,1234
        #(PERIOD);
        instruction = 32'hfff3a313; // slti x6,x7,-1
        #(PERIOD);
        instruction = 32'h8304b413; // sltiu x8,x9,-2000
        #(PERIOD);
        instruction = 32'h0015c513; // xori x10,x11,1
        #(PERIOD);
        instruction = 32'h7d06e613; // ori x12,x13,2000
        #(PERIOD);
        instruction = 32'h4d27f713; // andi x14,x15,1234
        #(PERIOD);
        instruction = 32'h00c89813; // slli x16,x17,12
        #(PERIOD);
        instruction = 32'h00c9d913; // srli x18,x19,12
        #(PERIOD);
        instruction = 32'h40cada13; // srai x20,x21,12
        #(PERIOD);
        instruction = 32'h018b8b33; // add x22,x23,x24
        #(PERIOD);
        instruction = 32'h41bd0cb3; // sub x25,x26,x27
        #(PERIOD);
        instruction = 32'h01ee9e33; // sll x28,x29,x30
        #(PERIOD);
        instruction = 32'h0020afb3; // slt x31,x1,x2
        #(PERIOD);
        instruction = 32'h0020b233; // sltu x4,x1,x2
        #(PERIOD);
        instruction = 32'h0020c233; // xor x4,x1,x2
        #(PERIOD);
        instruction = 32'h0042d1b3; // srl x3,x5,x4
        #(PERIOD);
        instruction = 32'h4042d1b3; // sra x3,x5,x4
        #(PERIOD);
        instruction = 32'h0020e233; // or x4,x1,x2
        #(PERIOD);
        instruction = 32'h0020f233; // and x4,x1,x2
        #(PERIOD);
        instruction = 32'h000b1a73; // csrrw x20,0x000,x22
        #(PERIOD);
        instruction = 32'h001cabf3; // csrrs x23,0x001,x25
        #(PERIOD);
        instruction = 32'h002e3d73; // csrrc x26,0x002,x28
        #(PERIOD);
        instruction = 32'hfff55ef3; // csrrwi x29,0xfff,10
        #(PERIOD);
        instruction = 32'h10066f73; // csrrsi x30,0x100,12
        #(PERIOD);
        instruction = 32'h00177ff3; // csrrci x31,0x001,14
        #(PERIOD);
        instruction = 32'h001ffff3; // csrrci x31,0x001,31
        #(PERIOD);
        instruction = 32'h00100073; // ebreak
        #(PERIOD);
        instruction = 32'h00000073; // ecall
        #(PERIOD);
        instruction = 32'ha5a5a5a5; // ERROR: UNIMPLEMENTED INSTRUCTION
        #(PERIOD);

        #(PERIOD*4);
        $finish;
    end

    initial begin
        $dumpfile("../waveform/tb_decoder.vcd");
        $dumpvars();
    end

endmodule