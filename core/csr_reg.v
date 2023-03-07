`include "DEFINITIONS.v"

module rv32im_csr_regfile(
    input clk_i,
    input rst_n_i,
    // external interrupts
    // input ext_intr_i,
    //timer interrrupts
    // input timer_intr_i,
    input [`CSR_WIDTH-1:0] csr_addr_i,
    //csr write port
    input csr_write_en_i,
    input [`API_XLEN-1:0] val_csr_i,
    //csr read port
    input csr_read_en_i,
    output reg [`API_XLEN-1:0] val_csr_o,
    // interrupt branching
    // output reg csr_br_o,
    // output reg [`API_XLEN-1:0] csr_trgt_o,
    // csr registers
    output [1:0] priviledge_mode_o,
    output [`API_XLEN-1:0] csr_status_o
    // csr interrupt output
    // output [`API_XLEN:0] csr_intr_o
);
    // current
    reg [`API_XLEN-1:0] csr_mstatus; // machine status register
    reg [`API_XLEN-1:0] csr_medeleg; // machine exception delegation
    reg [`API_XLEN-1:0] csr_mideleg; // machine interrupt delegation
    reg [`API_XLEN-1:0] csr_mie; // machine interrupt enable
    reg [`API_XLEN-1:0] csr_mtvec; // machine trap handler base address
    reg [`API_XLEN-1:0] csr_mscratch; // machine scratch register
    reg [`API_XLEN-1:0] csr_mepc; // machine exception program counter
    reg [`API_XLEN-1:0] csr_mcause; // machine trap cause
    reg [`API_XLEN-1:0] csr_mtval; // machine bad address or instruction
    reg [`API_XLEN-1:0] csr_mip; // machine interrupt pending
    reg [`API_XLEN-1:0] csr_mpriv; // machine privilege
    reg [`API_XLEN-1:0] csr_mcycle; // machine cycle counter
    reg [`API_XLEN-1:0] csr_mcycle_h; // machine cycle upper counter
    reg csr_mtime_ie; // machine timer interrupt enable
    reg [`API_XLEN-1:0] csr_mtimecmp; // machine timer compare

    // next
    reg [`API_XLEN-1:0] csr_mstatus_n; // machine status register
    reg [`API_XLEN-1:0] csr_medeleg_n; // machine exception delegation
    reg [`API_XLEN-1:0] csr_mideleg_n; // machine interrupt delegation
    reg [`API_XLEN-1:0] csr_mie_n; // machine interrupt enable
    reg [`API_XLEN-1:0] csr_mtvec_n; // machine trap handler base address
    reg [`API_XLEN-1:0] csr_mscratch_n; // machine scratch register
    reg [`API_XLEN-1:0] csr_mepc_n; // machine exception program counter
    reg [`API_XLEN-1:0] csr_mcause_n; // machine trap cause
    reg [`API_XLEN-1:0] csr_mtval_n; // machine bad address or instruction
    reg [`API_XLEN-1:0] csr_mip_n; // machine interrupt pending
    reg [`API_XLEN-1:0] csr_mpriv_n; // machine privilege
    reg [`API_XLEN-1:0] csr_mcycle_n; // machine cycle counter
    reg [`API_XLEN-1:0] csr_mcycle_h_n; // machine cycle upper counter
    reg csr_mtime_ie_n; // machine timer interrupt enable
    reg [`API_XLEN-1:0] csr_mtimecmp_n; // machine timer compare

    // csr machine info registers, always the same
    reg [`API_XLEN-1:0] csr_mvendorid;
    reg [`API_XLEN-1:0] csr_marchid;
    reg [`API_XLEN-1:0] csr_mimpid;
    reg [`API_XLEN-1:0] csr_mhartid;
    
    // masked interrupts
    reg [`API_XLEN-1:0] irq_pending;
    reg [`API_XLEN-1:0] irq_masked;
    reg [1:0] priviledge_mode;

    reg m_enabled;
    reg [`API_XLEN-1:0] m_interrupts;
    reg s_enabled_r;
    reg [`API_XLEN-1:0] s_interrupts;

    wire csr_read_enable,csr_write_enable;

    always @ * begin
        irq_pending = csr_mip & csr_mie;
        irq_masked = irq_pending & ~csr_mstatus[3:0];
        priviledge_mode = `PRIVILEDGE_MODE_M;
    end 

    reg [1:0] irq_priviledge_mode;
    always @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            irq_priviledge_mode = `PRIVILEDGE_MODE_M;
        end else begin
            irq_priviledge_mode = 1'b0;
        end
    end

//    assign csr_intr_o = irq_masked;
    assign csr_read_enable = csr_read_en_i;
    assign csr_write_enable = csr_write_en_i;

    reg csr_mip_upd;

    always @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            csr_mip_upd <= 1'b0;
        end 
