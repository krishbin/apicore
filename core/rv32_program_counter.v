`include "../core/DEFINITIONS.v"

module rv32im_pc(
    input clk, 
    input reset_n, 
    input [`API_PC_WIDTH-1:0] pc_next_i,

    output reg [`API_PC_WIDTH-1:0] pc
);
    always @(posedge clk or negedge reset_n) 
    begin
        if (~reset_n) begin
            pc <= `API_RESET_PC;
        end
        else begin
            pc <= pc_next_i;
        end
    end
endmodule