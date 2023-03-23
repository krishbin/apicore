`include "../core/DEFINITIONS.v"
// modules
`include "../core/rv32im_pc.v"
`include "../core/rv32im_decoder.v"
`include "../core/rv32im_regfile.v"
`include "../core/rv32im_exu.v"
`include "../core/rv32im_csr.v"
`include "../core/mem_RAM.v"
`include "../core/mem_ROM.v"

module core(
    input clk,
    input reset_n,
    input  [`API_DATA_WIDTH-1:0] data_ROM,  // instruction
    output [`API_PC_WIDTH-1:0] pc_curr,
    input  [`API_DATA_WIDTH-1:0] data_RAM_i,
    output [`API_DATA_WIDTH-1:0] data_RAM_o,
    output [`API_ADDR_WIDTH-1:0] addr_RAM_o,
    output [3:0] mem_wr_mask_o,
    output mem_RAM_enable
);

    // pc2exu wires
    wire [31:0] exu2pc_pc_next;
    // reg [31:0] pc2exu_pc_curr;
    
    // decoder and csr connection
    wire [`CSR_OPCODE_WIDTH-1:0] csr_opcode;
    wire [`CSR_WIDTH-1:0] csr_addr;
    wire [`CSR_XLEN-1:0] csr_data;
    wire [`CSR_XLEN-1:0] csr_data_in, csr_data_out;
    wire csr_rd_en, csr_wr_en;
    wire [`CSR_XLEN-1:0] csr_output;

    // decoder and exu connection
    wire [`DATA_ORIGIN_WIDTH-1:0] data_origin;
    wire [`DATA_TARGET_WIDTH-1:0] data_target;
    wire [`ALU_OPCODE_WIDTH-1:0] alu_opcode;
    wire [`LSU_OPCODE_WIDTH-1:0] lsu_opcode;
    wire [`BR_OPCODE_WIDTH-1:0] br_opcode;
    wire is_branch, is_condition;
    wire [`API_DATA_WIDTH-1:0] imm;

    // decoder and regfile connection
    wire [4:0] rs1_addr, rs2_addr, rd_addr;
    wire reg_we;

    // exu and regfile connection
    wire [`API_DATA_WIDTH-1:0] rs1_value, rs2_value;
    wire [`API_DATA_WIDTH-1:0] data;

    rv32im_pc core_pc(
        .clk(clk),
        .reset_n(reset_n),
        .pc_next_i(exu2pc_pc_next),
        .pc(pc_curr)
    );

    rv32im_decoder_and_cu core_dec_n_cu(
        .clk(clk),
        .instruction(data_ROM),
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
        .csr_wr_en_o(csr_wr_en),
        .csr_rd_en_o(csr_rd_en),
        .mem_w_o(),
        .reg_w_o(reg_we)
    );

    rv32im_exu core_exu(
        .alu_opcode_i(alu_opcode),
        .lsu_opcode_i(lsu_opcode),
        .br_opcode_i(br_opcode),
        .rs1_i(rs1_value),
        .rs2_i(rs2_value),
        .imm_i(imm),
        .data_origin_i(data_origin),
        .data_target_i(data_target),
        .val_memdatard_i(data_RAM_i),
        .val_memdatawr_o(data_RAM_o),
        .val_memaddr_o(addr_RAM_o),
        .mem_wr_mask_o(mem_wr_mask_o),
        .mem_enable_o(mem_RAM_enable),
        .is_branch_i(is_branch),
        .is_condition_i(is_condition),
        .curr_pc_i(pc_curr),
        .new_pc_o(exu2pc_pc_next),
        .csr_output_i(csr_output),
        .data_o(data)
    );

    rv32im_regfile core_regfile(
        .clk_i(clk),
        .rst_n_i(reset_n),
        .we_i(reg_we),
        .rs1_addr_i(rs1_addr),
        .rs2_addr_i(rs2_addr),
        .rd_addr_i(rd_addr),
        .val_rd_i(data),
        .val_rs1_o(rs1_value),
        .val_rs2_o(rs2_value)
    );

    rv32im_csr csr_reg(
        .clk_i(clk),
        .rst_n_i(rst_n),
        .csr_addr_i(csr_addr),
        .val_csr_i(csr_data),
        .we_csr_i(csr_wr_en),
        .re_csr_i(csr_rd_en),
        .val_csr_o(csr_output),
        .csr_opcode_i(csr_opcode)
    );

endmodule