// APICORE : RV32I 
// Date    : 2023-01-23

module regfile(
    input clk, 
    input reset_n,
    input [4:0] rs1_address, 
    input [4:0] rs2_address, 
    input [4:0] rd_address,
    input [31:0] rd_value,
    output reg [31:0] rs1_value_o,
    output reg [31:0] rs2_value_o
);

    // to hold previous register value before rd_value modifies any register
    reg [31:0] rs1_value_reg, rs2_value_reg;

    // continuous memory implementation for register file: 32 unique locations of 32-bit each
    reg [31:0] registerArray [0:31];

    integer i;
    always @(posedge clk or negedge reset_n) begin
        if ( ~reset_n ) begin
            for (i=0;i<32;i=i+1) 
                registerArray[i] <= 'b0;
        end
        else begin
            if (rd_address !== 5'b0)
                registerArray[rd_address] = rd_value;
            rs1_value_o <= rs1_value_reg;
            rs2_value_o <= rs2_value_reg;
        end
    end

    always @(*) begin
        if ( ~reset_n ) begin
            rs1_value_reg = 'bz;
            rs2_value_reg = 'bz;
        end
        else begin
            rs1_value_reg = (rs1_address !== 5'bz) ? registerArray[rs1_address] : 'bz;
            rs2_value_reg = (rs2_address !== 5'bz) ? registerArray[rs2_address] : 'bz;
        end
    end

    initial begin
        for (i=0;i<32;i=i+1) 
            registerArray[i] <= 'b0;
        rs1_value_o = 'bz;
        rs2_value_o = 'bz;
    end


endmodule