// LSU Definitions
`define LSU_FSM_IDLE  1'b0
`define LSU_FSM_BUSY  1'b1
`define LSU_CMD_UPD   1'b1
`define LSU_CMD_LOAD  1'b1
`define LSU_CMD_STORE 1'b1

// DMEM interface
// memory command (read/write)
`define MEM_CMD_RD 1'b0
`define MEM_CMD_WR 1'b1

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
