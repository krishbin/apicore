`include "../core/csr_reg.v"
`include "../core/DEFINITIONS.v"

module rv32im_csr_reg_testbench();

reg clk,rst_n;
reg [`CSR_WIDTH-1:0] csr_addr;
reg [`API_XLEN-1:0] val_csr_to_write;
reg csr_read_en, csr_write_en;
wire [`API_XLEN-1:0] val_csr_to_read;
wire [`API_XLEN-1:0] csr_status;
wire [1:0] priviledge_mode;

rv32im_csr_regfile csr_reg(
    .clk_i(clk),
    .rst_n_i(rst_n),
    .csr_addr_i(csr_addr),
    .val_csr_i(val_csr_to_write),
    .csr_write_en_i(csr_write_en),
    .csr_read_en_i(csr_read_en),
    .val_csr_o(val_csr_to_read),
    .csr_status_o(csr_status),
    .priviledge_mode_o(priviledge_mode)
    );

    localparam cycle = 10;

    always #(cycle/2) clk = ~clk;

initial begin

    $dumpfile("csr_reg.vcd");
    $dumpvars();
    $monitor("clk=%h, rst_n=%h, csr_addr=%h, val_csr_to_write=%h, csr_write_en=%h, val_csr_to_read=%h, csr_read_en=%h, csr_status=%h, priviledge_mode=%h", clk, rst_n, csr_addr, val_csr_to_write, csr_write_en, val_csr_to_read, csr_read_en, csr_status, priviledge_mode);
    // Initialize Inputs
    clk = 0;
    // invert clock every 5ns

    rst_n = 0;
    #10
    rst_n = 1;

    csr_addr=`CSR_MSTATUS; csr_write_en=0; val_csr_to_write=32'h00000000; csr_read_en=1; #cycle;
    csr_addr=`CSR_MCYCLE; csr_write_en=0; val_csr_to_write=32'h00000000; csr_read_en=1; #cycle;

    csr_addr=`CSR_MSTATUS; csr_write_en=1; val_csr_to_write=32'hF0000000; #cycle;

    csr_addr=`CSR_MSTATUS; csr_write_en=0; val_csr_to_write=32'h00000000; csr_read_en=1; #cycle;

    csr_addr=`CSR_MSTATUS; csr_write_en=1; val_csr_to_write=32'h0F000000; csr_read_en=1; #cycle;

    csr_addr=`CSR_MCYCLE; csr_write_en=0; val_csr_to_write=32'h0F000000; csr_read_en=1; #cycle;
    csr_addr=`CSR_MCYCLE; csr_write_en=0; val_csr_to_write=32'h0F000000; csr_read_en=1; #cycle;
    csr_addr=`CSR_MCYCLE; csr_write_en=0; val_csr_to_write=32'h0F000000; csr_read_en=1; #cycle;
    csr_addr=`CSR_MCYCLE; csr_write_en=0; val_csr_to_write=32'h0F000000; csr_read_en=1; #cycle;
    csr_addr=`CSR_MCYCLE; csr_write_en=0; val_csr_to_write=32'h0F000000; csr_read_en=1; #cycle;
    $finish;
end

endmodule