// APICORE : RV32I 
// Date    : 2023-01-23
`include "../core/DEFINITIONS.v"

module rv32im_regfile(
    input clk_i, 
    input rst_n_i,
    input we_i,
    input [`API_REGISTER_ADDR_WIDTH-1:0] rs1_addr_i, 
    input [`API_REGISTER_ADDR_WIDTH-1:0] rs2_addr_i, 
    input [`API_REGISTER_ADDR_WIDTH-1:0] rd_addr_i,
    input [`API_REGISTER_WIDTH-1:0] val_rd_i,
    output [`API_REGISTER_WIDTH-1:0] val_rs1_o,
    output [`API_REGISTER_WIDTH-1:0] val_rs2_o
);

    // continuous memory implementation for register file: 32 unique locations of 32-bit each
    reg [`API_REGISTER_WIDTH-1:0] registerArray [0:`API_REGISTER_COUNT-1];
    integer i;
    always @(posedge clk_i or negedge rst_n_i) begin
        
        if ( ~rst_n_i ) begin
            for (i=0;i<`API_REGISTER_COUNT;i=i+1)
                registerArray[i] <= 'b0;
        end
        else begin
            if ( (rd_addr_i !== 5'b0) && we_i )
                registerArray[rd_addr_i] <= val_rd_i;
        end
    end

    assign val_rs1_o = (rs1_addr_i === 5'b0) ? { `API_REGISTER_WIDTH{1'b0} } : registerArray[rs1_addr_i];
    assign val_rs2_o = (rs2_addr_i === 5'b0) ? { `API_REGISTER_WIDTH{1'b0} } : registerArray[rs2_addr_i];

endmodule