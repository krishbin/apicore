module programCounter(
    input clk, 
    input reset_n, 
    input [31:0] alu_imm_pc_next,
    input [31:0] imm_offset,

    // control signals
    input pc_alu_sel,
    input pc_next_sel, 

    output [31:0] pc_alu,
    output [31:0] pc_value
);

    reg [31:0] pc_alu_reg, pc_value_reg;
    reg [31:0] offset;

    reg [31:0] dout;

    assign pc_alu = pc_alu_reg;
    assign pc_value = pc_value_reg;

    always @(posedge clk or negedge reset_n) 
    begin
        if (~reset_n)
            dout <= 32'b0;

        pc_value_reg <= dout;
    end

    always @(*) begin
        if (reset_n) begin
            // offset calculation
            if (pc_alu_sel)
                offset <= imm_offset;
            else
                offset <= 32'd4;
            
            // next address calculation
            pc_alu_reg <=  offset + pc_value_reg;

            if (~pc_next_sel)
                dout <= pc_alu_reg;
            else
                dout <= alu_imm_pc_next;
        end
    end



endmodule