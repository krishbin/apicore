`include "DEFINITIONS.v"
`include "memifdef.v"


module rv32im_lsu (
        input rst,
        input clk,

        // LSU <-> EXU interface
        input exu2lsu_req_i,                    // request from EXU
        input [LSU_OPCODE_SIZE-1:0] exu2lsu_cmd_i,               // operation
        input [API_ADDR_WIDTH-1:0] exu2lsu_addr_i,            // address
        input [API_DATA_WIDTH-1:0] exu2lsu_sdata_i,           // store data
        output lsu2exu_ready_o,                 // lsu reaceived DMEM response
        output [API_DATA_WIDTH-1:0] lsu2exu_ldata_o,          // load data
        output lsu2exu_exception_o,             // exception
        output [3:0] lsu2exu_exception_code_o,        // exception code

        // LSU <-> EXU interface
        output lsu2dmem_req_o,                  // request to DMEM
        output lsu2dmem_cmd_o,                  // command
        output [2:0] lsu2dmem_width_o,          // width
        output [API_ADDR_WIDTH-1:0] lsu2dmem_addr_o,          // address
        output [API_DATA_WIDTH-1:0] lsu2dmem_wdata_o,         // write data
        input dmem2lsu_req_ack_i,               // request ack from DMEM
        input [API_DATA_WIDTH-1:0] dmem2lsu_rdata_i,          // read data
        input [1:0] dmem2lsu_respone_i,         // response from DMEM
)

// LSU local definitions
// LSU state machine

//LSU FSM signals
reg lsu_fsm_curr;
reg lsu_fsm_next;
reg lsu_fsm_idle;

// LSU Command Register Signals
reg lsu_cmd_upd;
reg [8:0] lsu_cmd;
reg lsu_cmd_load;
reg lsu_cmd_store;

// DMEM Command and Width Flags
reg dmem_cmd_load;
reg dmem_cmd_store;
reg dmem_width_word;
reg dmem_width_hword;
reg dmem_width_byte;

// DMEM Response and Request Control Signals
reg dmem_response_ok;
reg dmem_response_er;
reg dmem_response_recv;
reg dmem_req_vd;

// Exception Signals
reg lsu_exc_req;
reg dmem_addr_mslng;
reg dmem_addr_mslng_l;
reg dmem_addr_mslng_s;

// Control Logic
//
// LSU load and store command flags
assign dmem_cmd_load = (exu2lsu_cmd_i == LSU_CMD_LB) | 
                       (exu2lsu_cmd_i == LSU_CMD_LH) |
                       (exu2lsu_cmd_i == LSU_CMD_LW) |
                       (exu2lsu_cmd_i == LSU_CMD_LBU)|
                       (exu2lsu_cmd_i == LSU_CMD_LHU);
assign dmem_cmd_store = (exu2lsu_cmd_i == LSU_CMD_SB) | 
                        (exu2lsu_cmd_i == LSU_CMD_SH) |
                        (exu2lsu_cmd_i == LSU_CMD_SW);

// DMEM response and request control signal
assign dmem_response_ok = (dmem2lsu_respone_i == MEM_RESP_RDY_OK);
assign dmem_response_er = (dmem2lsu_respone_i == MEM_RESP_RDY_ER);
assign dmem_response_recv = dmem_response_ok | dmem_response_er;
assign dmem_req_vd = dmem2lsu_req_ack_i & exu2lsu_req_i & ~lsu_exc_req;

// LSU data width flags
assign dmem_width_word  = (exu2lsu_cmd_i == LSU_CMD_LW)  | 
                          (exu2lsu_cmd_i == LSU_CMD_SW);
assign dmem_width_hword = (exu2lsu_cmd_i == LSU_CMD_LH)  | 
                          (exu2lsu_cmd_i == LSU_CMD_LHU) |
                          (exu2lsu_cmd_i == LSU_CMD_SH);
assign dmem_width_byte =  (exu2lsu_cmd_i == LSU_CMD_LB)  |
                          (exu2lsu_cmd_i == LSU_CMD_LBU) |
                          (exu2lsu_cmd_i == LSU_CMD_SB);

// LSU Command Register
assign lsu_cmd_upd = lsu_fsm_idle & dmem_req_vd;

always @(posedge clk or negedge rst)
begin
        if(~rst)
        begin
                lsu_cmd <= LSU_CMD_NONE;
                lsu_cmd_load <= 0;
                lsu_cmd_store <= 0;
        end
        else
        begin
                if(lsu_cmd_upd)
                begin
                        lsu_cmd <= exu2lsu_cmd_i;
                end
        end
