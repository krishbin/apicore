`timescale 1ns/1ps
`include "../core/lsu.v"
`include "../core/mem_RAM.v"

module tb_lsu_ram();

    

    rv32im_lsu a1(
        .val_memrd_i(read_from_mem),
        .val_memwr_o(write_to_mem),

        .lsu_opcode_i(opcode),
        .addr_mem_i(addr),
        .val_memwr_i(exu_data_to_mem),
        .val_memrd_o(mem_data_to_exu),
        .addr_mem_o(addr_mem_o),

        .wr_mask_o(wr_mask),
        .enable_o(enable)
    );

    mem_RAM RAM(
        .clk(clk),
        .reset_n(reset_n),
        .en(en),
        .address_i(address_i),
        .data_in_i(data_in),
        .data_out_o(data_out),
        .wr_mask_i(wr_mask_i)
    );

endmodule