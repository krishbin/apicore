`timescale 1ns/1ps
`include "../core/rv32_decoder.v"

module decoder_tb();

    reg clk;
    reg [31:0] instruction;

    wire [31:0] decoded_value;
    wire [4:0] rs1, rs2, rd;
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire shift_la_sel, trap;
    wire e_call_break;
    wire [7:0] pred_succ;

    decoder uut(
        .clk(clk),
        .instruction(instruction),
        .decoded_value(decoded_value),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .shift_la_sel(shift_la_sel),
        .trap(trap),
        .e_call_break(e_call_break),
        .pred_succ(pred_succ)
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
        instruction = 32'h004000ef; // jal x1,0x0000000c
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
        $dumpfile("../waveforms/rv32_decoder_tb.vcd");
        $dumpvars();
    end

endmodule