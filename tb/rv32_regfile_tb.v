`timescale 1ns/1ps
`include "../core/rv32_regfile.v"

module rv32_regfile_tb();

    reg clk, reset_n;
    reg [4:0] rs1_address, rs2_address, rd_address;
    reg [31:0] rd_value;

    wire [31:0] rs1_value, rs2_value;

    regfile uut(
        .clk(clk),
        .reset_n(reset_n),
        .rs1_address(rs1_address),
        .rs2_address(rs2_address),
        .rd_address(rd_address),
        .rd_value(rd_value),
        .rs1_value_o(rs1_value),
        .rs2_value_o(rs2_value)
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

        // // initial
        // for (i=0;i<32;i=i+1) begin
        //     rs1_address = i;
        //     #PERIOD;
        // end
        // rs1_address = 5'bz;

        // // write value
        // for (i=0;i<32;i=i+1) begin
        //     rd_address = i;
        //     rd_value = (i+1) * 12;
        //     #PERIOD;
        // end
        
        // // after write
        // for (i=0;i<32;i=i+1) begin
        //     rs1_address = i;
        //     #PERIOD;
        // end

        // 
        rd_address = 5'd4;
        rd_value   = 32'd546;
        rs1_address = 5'd4;
        rs2_address = 5'd4;
        #PERIOD;

        // write to x0 test
        rd_address = 5'd0;
        rd_value   = 32'd654;
        #PERIOD;
        rs1_address = 5'd0;
        rs2_address = 5'd0;

        #(PERIOD*2);
        $finish;
    end

    // output file
    initial begin
        $dumpfile("../waveforms/rv32_regfile_tb.vcd");
        $dumpvars();
    end

endmodule