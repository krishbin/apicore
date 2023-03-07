`ifndef _DEFINITIONS_V_
`define _DEFINITIONS_V_

// RV32IM INSTRUCTION SET CODES
`define API_ADDR_WIDTH              32
`define API_DATA_WIDTH              32
`define API_REGISTER_WIDTH          32
`define API_REGISTER_COUNT          32
`define API_REGISTER_ADDR_WIDTH     5

`define API_PC_WIDTH                32
`define API_RESET_PC                32'h00000000
`define API_XLEN                    32

// R-TYPE
`define INST_R_ALU                  7'b0110011
    // FUNCT3
    // I extension
    `define ADD_SUB_FUNCT3          3'b000
    `define SLL_FUNCT3              3'b001
    `define SLT_FUNCT3              3'b010
    `define SLTU_FUNCT3             3'b011
    `define XOR_FUNCT3              3'b100
    `define SRL_SRA_FUNCT3          3'b101
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
    `define SUB_FUNCT7              7'b0100000
    `define SLL_FUNCT7              7'b0
    `define SLT_FUNCT7              7'b0
    `define SLTU_FUNCT7             7'b0
    `define XOR_FUNCT7              7'b0
    `define SRL_FUNCT7              7'b0
    `define SRA_FUNCT7              7'b0100000
    `define OR_FUNCT7               7'b0
    `define AND_FUNCT7              7'b0
    // M extension
    `define M_EXTENSION_FUNCT7      7'b0


// I-TYPE
`define INST_I_ALU                  7'b0010011
    // FUNCT3
    // I extension
    `define ADDI_FUNCT3             3'b000
    `define SLTI_FUNCT3             3'b010
    `define SLTIU_FUNCT3            3'b011
    `define XORI_FUNCT3             3'b100
    `define ORI_FUNCT3              3'b110
    `define ANDI_FUNCT3             3'b111
    `define SLLI_FUNCT3             3'b001
    `define SRLI_FUNCT3             3'b101
    `define SRAI_FUNCT3             3'b101
    //FUNCT7
    // I extension
    `define SLLI_FUNCT7             7'b0
    `define SRLI_FUNCT7             7'b0
    `define SRAI_FUNCT7             7'b0100000

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


`define INST_I_FENCE                7'b0001111
    // FUNCT3
    `define FENCE_FUNCT3            3'b000
    `define FENCEI_FUNCT3           3'b001

`define INST_I_SYS                  7'b1110011
    //FUNCT3
    `define CSRRW_FUNCT3            3'b001
    `define CSRRS_FUNCT3            3'b010
    `define CSRRC_FUNCT3            3'b011
    // Immediate CSR
    `define CSRRWI_FUNCT3           3'b101
    `define CSRRSI_FUNCT3           3'b110
    `define CSRRCI_FUNCT3           3'b111
    // ECALL/EBREAK
    `define ECALL_EBREAK_FUNCT3     3'b000
    `define ECALL_IMM               12'b0
    `define EBREAK_IMM              12'b1    

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

`define ALU_OPCODE_WIDTH            5
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

`define BR_OPCODE_WIDTH 3
`define BR_OPCODE_BEQ   3'b000
`define BR_OPCODE_BNE   3'b001
`define BR_OPCODE_BLT   3'b100
`define BR_OPCODE_BGE   3'b101
`define BR_OPCODE_BLTU  3'b110
`define BR_OPCODE_BGEU  3'b111
`define BR_OPCODE_NONE  3'b011

// Data origins 
`define DATA_ORIGIN_WIDTH		2
`define DATA_ORIGIN_REGISTER    0		
`define DATA_ORIGIN_RS1_IMM  	1
`define DATA_ORIGIN_PC_IMM     	2
`define DATA_ORIGIN_UNUSED 		3

// Data destinations
`define DATA_TARGET_WIDTH   2
`define DATA_TARGET_ALU     0
`define DATA_TARGET_MEM     1
`define DATA_TARGET_PC      2
`define DATA_TARGET_CSR     3

`define IRQ_MASK            32'hFFFFFFFF

`define PRIVILEDGE_MODE_M   0

`define CSR_XLEN            32
`define CSR_OPCODE_WIDTH    3
`define CSR_WIDTH           12

`define CSR_OPCODE_CSRRW    3'b000
`define CSR_OPCODE_CSRRS    3'b010
`define CSR_OPCODE_CSRRC    3'b011
`define CSR_OPCODE_CSRRWI   3'b100
`define CSR_OPCODE_CSRRSI   3'b110
`define CSR_OPCODE_CSRRCI   3'b111

`define CSR_OPCODE_READ     3'b001
`define CSR_OPCODE_WRITE    3'b010
`define CSR_OPCODE_SET      3'b011
`define CSR_OPCODE_CLEAR    3'b111

`define CSR_MSTATUS         12'h300
`define CSR_MEDELEG         12'h302
`define CSR_MIDELEG         12'h303
`define CSR_MIE             12'h304
`define CSR_MTVEC           12'h305
`define CSR_MSCRATCH        12'h340
`define CSR_MEPC            12'h341
`define CSR_MCAUSE          12'h342
`define CSR_MTVAL           12'h343
`define CSR_MIP             12'h344
`define CSR_MCYCLE          12'hc00
`define CSR_MCYCLE_H        12'hc80
`define CSR_MTIME           12'hc01
`define CSR_MTIMEH          12'hc81
`define CSR_MHARTID         12'hF14
`define CSR_MPRIV           12'hF10
// Non-std
`define CSR_MTIMECMP        12'h7c0
// machine information registers
`define CSR_MVENDORID     12'hF11
`define CSR_MARCHID       12'hF12
`define CSR_MIMPID        12'hF13
`define CSR_MHARTID       12'hF14

