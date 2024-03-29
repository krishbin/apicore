`include "../core/DEFINITIONS.v"

module mem_ROM(
    input clk, 
    input reset_n,
    input en,

    input [`API_ADDR_WIDTH-1:0] address_i,
    output reg [`API_ADDR_WIDTH-1:0] data_o
);

    reg [`API_DATA_WIDTH-1:0] simulated_ROM [0:2047]; // 8KB of ROM memory
    wire [`API_ADDR_WIDTH-1:0] address = {2'b00, address_i[31:2]};

    always @(posedge clk or negedge reset_n) begin
        if (~reset_n)
            $readmemh("../bin/program.mem", simulated_ROM);
        if (en) begin
                if ( |address_i[`API_DATA_WIDTH-1:13] )
                    $display("ROM memory out of bound.\n");
                else 
                    data_o <= simulated_ROM[address];    // address bits [1] and [0] used for byte selection in 32bit instn.
        end
    end

endmodule