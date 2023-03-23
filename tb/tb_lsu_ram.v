`timescale 1ns/1ps
`include "../core/rv32im_lsu.v"
`include "../core/mem_RAM.v"

module tb_lsu_ram();

    reg clk, reset_n;

    reg  [31:0] exu2lsu_din;
    reg  [31:0] exu2lsu_addr;
    reg [7:0] lsu_opcode;

    wire [31:0] mem2lsu_dout;
    wire [31:0] lsu2exu_dout;
    wire [31:0] lsu2mem_addr;
    wire [31:0] lsu2mem_din;
    wire [3:0] wr_mask;
    wire enable;

    rv32im_lsu a1(
        
        .val_memwr_i(exu2lsu_din),
        .val_memrd_o(lsu2exu_dout),
        .lsu_opcode_i(lsu_opcode),
        .addr_mem_i(exu2lsu_addr),
        .addr_mem_o(lsu2mem_addr),
        .val_memrd_i(mem2lsu_dout),
        .val_memwr_o(lsu2mem_din),
        .wr_mask_o(wr_mask),
        .enable_o(enable)
    );

    mem_RAM RAM(
        .clk(clk),
        .reset_n(reset_n),
        .en(enable),
        .address_i(lsu2mem_addr),
        .data_in_i(lsu2mem_din),
        .data_out_o(mem2lsu_dout),
        .wr_mask_i(wr_mask)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("../waveform/int_lsu_ram.vcd");
        $dumpvars();

        reset_n = 1'b0;
        clk = 1'b0;
        #10;
        reset_n = 1'b1;

        // initial write to memory
        lsu_opcode=`LSU_OPCODE_SW;      exu2lsu_addr=32'd0;      exu2lsu_din=32'habcdef89;           #10;
        lsu_opcode=`LSU_OPCODE_SW;      exu2lsu_addr=32'd4;      exu2lsu_din=32'ha1c2e394;           #10;
        lsu_opcode=`LSU_OPCODE_SW;      exu2lsu_addr=32'd8;      exu2lsu_din=32'habcdef89;           #10;
        lsu_opcode=`LSU_OPCODE_SW;      exu2lsu_addr=32'd12;     exu2lsu_din=32'ha1c2e394;           #10;
        lsu_opcode=`LSU_OPCODE_SW;      exu2lsu_addr=32'd16;     exu2lsu_din=32'habcdef89;           #10;
        lsu_opcode=`LSU_OPCODE_SW;      exu2lsu_addr=32'd20;     exu2lsu_din=32'ha1c2e394;           #10;
        lsu_opcode=`LSU_OPCODE_SW;      exu2lsu_addr=32'd24;     exu2lsu_din=32'habcdef89;           #10;
        lsu_opcode=`LSU_OPCODE_SW;      exu2lsu_addr=32'd28;     exu2lsu_din=32'ha1c2e394;           #10;
        lsu_opcode=`LSU_OPCODE_SW;      exu2lsu_addr=32'd32;     exu2lsu_din=32'habcdef89;           #10;
        lsu_opcode=`LSU_OPCODE_SW;      exu2lsu_addr=32'd36;     exu2lsu_din=32'ha1c2e394;           #10;
        lsu_opcode=`LSU_OPCODE_SW;      exu2lsu_addr=32'd40;     exu2lsu_din=32'habcdef89;           #10;

        // check values
        lsu_opcode=`LSU_OPCODE_LW;      exu2lsu_addr=32'd0;     #10;
        lsu_opcode=`LSU_OPCODE_LW;      exu2lsu_addr=32'd4;     #10;
        lsu_opcode=`LSU_OPCODE_LW;      exu2lsu_addr=32'd8;     #10;
        lsu_opcode=`LSU_OPCODE_LW;      exu2lsu_addr=32'd12;    #10;
        lsu_opcode=`LSU_OPCODE_LW;      exu2lsu_addr=32'd16;    #10;
        lsu_opcode=`LSU_OPCODE_LW;      exu2lsu_addr=32'd20;    #10;
        lsu_opcode=`LSU_OPCODE_LW;      exu2lsu_addr=32'd24;    #10;
        lsu_opcode=`LSU_OPCODE_LW;      exu2lsu_addr=32'd28;    #10;
        lsu_opcode=`LSU_OPCODE_LW;      exu2lsu_addr=32'd32;    #10;
        lsu_opcode=`LSU_OPCODE_LW;      exu2lsu_addr=32'd36;    #10;
        lsu_opcode=`LSU_OPCODE_LW;      exu2lsu_addr=32'd40;    #10;

        //lbu
        lsu_opcode=`LSU_OPCODE_LBU;     exu2lsu_addr=32'd4;     #10;
        lsu_opcode=`LSU_OPCODE_LBU;     exu2lsu_addr=32'd5;     #10;
        lsu_opcode=`LSU_OPCODE_LBU;     exu2lsu_addr=32'd6;     #10;
        lsu_opcode=`LSU_OPCODE_LBU;     exu2lsu_addr=32'd7;     #10;
        // lb   
        lsu_opcode=`LSU_OPCODE_LB;      exu2lsu_addr=32'd4;     #10;
        lsu_opcode=`LSU_OPCODE_LB;      exu2lsu_addr=32'd5;     #10;
        lsu_opcode=`LSU_OPCODE_LB;      exu2lsu_addr=32'd6;     #10;
        lsu_opcode=`LSU_OPCODE_LB;      exu2lsu_addr=32'd7;     #10;
        // lhu  
        lsu_opcode=`LSU_OPCODE_LHU;     exu2lsu_addr=32'd4;     #10;
        lsu_opcode=`LSU_OPCODE_LHU;     exu2lsu_addr=32'd6;     #10;
        // lh   
        lsu_opcode=`LSU_OPCODE_LH;      exu2lsu_addr=32'd4;     #10;
        lsu_opcode=`LSU_OPCODE_LH;      exu2lsu_addr=32'd6;     #10;
        // lw   
        lsu_opcode=`LSU_OPCODE_LW;      exu2lsu_addr=32'd4;     #10;
        // none
        lsu_opcode=`LSU_OPCODE_NONE; #10;   

        // sb
        lsu_opcode=`LSU_OPCODE_SB;      exu2lsu_addr=32'd4;     exu2lsu_din=32'h8439341;           #10;
        lsu_opcode=`LSU_OPCODE_SB;      exu2lsu_addr=32'd5;     exu2lsu_din=32'h8439341;           #10;
        lsu_opcode=`LSU_OPCODE_SB;      exu2lsu_addr=32'd6;     exu2lsu_din=32'h8439341;           #10;
        lsu_opcode=`LSU_OPCODE_SB;      exu2lsu_addr=32'd7;     exu2lsu_din=32'h8439341;           #10;
        // sh          
        lsu_opcode=`LSU_OPCODE_SH;      exu2lsu_addr=32'd4;     exu2lsu_din=32'h8439341;           #10;
        lsu_opcode=`LSU_OPCODE_SH;      exu2lsu_addr=32'd6;     exu2lsu_din=32'h8439341;           #10;
        // sw          
        lsu_opcode=`LSU_OPCODE_SW;      exu2lsu_addr=32'd7;     exu2lsu_din=32'h8439341;           #10;
        lsu_opcode=`LSU_OPCODE_NONE; #10;

        $finish;
    end

endmodule