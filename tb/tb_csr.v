`include "../core/rv32im_csr.v"
`include "../core/DEFINITIONS.v"

module rv32im_csr_testbench();

reg clk,rst_n;
reg [`CSR_WIDTH-1:0] csr_addr;
reg [`API_XLEN-1:0] val_csr_to_write;
reg csr_read_en, csr_write_en;
reg [`CSR_OPCODE_WIDTH-1:0] csr_opcode;
wire [`API_XLEN-1:0] val_csr_to_read;
wire [`API_XLEN-1:0] csr_status;
wire [1:0] priviledge_mode;

rv32im_csr csr_reg(
    .clk_i(clk),
    .rst_n_i(rst_n),
    .csr_addr_i(csr_addr),
    .val_csr_i(val_csr_to_write),
    .we_csr_i(csr_write_en),
    .re_csr_i(csr_read_en),
    .val_csr_o(val_csr_to_read),
    .csr_opcode_i(csr_opcode)
    );

    localparam cycle = 10;

    always #(cycle/2) clk = ~clk;

    always @(negedge clk) begin
        if ( csr_opcode === `CSR_OPCODE_CSRRW || csr_opcode === `CSR_OPCODE_CSRRW) begin
            csr_write_en = 1'b1;
            csr_read_en = 1'b1;
        end
        else begin
            csr_write_en = 1'b0;
            csr_read_en = 1'b1;
        end
    end

initial begin

    $dumpfile("../waveform/csr.vcd");
    $dumpvars();
    // $monitor("clk=%h, rst_n=%h, csr_opcode=%h, csr_addr=%h, val_csr_to_write=%h, csr_write_en=%h, val_csr_to_read=%h, csr_read_en=%h", clk, rst_n, csr_opcode, csr_addr, val_csr_to_write, csr_write_en, val_csr_to_read, csr_read_en);
    // Initialize Inputs
    clk = 0;
    rst_n = 0;
    #cycle;
    rst_n = 1;
    
    csr_opcode=`CSR_OPCODE_CSRRW; csr_addr=`CSR_MCYCLE; val_csr_to_write=32'h00000000; #cycle;
    csr_opcode=`CSR_OPCODE_CSRRW; csr_addr=`CSR_MCYCLE; val_csr_to_write=32'h00000000; #cycle;
    csr_opcode=`CSR_OPCODE_CSRRW; csr_addr=`CSR_MSTATUS; val_csr_to_write=32'hF0000000; #cycle;
    csr_opcode=`CSR_OPCODE_CSRRW; csr_addr=`CSR_MSTATUS; val_csr_to_write=32'h00000000; #cycle;
    csr_opcode=`CSR_OPCODE_CSRRW; csr_addr=`CSR_MSTATUS; val_csr_to_write=32'h0F000000; #cycle;
    csr_opcode=`CSR_OPCODE_CSRRW; csr_addr=`CSR_MCYCLE; val_csr_to_write=32'h0F000000; #cycle;
    csr_opcode=`CSR_OPCODE_CSRRW; csr_addr=`CSR_MCYCLE; val_csr_to_write=32'h0F000000; #cycle;
    csr_opcode=`CSR_OPCODE_CSRRW; csr_addr=`CSR_MCYCLE; val_csr_to_write=32'h0F000000; #cycle;
    csr_opcode=`CSR_OPCODE_CSRRW; csr_addr=`CSR_MCYCLE; val_csr_to_write=32'h0F000000; #cycle;
    csr_opcode=`CSR_OPCODE_CSRRW; csr_addr=`CSR_MCYCLE; val_csr_to_write=32'h0F000000; #cycle;
    $finish;
end

endmodule