`include "../core/DEFINITIONS.v"

module rv32im_decoder_and_cu(
    input clk,
    input [`API_DATA_WIDTH-1:0] instruction,

    //----------------------------------------------------------//
    // Execution Unit 
    //----------------------------------------------------------//
    output reg [`DATA_ORIGIN_WIDTH-1:0] data_origin_o,
    output reg [`DATA_TARGET_WIDTH-1:0] data_target_o,
    output reg [`API_DATA_WIDTH-1:0] imm_o,
    // register file
    output reg [`API_REGISTER_ADDR_WIDTH-1:0] rs1_addr_o,
    output reg [`API_REGISTER_ADDR_WIDTH-1:0] rs2_addr_o,
    output reg [`API_REGISTER_ADDR_WIDTH-1:0] rd_addr_o,
    // alu
    output reg [`ALU_OPCODE_WIDTH-1:0] alu_opcode_o,
    output reg [`LSU_OPCODE_WIDTH-1:0] lsu_opcode_o,

    //branch
    output reg [`BR_OPCODE_WIDTH-1:0] br_opcode_o,
    output reg is_branch_o,
    output reg is_condition_o,
    //----------------------------------------------------------//

    //----------------------------------------------------------//
    //CSR Unit
    output reg [`CSR_OPCODE_WIDTH-1:0] csr_opcode_o,
    output reg [`CSR_WIDTH-1:0] csr_addr_o,
    output reg [`API_DATA_WIDTH-1:0] csr_data_o,
    output reg csr_wr_en_o,
    output reg csr_rd_en_o,

    // memory
    output reg mem_w_o,
    output reg reg_w_o

    // output shift_la_sel,        // logical or arithmetic shift select
    // output [7:0] pred_succ,     // Fence instruction 
    // output e_call_break,
    // output trap
);

    localparam  R_TYPE = 3'b000,
                I_TYPE = 3'b001,
                S_TYPE = 3'b010,
                U_TYPE = 3'b011,
                J_TYPE = 3'b100,
                B_TYPE = 3'b111;


    reg [6:0] opcode;
    reg [6:0] func7;
    reg [2:0] func3;
    // r type
    reg [4:0] rs1,rs2,rd;

    // u type
    reg [19:0] imm_20;

    // i type
    reg [11:0] imm_12;

    // s type
    reg [11:0] imm_12_s;

    // b type
    reg [11:0] imm_12_b;

    // j type
    reg [19:0] imm_20_j;

    wire [2:0] instruction_type;

    // decode next available instruction
    always @(*) begin

        mem_w_o = 1'b0;
        reg_w_o = 1'b0;
        csr_wr_en_o = 1'b0;
        csr_rd_en_o = 1'b0;
        is_branch_o = 1'b0;
        is_condition_o = 1'b0;
        data_origin_o = 'bz;
        data_target_o = 'bz;
        imm_o = 'bz;
        rs1_addr_o = 'bz;
        rs2_addr_o = 'bz;
        rd_addr_o = 'bz;
        alu_opcode_o = 'bz;
        lsu_opcode_o = 'hff;
        br_opcode_o = 'bz;
        csr_opcode_o = 'bz;
        csr_addr_o = 'bz;
        csr_data_o = 'bz;
        
        opcode = instruction[6:0];
        func7 = instruction[31:25];
        func3 = instruction[14:12];
        rs1 = instruction[19:15];
        rs2 = instruction[24:20];
        rd = instruction[11:7];
        imm_12 = instruction[31:20];
        imm_20 = instruction[31:12];
        imm_20_j = { instruction[31], instruction[19:12], instruction[20], instruction[30:21] };
        imm_12_b = { instruction[31], instruction[7], instruction[30:25], instruction[11:8] };
        imm_12_s = { instruction[31:25], instruction[11:7] };

        case(opcode)
            `INST_R_ALU: begin
                data_origin_o = `DATA_ORIGIN_REGISTER; // provide data to alu
                reg_w_o = 1'b1;
                rs1_addr_o = rs1;
                rs2_addr_o = rs2;
                rd_addr_o = rd;
                case (func3)
                    `ADD_SUB_FUNCT3: alu_opcode_o = func7[5] == 1'b1 ? `ALU_OPCODE_SUB : `ALU_OPCODE_ADD;
                    `SLL_FUNCT3: alu_opcode_o = `ALU_OPCODE_SLL;
                    `SLT_FUNCT3: alu_opcode_o = `ALU_OPCODE_SLT;
                    `SLTU_FUNCT3: alu_opcode_o = `ALU_OPCODE_SLTU;
                    `XOR_FUNCT3: alu_opcode_o = `ALU_OPCODE_XOR;
                    `SRL_SRA_FUNCT3: alu_opcode_o = func7[5] == 1'b1 ? `ALU_OPCODE_SRA : `ALU_OPCODE_SRL;
                    `OR_FUNCT3: alu_opcode_o = `ALU_OPCODE_OR;
                    `AND_FUNCT3: alu_opcode_o = `ALU_OPCODE_AND;
                endcase
                data_target_o = `DATA_TARGET_ALU; // use data from alu
            end

            `INST_I_ALU: begin
                data_origin_o = `DATA_ORIGIN_RS1_IMM; // provide data to alu
                imm_o = { {20{imm_12[11]}}, imm_12 };
                reg_w_o = 1'b1;
                rs1_addr_o = rs1;
                rd_addr_o = rd;
                case (func3)
                    `ADD_SUB_FUNCT3: alu_opcode_o = func7[5] == 1'b1 ? `ALU_OPCODE_SUB : `ALU_OPCODE_ADD;
                    `SLL_FUNCT3: alu_opcode_o = `ALU_OPCODE_SLL;
                    `SLT_FUNCT3: alu_opcode_o = `ALU_OPCODE_SLT;
                    `SLTU_FUNCT3: alu_opcode_o = `ALU_OPCODE_SLTU;
                    `XOR_FUNCT3: alu_opcode_o = `ALU_OPCODE_XOR;
                    `SRL_SRA_FUNCT3: alu_opcode_o = func7[5] == 1'b1 ? `ALU_OPCODE_SRA : `ALU_OPCODE_SRL;
                    `OR_FUNCT3: alu_opcode_o = `ALU_OPCODE_OR;
                    `AND_FUNCT3: alu_opcode_o = `ALU_OPCODE_AND;
                endcase
                data_target_o = `DATA_TARGET_ALU; // use data from alu
            end

            `INST_I_LOAD: begin
                reg_w_o = 1'b1;
                rs1_addr_o = rs1;
                rd_addr_o = rd;
                alu_opcode_o = `ALU_OPCODE_ADD; // add imm to rs1
                data_origin_o = `DATA_ORIGIN_RS1_IMM; // provide data to alu
                imm_o = { {20{imm_12[11]}}, imm_12 };
                case (func3)
                    `LB_FUNCT3: lsu_opcode_o = `LSU_OPCODE_LB;
                    `LH_FUNCT3: lsu_opcode_o = `LSU_OPCODE_LH;
                    `LW_FUNCT3: lsu_opcode_o = `LSU_OPCODE_LW;
                    `LBU_FUNCT3: lsu_opcode_o = `LSU_OPCODE_LBU;
                    `LHU_FUNCT3: lsu_opcode_o = `LSU_OPCODE_LHU;
                    default: lsu_opcode_o = `LSU_OPCODE_NONE;
                endcase
                data_target_o = `DATA_TARGET_MEM; // use data from memory
            end

            `INST_I_JALR: begin
                is_branch_o = 1'b1;
                data_origin_o = `DATA_ORIGIN_RS1_IMM; // provide data to alu
                rs1_addr_o = rs1;
                alu_opcode_o = `ALU_OPCODE_ADD; // add imm to rs1
                imm_o = { {20{imm_12[11]}}, imm_12 };
                reg_w_o = 1'b1;
                rd_addr_o = rd;
                data_target_o = `DATA_TARGET_PC; // use data from pc provided by br
            end

            `INST_I_SYS: begin
                reg_w_o = 1'b1;
                rd_addr_o = rd;
                rs1_addr_o = rs1;
                csr_addr_o = imm_12;
                case(func3)
                    `ECALL_EBREAK_FUNCT3: ;
                    `CSRRW_FUNCT3: begin
                        if ( rd != 0 ) begin
                            csr_wr_en_o = 1'b1;
                            csr_rd_en_o = 1'b1;
                            data_target_o = `DATA_TARGET_CSR;
                            csr_opcode_o = `CSR_OPCODE_CSRRW;
                            csr_data_o = rs1;
                        end
                    end
                    `CSRRS_FUNCT3: begin
                        csr_wr_en_o = ( rs1 == 5'h0 ) ? 1'b1 : 1'b0;
                        csr_rd_en_o = 1'b1;
                        data_target_o = `DATA_TARGET_CSR;
                        csr_opcode_o = `CSR_OPCODE_CSRRS;
                        csr_data_o = rs1;
                    end
                    `CSRRC_FUNCT3: begin
                        csr_wr_en_o = ( rs1 == 5'h0 ) ? 1'b1 : 1'b0;
                        csr_rd_en_o = 1'b1;
                        data_target_o = `DATA_TARGET_CSR;
                        csr_opcode_o = `CSR_OPCODE_CSRRS;
                        csr_data_o = rs1;
                    end
                    `CSRRWI_FUNCT3: begin
                        csr_opcode_o = `CSR_OPCODE_CSRRWI;
                        csr_data_o = imm_12;
                    end
                    `CSRRSI_FUNCT3: begin
                        csr_opcode_o = `CSR_OPCODE_CSRRSI;
                        csr_data_o = imm_12;
                    end
                    `CSRRCI_FUNCT3: begin
                        csr_opcode_o = `CSR_OPCODE_CSRRCI;
                        csr_data_o = imm_12;
                    end
                endcase
            end

            `INST_I_FENCE: begin
            end

            `INST_S_STORE: begin
                data_origin_o = `DATA_ORIGIN_RS1_IMM;
                rs1_addr_o = rs1;
                rs2_addr_o = rs2;
                mem_w_o = 1'b1;
                alu_opcode_o = `ALU_OPCODE_ADD;
                imm_o = { {20{imm_12_s[11]}}, imm_12_s };
                case(func3)
                    `SB_FUNCT3: lsu_opcode_o = `LSU_OPCODE_SB;
                    `SH_FUNCT3: lsu_opcode_o = `LSU_OPCODE_SH;
                    `SW_FUNCT3: lsu_opcode_o = `LSU_OPCODE_SW;
                endcase
            end

            `INST_U_AUIPC: begin
                data_origin_o = `DATA_ORIGIN_PC_IMM;
                imm_o = { imm_20, {12{1'b0}} };
                reg_w_o = 1'b1;
                rd_addr_o = rd;
                alu_opcode_o = `ALU_OPCODE_ADD;
                data_target_o = `DATA_TARGET_ALU;
            end

            `INST_U_LUI: begin
                data_origin_o = `DATA_ORIGIN_RS1_IMM;
                imm_o = { imm_20, {12{1'b0}} };
                reg_w_o = 1'b1;
                rd_addr_o = rd;
                alu_opcode_o = `ALU_OPCODE_ADD;
                rs1_addr_o = {`API_REGISTER_ADDR_WIDTH{1'b0}};
                data_target_o = `DATA_TARGET_ALU;
            end

            `INST_J_JAL: begin
                is_branch_o = 1'b1;
                data_origin_o = `DATA_ORIGIN_PC_IMM;
                imm_o = { {11{imm_20_j[19]}}, imm_20_j, {1'b0} };
                reg_w_o = 1'b1;
                rd_addr_o = rd;
                alu_opcode_o = `ALU_OPCODE_ADD;
                data_target_o = `DATA_TARGET_PC;
            end

            `INST_B_BRANCH: begin
                is_branch_o = 1'b1;
                is_condition_o = 1'b1;
                data_origin_o = `DATA_ORIGIN_REGISTER;
                imm_o = { {19{instruction[31]}}, imm_12_b , {1'b0} };

                rs1_addr_o = rs1;
                rs2_addr_o = rs2;
                case(func3)
                    `BEQ_FUNCT3: begin
                        alu_opcode_o = `ALU_OPCODE_SUB;
                        br_opcode_o = `BR_OPCODE_BEQ;
                    end
                    `BNE_FUNCT3: begin
                        alu_opcode_o = `ALU_OPCODE_SUB;
                        br_opcode_o = `BR_OPCODE_BNE;
                    end
                    `BLT_FUNCT3: begin
                        alu_opcode_o = `ALU_OPCODE_SLT;
                        br_opcode_o = `BR_OPCODE_BLT;
                    end
                    `BGE_FUNCT3: begin
                        alu_opcode_o = `ALU_OPCODE_SLT;
                        br_opcode_o = `BR_OPCODE_BGE;
                    end
                    `BLTU_FUNCT3: begin
                        alu_opcode_o = `ALU_OPCODE_SLTU;
                        br_opcode_o = `BR_OPCODE_BLTU;
                    end
                    `BGEU_FUNCT3: begin
                        alu_opcode_o = `ALU_OPCODE_SLTU;
                        br_opcode_o = `BR_OPCODE_BGEU;
                    end
                endcase
            end

            default: begin
                rs1_addr_o = 5'b0;
                rd_addr_o = 5'b0;
                alu_opcode_o = `ALU_OPCODE_ADD;
                data_origin_o = `DATA_ORIGIN_REGISTER;
                imm_o = 32'bz;
                reg_w_o = 1'b0;
                is_branch_o = 1'b0;
                is_condition_o = 1'b0;
                data_target_o = `DATA_TARGET_ALU;
                mem_w_o = 1'b0;
                lsu_opcode_o = `LSU_OPCODE_NONE;
                csr_rd_en_o = 1'b0;
                csr_wr_en_o = 1'b0;
            end
        endcase
    end

endmodule