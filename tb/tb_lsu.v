`include "../core/lsu.v"

module rv32im_lsu_testbench();

reg [`API_DATA_WIDTH-1:0] read_from_mem, exu_data_to_mem;
reg [`API_DATA_WIDTH-1:0] addr;
wire [`API_DATA_WIDTH-1:0] write_to_mem, mem_data_to_exu, addr_mem_o;
reg [`LSU_OPCODE_WIDTH-1:0] opcode;

rv32im_lsu a1(
    .val_memrd_i(read_from_mem),
    .val_memwr_o(write_to_mem),

    .lsu_opcode_i(opcode),
    .addr_mem_i(addr),
    .val_memwr_i(exu_data_to_mem),
    .val_memrd_o(mem_data_to_exu),
    .addr_mem_o(addr_mem_o)
    );

initial begin
    $dumpfile("../waveform/lsu.vcd");
    $dumpvars();
    $monitor("lsu_opcode=%b, read_from_mem=%b, write_to_mem=%b, exu_data_to_mem=%b, mem_data_to_exu=%b, addr=%b, addr_mem_o=%d \n", opcode, read_from_mem, write_to_mem, exu_data_to_mem, mem_data_to_exu, addr, addr_mem_o);
    opcode=`LSU_OPCODE_LW; addr=32'd0; exu_data_to_mem=32'd0; read_from_mem=32'd849341;
    #10
    opcode=`LSU_OPCODE_LB; addr=32'd0; exu_data_to_mem=32'd0; read_from_mem=32'd849341;
    #10
    opcode=`LSU_OPCODE_LH; addr=32'd0; exu_data_to_mem=32'd0; read_from_mem=32'd849341;
    #10
    $finish;
end

endmodule