end

assign lsu_cmd_load = (lsu_cmd == LSU_CMD_LB) | 
                      (lsu_cmd == LSU_CMD_LH) |
                      (lsu_cmd == LSU_CMD_LW) |
                      (lsu_cmd == LSU_CMD_LBU)|
                      (lsu_cmd == LSU_CMD_LHU);
assign lsu_cmd_store = (lsu_cmd == LSU_CMD_SB) | 
                       (lsu_cmd == LSU_CMD_SH) |
                       (lsu_cmd == LSU_CMD_SW);

// LSU FSM

always @(posedge clk or negedge rst)
begin
        if(~rst)
        begin
                lsu_fsm_curr <= LSU_FSM_IDLE;
                lsu_fsm_next <= LSU_FSM_IDLE;
                lsu_fsm_idle <= 1;
        end
        else
        begin
                lsu_fsm_curr <= lsu_fsm_next;
                lsu_fsm_idle <= (lsu_fsm_next == LSU_FSM_IDLE);
        end
end

// LSU Next State Logic
always @(posedge clk or negedge rst)
begin
        case (lsu_fsm_curr)
                LSU_FSM_IDLE:
                begin
                        lsu_fsm_next <= dmem_req_vd ? LSU_FSM_BUSY : LSU_FSM_IDLE;
                end
                LSU_FSM_BUSY:
                begin
                        lsu_fsm_next <= dmem_response_recv ? LSU_FSM_IDLE : LSU_FSM_BUSY;
                end
        endcase
end

// Exception Logic

assign dmem_addr_mslng   = exu2lsu_req_i & ( ((exu2lsu_addr_i[1:0] != 2'b00) & dmem_width_word ) |
                                             ((exu2lsu_addr_i[0] != 1'b0) & dmem_width_hword ));
assign dmem_addr_mslng_l = dmem_addr_mslng & dmem_cmd_load;
assign dmem_addr_mslng_s = dmem_addr_mslng & dmem_cmd_store;

always @(posedge clk or negedge rst)
begin
        case (1'b1)
                dmem_response_er: lsu2exu_exception_code_o = lsu_cmd_load ? EXC_CODE_LD_ACCESS_FAULT : lsu_cmd_store ? EXC_CODE_ST_ACCESS_FAULT : EXC_CODE_INSTR_MISALIGN;
                dmem_addr_msln_l: lsu2exu_exception_code_o = EXC_CODE_LD_ADDR_MISALIGN;
                dmem_addr_msln_s: lsu2exu_exception_code_o = EXC_CODE_ST_ADDR_MISALIGN;
                default         : lsu2exu_exception_code_o = EXC_CODE_INSTR_MISALIGN;
        endcase
end

assign lsu_exc_req = dmem_addr_mslng_l | dmem_addr_mslng_s;

// LSU <-> EXU
//

assign lsu2exu_ready_o = dmem_response_recv;
assign lsu2exu_exception_o = dmem_response_er | lsu_exc_req;

always @(posedge clk or negedge rst)
begin
        case(lsu_cmd)
                LSU_CMD_LB  : lsu2exu_ldata_o = {{24{dmem2lsu_rdata_i[7]}}, dmem2lsu_rdata_i[7:0]};
                LSU_CMD_LBU : lsu2exu_ldata_o = {{24{1'b0}}, dmem2lsu_rdata_i[7:0]};
                LSU_CMD_LH  : lsu2exu_ldata_o = {{16{dmem2lsu_rdata_i[15]}}, dmem2lsu_rdata_i[15:0]};
                LSU_CMD_LHU : lsu2exu_ldata_o = {{16{1'b0}}, dmem2lsu_rdata_i[15:0]};
                default     : lsu2exu_ldata_o = dmem2lsu_rdata_i;
        endcase
end

// LSU <-> DMEM
//

assign lsu2dmem_req_o = exu2lsu_req_i & lsu_fsm_idle & ~lsu_exc_req;
assign lsu2dmem_addr_o = exu2lsu_addr_i;
assign lsu2dmem_wdata_o = exu2lsu_sdata_i;
assign lsu2dmem_cmd_o = dmem_cmd_load ? MEM_CMD_READ : MEM_CMD_WRITE;
assign lsu2dmem_width_o = dmem_width_byte ? MEM_WIDTH_BYTE : dmem_width_hword ? MEM_WIDTH_HWORD : MEM_WIDTH_WORD;

endmodule
