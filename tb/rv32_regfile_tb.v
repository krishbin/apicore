`timescale 1ns/1ps
`include "../core/rv32im_regfile.v"

module rv32_regfile_tb();

    reg clk, reset_n;
    reg [4:0] rs1_address, rs2_address, rd_address;
    reg [31:0] rd_value;

    reg we;
    wire [31:0] rs1_value, rs2_value;

    rv32im_regfile uut(
        .clk_i(clk),
        .rst_n_i(reset_n),
        .we_i(we),
        .rs1_addr_i(rs1_address),
        .rs2_addr_i(rs2_address),
        .rd_addr_i(rd_address),
        .val_rd_i(rd_value),
        .val_rs1_o(rs1_value),
        .val_rs2_o(rs2_value)
    );

    // 10ns clock cycle
    parameter PERIOD = 10;

    // clock setup
    always #5 clk = ~clk;
    
    integer i;
    initial begin
        clk = 1'b0;
        reset_n = 1'b1;
        rs1_address = 5'bz;
        rs2_address = 5'bz;
        rd_address = 5'bz;
        rd_value = 'bz;
        #PERIOD;

        // initial
        for (i=0;i<32;i=i+1) begin
            rs1_address = i;
            #PERIOD;
        end
        rs1_address = 5'bz;

        we = 1'b1;
        // write value
        for (i=0;i<32;i=i+1) begin
            rd_address = i;
            rd_value = (i+1) * 12;
            #PERIOD;
        end
        we = 1'b0;

        // after write
        for (i=0;i<32;i=i+1) begin
            rs1_address = i;
            #PERIOD;
        end

        // 
        we = 1'b1;
        rd_address = 5'd3;
        rd_value   = 32'd546;
        rs1_address = 5'd4;
        rs2_address = 5'd5;
        #PERIOD;

        // write to x0 test
        we = 1'b1;
        rd_address = 5'd0;
        rd_value   = 32'd654;
        #PERIOD;
        rs1_address = 5'd3;
        rs2_address = 5'd3;

        #(PERIOD*2);
        $finish;
    end

    // output file
    initial begin
        $dumpfile("../waveform/rv32_regfile_tb.vcd");
        $dumpvars();
    end

endmodule