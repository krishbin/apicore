`include "../core/DEFINITIONS.v"

module rv32im_lsu (
        // mem_interface
        //--------------------------------
        // we read memory to this input
        input [`API_DATA_WIDTH-1:0] val_memrd_i,
        output reg [`API_DATA_WIDTH-1:0] val_memwr_o,

        // ----- exu_interface ---------- 
        input [`LSU_OPCODE_WIDTH-1:0] lsu_opcode_i,     // opcode
        input [`API_ADDR_WIDTH-1:0] addr_mem_i,         // where to read/write from/to
        input [`API_DATA_WIDTH-1:0] val_memwr_i,        // what needs to to written to memory
        output reg [`API_DATA_WIDTH-1:0] val_memrd_o,   // output of memory read

        output [`API_ADDR_WIDTH-1:0] addr_mem_o,
        output [3:0] wr_mask_o,
        output enable_o
);
        assign addr_mem_o = (lsu_opcode_i === `LSU_OPCODE_NONE) ? 'bz : addr_mem_i;

        // select which bytes to update during store operation, 4-pins represent selection for 4 bytes each.
        assign wr_mask_o  =     ( lsu_opcode_i === `LSU_OPCODE_SB ) ? 
                                        (
                                                (addr_mem_i[1:0] === 2'b00) ? 4'b0001 :
                                                (addr_mem_i[1:0] === 2'b01) ? 4'b0010 :
                                                (addr_mem_i[1:0] === 2'b10) ? 4'b0100 : 4'b1000
                                        ) :
                                ( lsu_opcode_i === `LSU_OPCODE_SH ) ? 
                                        (
                                                (addr_mem_i[1] === 1'b0) ? 4'b0011 : 4'b1100 
                                        ) :
                                ( lsu_opcode_i === `LSU_OPCODE_SW ) ? 4'b1111 : 4'b0000;

        // memory enable logic
        assign enable_o = ( lsu_opcode_i === `LSU_OPCODE_NONE ) ? 1'b0 : 1'b1;

        wire load_store_n;
        assign load_store_n =   ( lsu_opcode_i === `LSU_OPCODE_NONE ) ? 1'bz : 
                                ( lsu_opcode_i === `LSU_OPCODE_SB ||
                                  lsu_opcode_i === `LSU_OPCODE_SH ||
                                  lsu_opcode_i === `LSU_OPCODE_SW  )  ? 1'b0 : 1'b1;

        always @ * begin
                if (load_store_n == 1'b0) // store operation
                        val_memwr_o = {{`API_DATA_WIDTH{1'b0}}};
                case (lsu_opcode_i)
                        // Load word, halfword, byte
                        `LSU_OPCODE_LB: val_memrd_o = (addr_mem_i[1:0] === 2'b00 ) ? {{`API_DATA_WIDTH-8{val_memrd_i[7]}},val_memrd_i[7:0]} :
                                                      (addr_mem_i[1:0] === 2'b01 ) ? {{`API_DATA_WIDTH-8{val_memrd_i[15]}},val_memrd_i[15:8]} :
                                                      (addr_mem_i[1:0] === 2'b10 ) ? {{`API_DATA_WIDTH-8{val_memrd_i[23]}},val_memrd_i[23:16]} :
                                                      {{`API_DATA_WIDTH-8{val_memrd_i[31]}},val_memrd_i[31:24]} ;

                        `LSU_OPCODE_LBU: val_memrd_o =  (addr_mem_i[1:0] === 2'b00 ) ? {{`API_DATA_WIDTH-8{1'b0}},val_memrd_i[7:0]} :
                                                        (addr_mem_i[1:0] === 2'b01 ) ? {{`API_DATA_WIDTH-8{1'b0}},val_memrd_i[15:8]} :
                                                        (addr_mem_i[1:0] === 2'b10 ) ? {{`API_DATA_WIDTH-8{1'b0}},val_memrd_i[23:16]} :
                                                        {{`API_DATA_WIDTH-8{1'b0}},val_memrd_i[31:24]} ;
                        
                        `LSU_OPCODE_LH: val_memrd_o = (addr_mem_i[1] === 1'b0 ) ? 
                                                        {{`API_DATA_WIDTH-16{val_memrd_i[15]}},val_memrd_i[15:0]} : 
                                                        {{`API_DATA_WIDTH-16{val_memrd_i[31]}},val_memrd_i[31:16]};

                        `LSU_OPCODE_LHU: val_memrd_o = (addr_mem_i[1] === 1'b0 ) ? 
                                                        {{`API_DATA_WIDTH-16{1'b0}},val_memrd_i[15:0]} : 
                                                        {{`API_DATA_WIDTH-16{1'b0}},val_memrd_i[31:16]};

                        `LSU_OPCODE_LW: val_memrd_o = val_memrd_i;

                        //store word, halfword, byte
                        `LSU_OPCODE_SB: case(addr_mem_i[1:0])
                                                2'b00: val_memwr_o[7:0]   = val_memwr_i[7:0];
                                                2'b01: val_memwr_o[15:8]  = val_memwr_i[7:0];
                                                2'b10: val_memwr_o[23:16] = val_memwr_i[7:0];
                                                2'b11: val_memwr_o[31:24] = val_memwr_i[7:0];
                                        endcase
                        `LSU_OPCODE_SH: case(addr_mem_i[1])
                                                1'b0: val_memwr_o[15:0] = val_memwr_i[15:0];
                                                1'b1: val_memwr_o[31:16] = val_memwr_i[15:0];
                                        endcase
                        `LSU_OPCODE_SW: val_memwr_o = val_memwr_i;
                        default: begin
                                val_memrd_o = {{`API_DATA_WIDTH{1'bz}}};
                                val_memwr_o = {{`API_DATA_WIDTH{1'bz}}};
                        end
                endcase
        end
endmodule
