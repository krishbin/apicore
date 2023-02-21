`include "../core/exu.v"

module rv32im_exu_testbench();

reg [`API_DATA_WIDTH-1:0] curr_pc,rs1, rs2, imm,csr_output,val_memdatard;
wire [`API_DATA_WIDTH-1:0] new_pc,data,val_memdatawr, val_memaddr;
reg [`LSU_OPCODE_WIDTH-1:0] lsu_opcode;
reg [`ALU_OPCODE_WIDTH-1:0] alu_opcode;
reg [`BR_OPCODE_WIDTH-1:0] br_opcode;
reg [`DATA_ORIGIN_WIDTH-1:0] data_origin;
reg [`DATA_TARGET_WIDTH-1:0] data_target;
reg is_branch,is_condition;

rv32im_exu a1(
    .alu_opcode_i(alu_opcode),
    .lsu_opcode_i(lsu_opcode),
    .br_opcode_i(br_opcode),
    .rs1_i(rs1),
    .rs2_i(rs2),
    .imm_i(imm),
    .data_origin_i(data_origin),
    .data_target_i(data_target),
    .val_memdatard_i(val_memdatard),
    .val_memdatawr_o(val_memdatawr),
    .val_memaddr_o(val_memaddr),
    .is_branch_i(is_branch),
    .is_condition_i(is_condition),
    .curr_pc_i(curr_pc),
    .new_pc_o(new_pc),
    .csr_output_i(csr_output),
    .data_o(data)
    );

initial begin
    $dumpfile("exu.vcd");
    $dumpvars();
    $monitor("alu_opcode=%b, lsu_opcode=%b, br_opcode=%b, rs1=%d, rs2=%d, imm=%d, data_origin=%b, data_target=%b, val_memdatard=%d, val_memdatawr=%d, val_memaddr=%d, is_branch=%b, is_condition=%b, curr_pc=%d, new_pc=%d, csr_output=%d, data=%d \n", alu_opcode, lsu_opcode, br_opcode, rs1, rs2, imm, data_origin, data_target, val_memdatard, val_memdatawr, val_memaddr, is_branch, is_condition, curr_pc, new_pc, csr_output, data);
    alu_opcode=`ALU_OPCODE_ADD; lsu_opcode=`LSU_OPCODE_NONE; br_opcode=`BR_OPCODE_NONE; rs1=6; rs2=100; imm=0; data_origin=0; data_target=0; val_memdatard=0; is_branch=0; is_condition=0; curr_pc=0; csr_output=0;
    #10
    alu_opcode=`ALU_OPCODE_OR; lsu_opcode=`LSU_OPCODE_NONE; br_opcode=`BR_OPCODE_NONE; rs1=6; rs2=100; imm=0; data_origin=0; data_target=0; val_memdatard=0; is_branch=0; is_condition=0; curr_pc=0; csr_output=0;
    #10
    alu_opcode=`ALU_OPCODE_SLT; lsu_opcode=`LSU_OPCODE_NONE; br_opcode=`BR_OPCODE_NONE; rs1=6; rs2=100; imm=0; data_origin=0; data_target=0; val_memdatard=0; is_branch=0; is_condition=0; curr_pc=0; csr_output=0;
    #10
    $finish;
end

endmodule
