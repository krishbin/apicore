`include "../core/DEFINITIONS.v"

module rv32im_alu(
    input [`API_DATA_WIDTH-1:0] aluoperand_1_i,
    input [`API_DATA_WIDTH-1:0] aluoperand_2_i,
    input [`ALU_OPCODE_WIDTH-1:0]  alu_opcode_i,
    output alu_zero_o,
    output reg [`API_DATA_WIDTH-1:0] alu_o
);

// Register declaration
wire[`API_DATA_WIDTH-1:0] sub_o1_o2 = aluoperand_1_i - aluoperand_2_i;

// ALU logic
assign alu_zero_o = (alu_o == 32'h0) ? 1'b1 : 1'b0;

always @ * begin
    case (alu_opcode_i)

        // Arithmetic
        `ALU_OPCODE_ADD: 
        begin
            alu_o = aluoperand_1_i + aluoperand_2_i; // ADD
        end
        `ALU_OPCODE_SUB: 
        begin
            alu_o = sub_o1_o2; // SUB
        end

        `ALU_OPCODE_MUL:
        begin
            alu_o = (aluoperand_1_i[15:0] * aluoperand_2_i[15:0]);
        end

        `ALU_OPCODE_MULH:
        begin
            alu_o = (aluoperand_1_i[31:16] * aluoperand_2_i[31:16]);
        end

        `ALU_OPCODE_DIV:
        begin
            alu_o = aluoperand_1_i / aluoperand_2_i; // ADD
        end

        `ALU_OPCODE_REM:
        begin
            alu_o = aluoperand_1_i % aluoperand_2_i; // ADD
        end

        //Logical
        `ALU_OPCODE_AND: 
        begin
            alu_o = aluoperand_1_i & aluoperand_2_i; // AND
        end
        `ALU_OPCODE_OR:
        begin
            alu_o = aluoperand_1_i | aluoperand_2_i; // OR
        end
        `ALU_OPCODE_XOR: 
        begin
            alu_o = aluoperand_1_i ^ aluoperand_2_i; // XOR
        end

        // Comparison
        `ALU_OPCODE_SLT: 
        begin
            if (aluoperand_1_i[31] == aluoperand_2_i[31])
                alu_o = sub_o1_o2[31] ? 32'h1 : 32'h0; // SLT
            else
                alu_o = aluoperand_1_i[31] ? 32'h1 : 32'h0; // SLT
        end
        `ALU_OPCODE_SLTU: 
        begin
            alu_o = (aluoperand_1_i < aluoperand_2_i) ? 32'h1 : 32'h0; // SLT
        end

        // Shift
        `ALU_OPCODE_SLL: 
        begin
            alu_o = aluoperand_1_i << aluoperand_2_i[4:0]; // SLL
        end
        `ALU_OPCODE_SRL: 
        begin
            alu_o = aluoperand_1_i >> aluoperand_2_i[4:0]; // SRL
        end
        `ALU_OPCODE_SRA: 
        begin
            alu_o = aluoperand_1_i >>> aluoperand_2_i[4:0]; // SRA
        end

        default: alu_o = 32'b0;
    endcase
end

endmodule
