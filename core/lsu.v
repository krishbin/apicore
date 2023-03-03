`include "DEFINITIONS.v"
`include "memifdef.v"


module rv32im_lsu (
        // mem_interface
        //--------------------------------
        // we read memory to this input
        input [`API_DATA_WIDTH-1:0] val_memrd_i,
        output reg [`API_DATA_WIDTH-1:0] val_memwr_o,

        // exu_interface
        //--------------------------------
        input [`LSU_OPCODE_WIDTH-1:0] lsu_opcode_i,
        // where to read/write from/to
        input [`API_ADDR_WIDTH-1:0] addr_mem_i,
        // what needs to to written to memory
        input [`API_DATA_WIDTH-1:0] val_memwr_i,
        // output of memory read
        output reg [`API_DATA_WIDTH-1:0] val_memrd_o,

        output [`API_ADDR_WIDTH-1:0] addr_mem_o
);
        assign addr_mem_o = addr_mem_i[`API_ADDR_WIDTH-1:0];

        always @ * begin
                val_memrd_o = {{`API_DATA_WIDTH{1'b0}}};
                val_memwr_o = {{`API_DATA_WIDTH{1'b0}}};
                
                case (lsu_opcode_i)
                        // Load word, halfword, byte
                        `LSU_OPCODE_LB: val_memrd_o = { { `API_DATA_WIDTH - 8 {val_memrd_i[7]}}, val_memrd_i[7:0] };
                        `LSU_OPCODE_LBU: val_memrd_o = { {`API_DATA_WIDTH - 8{1'b0}} , val_memrd_i[7:0]};
                        `LSU_OPCODE_LH: val_memrd_o = { { `API_DATA_WIDTH - 16 {val_memrd_i[15]}}, val_memrd_i[15:0] };
                        `LSU_OPCODE_LHU: val_memrd_o = { {`API_DATA_WIDTH - 16{1'b0}} , val_memrd_i[15:0]};
                        `LSU_OPCODE_LW: val_memrd_o = val_memrd_i;

                        //store word, halfword, byte
                        `LSU_OPCODE_SB: val_memwr_o = { {`API_DATA_WIDTH-8{1'b0}} , val_memwr_i[7:0]};
                        `LSU_OPCODE_SH: val_memwr_o = { {`API_DATA_WIDTH-16{1'b0}} , val_memwr_i[15:0]};
                        `LSU_OPCODE_SW: val_memwr_o = val_memwr_i;
                        default: begin
                                val_memrd_o = {{`API_DATA_WIDTH{1'b0}}};
                                val_memwr_o = {{`API_DATA_WIDTH{1'b0}}};
                        end
                endcase
        end
endmodule
