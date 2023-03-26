`include "../core/DEFINITIONS.v"

module rv32im_br(
    //from execution unit
    input alu_zero_i,
    input br_en_i,
    input br_conditional_i,
    input [`API_ADDR_WIDTH-1:0] exu_calc_addr,
    input [`BR_OPCODE_WIDTH-1:0] br_opcode_i,
    input [`API_ADDR_WIDTH-1:0] curr_pc_i,

    input [`API_DATA_WIDTH-1:0] imm_i,
    output [`API_ADDR_WIDTH-1:0] br_pc_o,
    output [`API_ADDR_WIDTH-1:0] nxt_pc_o
);

reg [`API_ADDR_WIDTH-1:0] br_pc_o;
reg [`API_ADDR_WIDTH-1:0] offset;
wire [`API_ADDR_WIDTH-1:0] br_pc;

assign br_pc = curr_pc_i + offset;
assign nxt_pc_o = br_pc;

always @ * begin
    offset = {{`API_ADDR_WIDTH-3{1'b0}}, 3'b100};
    if( br_en_i ) begin
        if( br_conditional_i ) begin
            
            case (br_opcode_i)
                `BR_OPCODE_BEQ:  offset = ( alu_zero_i) ? imm_i : 32'h4;
                `BR_OPCODE_BNE:  offset = (!alu_zero_i) ? imm_i : 32'h4;
                `BR_OPCODE_BLT:  offset = (!alu_zero_i && exu_calc_addr[0] === 1'b1) ? imm_i : 32'h4;
                `BR_OPCODE_BGE:  offset = ( alu_zero_i || exu_calc_addr[0] === 1'b0) ? imm_i : 32'h4;
                `BR_OPCODE_BLTU: offset = (!alu_zero_i && exu_calc_addr[0] === 1'b1) ? imm_i : 32'h4;
                `BR_OPCODE_BGEU: offset = (!alu_zero_i || exu_calc_addr[0] === 1'b0) ? imm_i : 32'h4;
            endcase
            br_pc_o = br_pc;
        end
        else begin
            br_pc_o = exu_calc_addr;
        end
    end
    else begin
        br_pc_o = br_pc;
    end
end

endmodule