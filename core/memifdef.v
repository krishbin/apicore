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