`define CSR_MSTATUS_MASK    32'hFFFFFFFF
`define CSR_MEDELEG_MASK    32'h0000FFFF
`define CSR_MIDELEG_MASK    32'h0000FFFF
`define CSR_MIE_MASK        `IRQ_MASK
`define CSR_MTVEC_MASK      32'hFFFFFFFF
`define CSR_MSCRATCH_MASK   32'hFFFFFFFF
`define CSR_MEPC_MASK       32'hFFFFFFFF
`define CSR_MCAUSE_MASK     32'h8000000F
`define CSR_MTVAL_MASK      32'hFFFFFFFF
`define CSR_MIP_MASK        `IRQ_MASK
`define CSR_MCYCLE_MASK     32'hFFFFFFFF
`define CSR_MCYCLE_H_MASK   32'hFFFFFFFF
`define CSR_MTIME_MASK      32'hFFFFFFFF
`define CSR_MTIMEH_MASK     32'hFFFFFFFF
`define CSR_MHARTID_MASK    32'hFFFFFFFF
`define CSR_MPRIV_MASK      32'h00000001
`define CSR_MTIMECMP_MASK   32'hFFFFFFFF

`define CSR_MSTATUS_RESET   32'h00001800
`define CSR_MEDELEG_RESET   32'h00000000
`define CSR_MIDELEG_RESET   32'h00000000
`define CSR_MIE_RESET       32'h00000000
`define CSR_MTVEC_RESET     32'h00000000
`define CSR_MSCRATCH_RESET  32'h00000000
`define CSR_MEPC_RESET      32'h00000000
`define CSR_MCAUSE_RESET    32'h00000000
`define CSR_MTVAL_RESET     32'h00000000
`define CSR_MIP_RESET       32'h00000000
`define CSR_MPRIV_RESET     32'h00000000
`define CSR_MCYCLE_RESET    32'h00000000
`define CSR_MCYCLE_H_RESET  32'h00000000

`define CSR_MISA          12'h301
`define CSR_MISA_MASK     32'hFFFFFFFF
    `define MISA_RV32     32'h40000000
    `define MISA_RVI      32'h00000100
    `define MISA_RVE      32'h00000010
    `define MISA_RVM      32'h00001000
    `define MISA_RVA      32'h00000001
    `define MISA_RVF      32'h00000020
    `define MISA_RVD      32'h00000008
    `define MISA_RVC      32'h00000004
    `define MISA_RVS      32'h00040000
    `define MISA_RVU      32'h00100000

`endif
// END OF INSTRUCTION SET CODES


// LSU Definitions
`define LSU_FSM_IDLE  1'b0
`define LSU_FSM_BUSY  1'b1
`define LSU_CMD_UPD   1'b1
`define LSU_CMD_LOAD  1'b1
`define LSU_CMD_STORE 1'b1

// LSU-OPCODES
`define LSU_OPCODE_WIDTH             8
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

// DMEM interface
// memory command (read/write)
`define MEM_CMD_READ 1'b0
`define MEM_CMD_WRITE 1'b1

// memory width (byte/halfword/word)
`define MEM_WIDTH_BYTE     = 2'b00
`define MEM_WIDTH_HWORD    = 2'b01
`define MEM_WIDTH_WORD     = 2'b10

`define MEM_RESP_NOTRDY    = 2'b00,
`define MEM_RESP_RDY_OK    = 2'b01,
`define MEM_RESP_RDY_ER    = 2'b10

`define EXC_CODE_INSTR_MISALIGN        = 4'd0,     // from EXU
`define EXC_CODE_INSTR_ACCESS_FAULT    = 4'd1,     // from IFU
`define EXC_CODE_ILLEGAL_INSTR         = 4'd2,     // from IDU or CSR
`define EXC_CODE_BREAKPOINT            = 4'd3,     // from IDU or BRKM
`define EXC_CODE_LD_ADDR_MISALIGN      = 4'd4,     // from LSU
`define EXC_CODE_LD_ACCESS_FAULT       = 4'd5,     // from LSU
`define EXC_CODE_ST_ADDR_MISALIGN      = 4'd6,     // from LSU
`define EXC_CODE_ST_ACCESS_FAULT       = 4'd7,     // from LSU
`define EXC_CODE_ECALL_M               = 4'd11     // from IDU

`endif
// END OF INSTRUCTION SET CODES