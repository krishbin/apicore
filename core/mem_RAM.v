`include "../core/DEFINITIONS.v"

module mem_RAM (
    input clk, 
    input reset_n, 
    input en,           // chip select, active high
    
    input [`API_ADDR_WIDTH-1:0] address_i,
    input [`API_DATA_WIDTH-1:0] data_in_i,
    output reg [`API_DATA_WIDTH-1:0] data_out_o,
    input [3:0] wr_mask_i
);

    reg [`API_DATA_WIDTH-1:0] simulated_RAM [0:255]; // 16384 addresses of 32 bits = 64kb
    wire [`API_ADDR_WIDTH-1:0] address = {2'b0, address_i[31:2]};

    integer i, file;
    always @(posedge clk, negedge clk, negedge reset_n) begin
        if (~reset_n) begin
            for (i=0;i<255;i=i+1)
                simulated_RAM[i] = 32'b0;
        end

        if (en) begin
            if (~|wr_mask_i)    // none of the wr mask is high implies read operation
                data_out_o = simulated_RAM[address];
            else begin
                if (wr_mask_i[0]) 
                    simulated_RAM[address][7:0] = data_in_i[7:0];
                if (wr_mask_i[1]) 
                    simulated_RAM[address][15:8] = data_in_i[15:8];
                if (wr_mask_i[2]) 
                    simulated_RAM[address][23:16] = data_in_i[23:16];
                if (wr_mask_i[3]) 
                    simulated_RAM[address][31:24] = data_in_i[31:24];
                // view RAM content
                // file = $fopen("../bin/RAM.mem","a");
                // $fdisplay(file,"###########");
                // for(i=0;i<5;i++) begin
                //     $fdisplay(file, "%h",simulated_RAM[i]);
                // end
                // $fclose(file);
            end 
        end
    end
    
endmodule