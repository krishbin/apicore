`include "../core/alu.v"

module rv32im_alu_testbench();
reg[31:0] a,b;
reg[4:0] opcode;
wire[31:0] o;

rv32im_alu a1(
    .aluoperand_1_i(a),
    .aluoperand_2_i(b),
    .alu_opcode_i(opcode),
    .alu_o(o));

initial begin
    $dumpfile("alu.vcd");
    $dumpvars();
    $monitor("a=%b, b=%b, opcode=%b, out=%b \n", a, b, opcode, o);
    a = 32'h1;      b = 32'h0;       opcode = 5'b00000;
    #10
    a = 32'h438978;      b = 32'h83728;       opcode = 5'b01000;
    #10
    a = 32'h438978;      b = 32'h83728;       opcode = 5'b00000;
    #10
    a = 32'h438978;      b = 32'h5;       opcode = 5'b00001;
    #10
    a = 32'h438978;      b = 32'h5;       opcode = 5'b00010;
    #10
    a = 32'h0;      b = 32'h5;       opcode = 5'b00010;
    #10
    $finish;
end

endmodule