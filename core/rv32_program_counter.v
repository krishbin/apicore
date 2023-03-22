`include "../core/DEFINITIONS.v"

module rv32im_pc(
    input clk, 
    input reset_n, 
    input [`API_PC_WIDTH-1:0] pc_next_i,

    output [`API_PC_WIDTH-1:0] pc
);

    reg [31:0] pc_reg, pc_next;

    assign pc = pc_reg;

    always @(*) 
    begin
        if (~reset_n) begin
            pc_next <= `API_RESET_PC;
        end
        else begin
            pc_next <= pc_next_i;
        end
    end

    always @(negedge clk,  negedge reset_n)
    begin
        if (~reset_n) begin
            pc_reg <= `API_RESET_PC;
        end
        else begin
            pc_reg <= pc_next;
        end
    end

endmodule