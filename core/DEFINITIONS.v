`ifndef _DEFINITIONS_V_
`define _DEFINITIONS_V_

// RV32IM INSTRUCTION SET CODES
`define API_ADDR_WIDTH              32
`define API_DATA_WIDTH              32

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

`define INST_I_JALR                 7'b1100111
    // FUNCT3
    // I extension
    `define JALR_FUNCT3             3'b000
    
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

// ALU-OPCODES
// RV32I
// 0 func7 D5 func3                                            
// RV32M
// type(D4,D3) func3
// RV32F
// 
// typetable
// D4     D3       type
// 0      f7(D5)    I
// 1      0         M
// 1      1         F
`define ALU_OPCODE_ADD              5'b00000
`define ALU_OPCODE_SUB              5'b01000
`define ALU_OPCODE_SLL              5'b00001
`define ALU_OPCODE_SLT              5'b00010
`define ALU_OPCODE_SLTU             5'b00011
`define ALU_OPCODE_XOR              5'b00100
`define ALU_OPCODE_SRL              5'b00101
`define ALU_OPCODE_SRA              5'b01101
`define ALU_OPCODE_OR               5'b00110
`define ALU_OPCODE_AND              5'b00111
`define ALU_OPCODE_MUL              5'b10000
`define ALU_OPCODE_MULH             5'b10001
`define ALU_OPCODE_MULHSU           5'b10010
`define ALU_OPCODE_MULHU            5'b10011
`define ALU_OPCODE_DIV              5'b10100
`define ALU_OPCODE_DIVU             5'b10101
`define ALU_OPCODE_REM              5'b10110
`define ALU_OPCODE_REMU             5'b10110

// LSU-OPCODES
`define LSU_OPCODE_SIZE             8
// func3 opcode D6:D2
`define LSU_OPCODE_LB               8'b00000000
`define LSU_OPCODE_LH               8'b00100000
`define LSU_OPCODE_LW               8'b01000000
`define LSU_OPCODE_LBU              8'b10000000
`define LSU_OPCODE_LHU              8'b10100000
`define LSU_OPCODE_SB               8'b00001000
`define LSU_OPCODE_SH               8'b00101000
`define LSU_OPCODE_SW               8'b01001000
`define LSU_OPCODE_NONE             8'b11111111

`endif
// END OF INSTRUCTION SET CODES
