`include "../core/DEFINITIONS.v"
`include "lsu.v"
`include "alu.v"
`include "br.v"

module rv32im_exu(
        // decocder to exu interface
        input [`ALU_OPCODE_WIDTH-1:0] alu_opcode_i,
        input [`LSU_OPCODE_WIDTH-1:0] lsu_opcode_i,
        input [`BR_OPCODE_WIDTH-1:0] br_opcode_i,
        input [`API_DATA_WIDTH-1:0] rs1_i, //rs1
        input [`API_DATA_WIDTH-1:0] rs2_i, //rs2
        input [`API_DATA_WIDTH-1:0] imm_i, //imm
        // data origin and target
        input [`DATA_ORIGIN_WIDTH-1:0] data_origin_i,
        input [`DATA_TARGET_WIDTH-1:0] data_target_i,

        // exu to lsu interface
        input [`API_DATA_WIDTH-1:0]  val_memdatard_i, // data read from memory
        output [`API_DATA_WIDTH-1:0] val_memdatawr_o, // data to write to memory
        output [`API_ADDR_WIDTH-1:0] val_memaddr_o, // address to read and write from  
        // exu to br interface
        input is_branch_i,
        input is_condition_i,
        
        input [`API_ADDR_WIDTH-1:0] curr_pc_i,
        output [`API_ADDR_WIDTH-1:0] new_pc_o,

        input  [`API_DATA_WIDTH-1:0] csr_output_i,
        output reg [`API_DATA_WIDTH-1:0] data_o
);

        wire [`API_DATA_WIDTH-1:0] alu_result;
        wire [`API_ADDR_WIDTH-1:0] nxt_pc;
        wire [`API_DATA_WIDTH-1:0] mem_output;
        wire alu_zero;

        reg [`API_ADDR_WIDTH-1:0] aluoperand_1;
        reg [`API_ADDR_WIDTH-1:0] aluoperand_2;

        always @* begin
                data_o = 0;
                aluoperand_1 = 0;
                aluoperand_2 = 0;

                case (data_origin_i)
                        `DATA_ORIGIN_REGISTER: begin
                                aluoperand_1 = rs1_i;
                                aluoperand_2 = rs2_i;
                        end
                        `DATA_ORIGIN_RS1_IMM: begin
                                aluoperand_1 = rs1_i;
                                aluoperand_2 = imm_i;
                        end
                        `DATA_ORIGIN_PC_IMM: begin
                                aluoperand_1 = curr_pc_i;
                                aluoperand_2 = imm_i;
                        end
                        default: begin
                                aluoperand_1 = rs1_i;
                                aluoperand_2 = rs2_i;
                        end
                endcase

                case (data_target_i)
                        `DATA_TARGET_ALU: begin
                                data_o = alu_result;
                        end
                        `DATA_TARGET_MEM: begin
                                data_o = mem_output;
                        end
                        `DATA_TARGET_PC: begin
                                data_o = nxt_pc;
                        end
                        `DATA_TARGET_CSR: begin
                                data_o = csr_output_i;
                        end
                endcase
        end

        rv32im_alu alu1 (
                .aluoperand_1_i(aluoperand_1),
                .aluoperand_2_i(aluoperand_2),
                .alu_opcode_i(alu_opcode_i),
                .alu_o(alu_result),
                .alu_zero_o(alu_zero)
        );

        rv32im_lsu lsu1 (
                .lsu_opcode_i(lsu_opcode_i),
                // unimodified input from exu | data request from memory
                .val_memrd_i(val_memdatard_i),
                // data to send to memory
                .val_memwr_o(val_memdatawr_o),
                // rs2 data from exu as address is combination of rs1 and imm
                .val_memwr_i(rs2_i),
                // first data is sent by exu to lsu and then
                // modified by lsu and sent to exu
                .val_memrd_o(mem_output),
                // data sent from exu to lsu
                .addr_mem_i(alu_result),
                .addr_mem_o(val_memaddr_o)
        );

        rv32im_br br1 (
                .alu_zero_i(alu_zero),
                .br_en_i(is_branch_i),
                .br_conditional_i(is_condition_i),
                .exu_calc_addr(alu_result),
                .nxt_pc_o(nxt_pc), // pc + 4
                .br_opcode_i(br_opcode_i),
                .curr_pc_i(curr_pc_i),
                .imm_i(imm_i),
                .br_pc_o(new_pc_o) // pc + imm
        );
endmodule