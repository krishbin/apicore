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
    $dumpfile("../waveform/alu.vcd");
    $dumpvars();
    // $monitor("a=%b, b=%b, opcode=%b, out=%b \n", a, b, opcode, o);
    a = 32'h20; b = 32'h5; opcode = `ALU_OPCODE_ADD;      #10;
    a = 32'h20; b = 32'h5; opcode = `ALU_OPCODE_SUB;      #10;
    a = 32'h20; b = 32'h5; opcode = `ALU_OPCODE_SLL;      #10;
    a = 32'h20; b = 32'h5; opcode = `ALU_OPCODE_SLT;      #10;
    a = 32'h20; b = 32'h5; opcode = `ALU_OPCODE_SLTU;     #10;
    a = 32'h20; b = 32'h5; opcode = `ALU_OPCODE_XOR;      #10;
    a = 32'h20; b = 32'h5; opcode = `ALU_OPCODE_SRL;      #10;
    a = 32'h20; b = 32'h5; opcode = `ALU_OPCODE_SRA;      #10;
    a = 32'h20; b = 32'h5; opcode = `ALU_OPCODE_OR;       #10;
    a = 32'h20; b = 32'h5; opcode = `ALU_OPCODE_AND;      #10;
    a = 32'h20; b = 32'h5; opcode = `ALU_OPCODE_MUL;      #10;
    a = 32'h20; b = 32'h5; opcode = `ALU_OPCODE_MULH;     #10;
    a = 32'h20; b = 32'h5; opcode = `ALU_OPCODE_MULHSU;   #10;
    a = 32'h20; b = 32'h5; opcode = `ALU_OPCODE_MULHU;    #10;
    a = 32'h20; b = 32'h5; opcode = `ALU_OPCODE_DIV;      #10;
    a = 32'h20; b = 32'h5; opcode = `ALU_OPCODE_DIVU;     #10;
    a = 32'h20; b = 32'h5; opcode = `ALU_OPCODE_REM;      #10;
    a = 32'h20; b = 32'h5; opcode = `ALU_OPCODE_REMU;     #10;
    $finish;
end

endmodule