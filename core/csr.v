`include "DEFINITIONS.v"
`include "csr_reg.v"

module rv32im_csr(
    input clk_i,
    input rst_n_i,
    // address of csr
    input [`CSR_WIDTH-1:0] csr_addr_i,
    // get input for csr
    input [`API_XLEN-1:0] val_csr_i,
    input we_csr_i,
    input re_csr_i,

    input [`CSR_OPCODE_WIDTH-1:0] csr_opcode_i,
    // output of csr
    output reg [`API_XLEN-1:0] val_csr_o
);

    // output to csr regfile
    reg [`CSR_XLEN-1:0] csr_o;
    // write enable to csr regfile
    reg we_csr_o;
    // input from csr regfile
    wire [`CSR_XLEN-1:0] csr_i;
    // read enable to csr regfile
    reg re_csr_o;
    wire [`CSR_XLEN-1:0] csr_status;
    wire [1:0] machine_priviledge_mode;

    rv32im_csr_regfile csr_regfile(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .csr_addr_i(csr_addr_i),
        .val_csr_i(csr_o),
        .csr_write_en_i(we_csr_o),
        .val_csr_o(csr_i),
        .csr_read_en_i(re_csr_o),
        .csr_status_o(csr_status),
        .priviledge_mode_o(machine_priviledge_mode)
    );

    always @(posedge clk_i , negedge rst_n_i) begin
        if (~rst_n_i) begin
            we_csr_o    <= 1'b0;
            re_csr_o    <= 1'b1;
            csr_o       <= {`CSR_XLEN{1'b0}};
            val_csr_o   <= {`CSR_XLEN{1'b0}};
        end
        else begin
            we_csr_o    <= we_csr_i;
            re_csr_o    <= re_csr_i;
            case (csr_opcode_i)
                `CSR_OPCODE_CSRRW: begin
                    csr_o       <= val_csr_i;
                    val_csr_o   <= csr_i;
                end
                `CSR_OPCODE_CSRRS: begin
                    csr_o       <= csr_i | val_csr_i;
                    val_csr_o   <= csr_i;
                end
                `CSR_OPCODE_CSRRC: begin
                    csr_o       <= csr_i & ~val_csr_i;
                    val_csr_o   <= csr_i;
                end
                `CSR_OPCODE_CSRRWI: begin
                    csr_o       <= val_csr_i;
                    val_csr_o   <= csr_i;
                end
                `CSR_OPCODE_CSRRSI: begin
                    csr_o       <= csr_i | val_csr_i;
                    val_csr_o   <= csr_i;
                end
                `CSR_OPCODE_CSRRCI: begin
                    csr_o       <= csr_i & ~val_csr_i;
                    val_csr_o   <= csr_i;
                end
                default: begin
                    csr_o       <= {`CSR_XLEN{1'b0}};
                    we_csr_o    <= 1'b0;
                    re_csr_o    <= 1'b0;
                    val_csr_o   <= {`CSR_XLEN{1'b0}};
                end
            endcase
        end
    end


endmodule