`ifndef _DEFINITIONS_V_
`define _DEFINITIONS_V_

// RV32IM INSTRUCTION SET CODES

// R-TYPE
`define INST_R_ALU                  7'b0110011
    // FUNCT3
    // I extension
    `define ADD_FUNCT3              3'b000
    `define SUB_FUNCT3              3'b000
    `define SLL_FUNCT3              3'b001
    `define SLT_FUNCT3              3'b010
    `define SLTU_FUNCT3             3'b011
    `define XOR_FUNCT3              3'b100
    `define SRL_FUNCT3              3'b101
    `define SRA_FUNCT3              3'b101
    `define OR_FUNCT3               3'b110
    `define AND_FUNCT3              3'b111
    // M extension
    `define MUL_FUNCT3              3'b000
    `define MULH_FUNCT3             3'b001
    `define MULHSU_FUNCT3           3'b010
    `define MULHU_FUNCT3            3'b011
    `define DIV_FUNCT3              3'b100
    `define DIVU_FUNCT3             3'b101
    `define REM_FUNCT3              3'b110
    `define REMU_FUNCT3             3'b110
    // FUNCT7
    // I extension
    `define ADD_FUNCT7              7'b0
    `define SUB_FUNCT7              7'b01000000
    `define SLL_FUNCT7              7'b0
    `define SLT_FUNCT7              7'b0
    `define SLTU_FUNCT7             7'b0
    `define XOR_FUNCT7              7'b0
    `define SRL_FUNCT7              7'b0
    `define SRA_FUNCT7              7'b01000000
    `define OR_FUNCT7               7'b0
    `define AND_FUNCT7              7'b0
    // M extension
    `define M_EXTENSION_FUNCT7      7'b0


// I-TYPE
`define INST_I_ALU                  7'b0010011
    // I extension
    `define ADDI_FUNCT3             3'b000
    `define SLTI_FUNCT3             3'b010
    `define SLTIU_FUNCT3            3'b011
    `define XORI_FUNCT3             3'b100
    `define ORI_FUNCT3              3'b110
    `define ANDI_FUNCT3             3'b111

`define INST_I_LOAD                 7'b0000011
    // I extension
    `define LB_FUNCT3               3'b000
    `define LH_FUNCT3               3'b001
    `define LW_FUNCT3               3'b010
    `define LBU_FUNCT3              3'b100
    `define LHU_FUNCT3              3'b101

`define INST_I_JALR                 7'b1100111
    // FUNCT3
    // I extension
    `define JALR_FUNCT3             3'b000

`define INST_I_SHIFT                7'b0010011
    // FUNCT3
    // I extension
    `define SLLI_FUNCT3             3'b001
    `define SRLI_FUNCT3             3'b101
    `define SRAI_FUNCT3             3'b101
    //FUNCT7
    // I extension
    `define SLLI_FUNCT7             7'b0
    `define SRLI_FUNCT7             7'b0
    `define SRAI_FUNCT7             7'b0100000

`define INST_I_FENCE                7'b0001111
    // FUNCT3
    `define FENCE_FUNCT3            3'b000
    `define FENCEI_FUNCT3           3'b001

`define INST_I_CALL_N_BREAK         7'b1110011
    // IMM values
    `define ECALL_IMM               12'b0
    `define EBREAK_IMM              12'b1    

`define INST_I_CSR                  7'b1110011
    //FUNCT3
    `define CSRRW_FUNCT3            3'b001
    `define CSRRS_FUNCT3            3'b010
    `define CSRRC_FUNCT3            3'b011
    // Immediate CSR
    `define CSRRWI_FUNCT3           3'b101
    `define CSRRSI_FUNCT3           3'b110
    `define CSRRCI_FUNCT3           3'b111

// S-TYPE
`define INST_S_STORE                7'b0100011
    // I extension
    `define SB_FUNCT3               3'b000
    `define SH_FUNCT3               3'b001
    `define SW_FUNCT3               3'b010


// U-TYPE
`define INST_U_LUI                  7'b0110111
`define INST_U_AUIPC                7'b0010111


// J-TYPE
`define INST_J_JAL                  7'b1101111


// B-TYPE
`define INST_B_BRANCH               7'b1100011
    // FUNCT3
    // I extension
    `define BEQ_FUNCT3              3'b000
    `define BNE_FUNCT3              3'b001
    `define BLT_FUNCT3              3'b100
    `define BGE_FUNCT3              3'b101
    `define BLTU_FUNCT3             3'b110
    `define BGEU_FUNCT3             3'b111

`endif

// END OF INSTRUCTION SET CODES