//        else if ((csr_read_en_i && csr_addr_r_i == `CSR_MIP) || (csr_read_en_i && csr_addr_r_i == `CSR_SIP)) begin
//            csr_mip_upd_q <= 1'b1;
//        end
    end

    // read csr registers
    always @* begin
        if (csr_read_enable) begin
            case(csr_addr_i)
                `CSR_MSTATUS:       val_csr_o   =   csr_mstatus;
                `CSR_MEDELEG:       val_csr_o   =   csr_medeleg;
                `CSR_MIDELEG:       val_csr_o   =   csr_mideleg;
                `CSR_MIE:           val_csr_o   =   csr_mie;
                `CSR_MTVEC:         val_csr_o   =   csr_mtvec;
                `CSR_MSCRATCH:      val_csr_o   =   csr_mscratch;
                `CSR_MEPC:          val_csr_o   =   csr_mepc;
                `CSR_MCAUSE:        val_csr_o   =   csr_mcause;
                `CSR_MTVAL:         val_csr_o   =   csr_mtval;
                `CSR_MIP:           val_csr_o   =   csr_mip;
                `CSR_MPRIV:         val_csr_o   =   csr_mpriv;
                `CSR_MCYCLE:        val_csr_o   =   csr_mcycle;
                `CSR_MCYCLE_H:      val_csr_o   =   csr_mcycle_h;
                `CSR_MEPC:          val_csr_o   =   csr_mepc;
                `CSR_MVENDORID:     val_csr_o   =   csr_mvendorid;
                `CSR_MARCHID:       val_csr_o   =   csr_marchid;
                `CSR_MIMPID:        val_csr_o   =   csr_mimpid;
                `CSR_MHARTID:       val_csr_o   =   csr_mhartid;
                default:            val_csr_o   =   32'h0;
            endcase
        end
    end

    // initialize next as current
    always @* begin
        csr_mstatus_n           <=      csr_mstatus;
        csr_medeleg_n           <=      csr_medeleg;
        csr_mideleg_n           <=      csr_mideleg;
        csr_mie_n               <=      csr_mie;
        csr_mtvec_n             <=      csr_mtvec;
        csr_mscratch_n          <=      csr_mscratch;
        csr_mepc_n              <=      csr_mepc;
        csr_mcause_n            <=      csr_mcause;
        csr_mtval_n             <=      csr_mtval;
        csr_mip_n               <=      csr_mip;
        csr_mpriv_n             <=      csr_mpriv;
        csr_mcycle_n            <=      csr_mcycle + 32'h1;
        csr_mcycle_h_n          <=      csr_mcycle_h;
    end

    // write csr registers
    always @(posedge clk_i) begin
        if (csr_write_enable) begin
            case(csr_addr_i)
                    `CSR_MSTATUS:       csr_mstatus_n     = val_csr_i & `CSR_MSTATUS_MASK;
                    `CSR_MEDELEG:       csr_medeleg_n     = val_csr_i & `CSR_MEDELEG_MASK;
                    `CSR_MIDELEG:       csr_mideleg_n     = val_csr_i & `CSR_MIDELEG_MASK;
                    `CSR_MIE:           csr_mie_n         = val_csr_i & `CSR_MIE_MASK;
                    `CSR_MTVEC:         csr_mtvec_n       = val_csr_i & `CSR_MTVEC_MASK;
                    `CSR_MSCRATCH:      csr_mscratch_n    = val_csr_i & `CSR_MSCRATCH_MASK;
                    `CSR_MEPC:          csr_mepc_n        = val_csr_i & `CSR_MEPC_MASK;
                    `CSR_MCAUSE:        csr_mcause_n      = val_csr_i & `CSR_MCAUSE_MASK;
                    `CSR_MTVAL:         csr_mtval_n       = val_csr_i & `CSR_MTVAL_MASK;
                    `CSR_MIP:           csr_mip_n         = val_csr_i & `CSR_MIP_MASK;
                    `CSR_MPRIV:         csr_mpriv_n       = val_csr_i & `CSR_MPRIV_MASK;
            endcase
        end
    end

    always @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            csr_mstatus         <=      `CSR_MSTATUS_RESET;
            csr_medeleg         <=      `CSR_MEDELEG_RESET;
            csr_mideleg         <=      `CSR_MIDELEG_RESET;
            csr_mie             <=      `CSR_MIE_RESET;
            csr_mtvec           <=      `CSR_MTVEC_RESET;
            csr_mscratch        <=      `CSR_MSCRATCH_RESET;
            csr_mepc            <=      `CSR_MEPC_RESET;
            csr_mcause          <=      `CSR_MCAUSE_RESET;
            csr_mtval           <=      `CSR_MTVAL_RESET;
            csr_mip             <=      `CSR_MIP_RESET;
            csr_mpriv           <=      `CSR_MPRIV_RESET;
            csr_mcycle          <=      `CSR_MCYCLE_RESET;
            csr_mcycle_h        <=      `CSR_MCYCLE_H_RESET;
        end else begin
            csr_mstatus         <=      csr_mstatus_n;
            csr_medeleg         <=      csr_medeleg_n;
            csr_mideleg         <=      csr_mideleg_n;
            csr_mie             <=      csr_mie_n;
            csr_mtvec           <=      csr_mtvec_n;
            csr_mscratch        <=      csr_mscratch_n;
            csr_mepc            <=      csr_mepc_n;
            csr_mcause          <=      csr_mcause_n;
            csr_mtval           <=      csr_mtval_n;
            csr_mip             <=      csr_mip_n;
            csr_mpriv           <=      csr_mpriv_n;
            csr_mcycle          <=      csr_mcycle_n;
            csr_mcycle_h        <=      csr_mcycle_h_n;
            if (csr_mcycle == 32'hffffffff)
                csr_mcycle_h <= csr_mcycle_h + 32'h1;
        end
    end

    assign csr_status_o = csr_mstatus;


endmodule