`include "../core/DEFINITIONS.v"

module decoder(
    input clk,
    input [31:0] instruction,

    output [31:0] decoded_value,
    output [4:0] rs1,
    output [4:0] rs2,
    output [4:0] rd,
    output [6:0] opcode,
    output [2:0] funct3,
    output [6:0] funct7,
    output shift_la_sel,        // logical or arithmetic shift select
    output [7:0] pred_succ,     // Fence instruction 
    output e_call_break,
    output trap
);

    localparam  R_TYPE = 3'b000,
                I_TYPE = 3'b001,
                S_TYPE = 3'b010,
                U_TYPE = 3'b011,
                J_TYPE = 3'b100,
                B_TYPE = 3'b111;


    reg [31:0] decoded_value_reg, decoded_value_next;
    reg [4:0] rs1_reg, rs2_reg, rs1_next, rs2_next, rd_reg, rd_next;
    reg [6:0] opcode_reg, opcode_next, funct7_reg, funct7_next;
    reg [2:0] funct3_reg, funct3_next;
    reg shift_la_sel_reg, e_call_break_reg, trap_reg;
    reg [7:0] pred_succ_reg;

    // assign output
    assign opcode = opcode_reg;
    assign funct3 = funct3_reg;
    assign funct7 = funct7_reg;
    assign decoded_value = decoded_value_reg;
    assign rs1 = rs1_reg;
    assign rs2 = rs2_reg;
    assign rd = rd_reg;
    assign shift_la_sel = shift_la_sel_reg;
    assign e_call_break = e_call_break_reg;
    assign trap = trap_reg;
    assign pred_succ = pred_succ_reg;

    wire [2:0] instruction_type;
    assign instruction_type =   (instruction[6:0] == `INST_R_ALU )     ? R_TYPE :
                                (
                                instruction[6:0]  == `INST_I_ALU   ||
                                instruction[6:0]  == `INST_I_JALR  ||
                                instruction[6:0]  == `INST_I_LOAD  ||
                                instruction[6:0]  == `INST_I_SHIFT ||
                                instruction[6:0]  == `INST_S_STORE ||
                                instruction[6:0]  == `INST_I_CSR   ||
                                instruction[6:0]  == `INST_I_FENCE ||
                                instruction[6:0]  == `INST_I_CALL_N_BREAK
                                )                                      ? I_TYPE :
                                ( 
                                instruction[6:0]  == `INST_U_LUI   ||
                                instruction[6:0]  == `INST_U_AUIPC
                                )                                      ? U_TYPE :
                                ( instruction[6:0]  == `INST_J_JAL)    ? J_TYPE : 
                                ( instruction[6:0]  == `INST_B_BRANCH) ? B_TYPE : 3'bz;

    // perform update of decoded information at posedge of clock only
    always @(posedge clk) begin
        decoded_value_reg <= decoded_value_next;
        rs1_reg <= rs1_next;
        rs2_reg <= rs2_next;
        rd_reg  <= rd_next;
        opcode_reg <= opcode_next;
        funct3_reg <= funct3_next;
        funct7_reg <= funct7_next;
        shift_la_sel_reg <= (opcode_reg == `INST_I_SHIFT && funct7_reg !== 7'bz) ? instruction[30] : 1'bz;
        e_call_break_reg <= (opcode_reg == `INST_I_CALL_N_BREAK && instruction[14:12] == 3'b0) ? instruction[20] : 1'bz;
        trap_reg <= (rd_next === 5'b00000) ? 1'b1 : 1'b0;
        pred_succ_reg <= (opcode_reg == `INST_I_FENCE) ? ( (instruction[14:12] == 3'b000) ? instruction[27:20] : 8'b0) : 8'bz;
    end

    // decode next available instruction
    always @(*) begin

        opcode_next = instruction[6:0];
        
        case(instruction_type)
            R_TYPE: begin
                decoded_value_next = 32'bz; // no information to be decoded
                rs1_next = instruction[19:15];
                rs2_next = instruction[24:20];
                rd_next = instruction[11:7];
                funct3_next = instruction[14:12];
                funct7_next = instruction[31:25];
            end

            I_TYPE: begin
                if (opcode_next == `INST_I_ALU || opcode_next == `INST_I_JALR || opcode_next == `INST_I_LOAD) begin
                    decoded_value_next = { {21{instruction[31]}}, instruction[30:20]};
                    rs1_next = instruction[19:15];
                    rs2_next = 5'bz;
                    rd_next = instruction[11:7];
                    funct3_next = instruction[14:12];
                    funct7_next = 7'bz;
                end
                else if (opcode_next == `INST_I_SHIFT) begin
                    decoded_value_next = { {27{instruction[31]}}, instruction[24:20]}; 
                    rs1_next = instruction[19:15];
                    rs2_next = instruction[24:20];
                    rd_next = instruction[11:7];
                    funct3_next = instruction[14:12];
                    funct7_next = instruction[31:25];    
                end
                else if (opcode_next == `INST_I_CSR && instruction[14:12] !== 3'b0) begin
                    if ( instruction[14] )  begin// instruction[14] differentiates imm. '1' -> imm : CSRRSI, CSRRWI, CSRRCI
                        decoded_value_next = { 27'b0 + instruction[19:15]};
                    end
                    else begin
                        decoded_value_next = { 20'b0 + instruction[31:20]};
                    end
                end
                else if (opcode_next == `INST_I_CALL_N_BREAK && instruction[14:12] == 3'b0) begin
                    rd_next = 5'b0;
                    funct3_next = 3'b0;
                    funct7_next = 7'bz;
                end
                else if (opcode_next == `INST_I_FENCE) begin
                    funct3_next = instruction[14:12];
                end
            end

            S_TYPE: begin
                decoded_value_next = { {21{instruction[31]}}, instruction[30:25], instruction[11:7]};
                rs1_next = instruction[19:15];
                rs2_next = instruction[24:20];
                rd_next = 5'bz;
                funct3_next = instruction[14:12];
                funct7_next = 7'bz;
            end

            U_TYPE: begin
                decoded_value_next = {instruction[31:12], 12'b0};
                rs1_next = 5'bz;
                rs2_next = 5'bz;
                rd_next = instruction[11:7];
                funct3_next = 3'bz;
                funct7_next = 7'bz;
            end

            J_TYPE: begin
                decoded_value_next = { {12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
                rs1_next = 5'bz;
                rs2_next = 5'bz;
                rd_next = instruction[11:7];
                funct3_next = 3'bz;
                funct7_next = 7'bz;
            end

            B_TYPE: begin
                decoded_value_next = { {20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
                rs1_next = instruction[19:15];
                rs2_next = instruction[24:20];
                rd_next = 5'bz;
                funct3_next = instruction[14:12];
                funct7_next = instruction[31:25];
            end

            default: begin
                decoded_value_next = 32'bz;
                rs1_next = 5'b0;
                rs2_next = 5'bz;
                rd_next = 5'b0;
                opcode_next = `INST_I_ALU;
                funct3_next = `ADDI_FUNCT3;
                funct7_next = 7'b0;
            end
        endcase
    end

    initial begin
        opcode_reg = 7'b0;
        funct3_reg = 3'b0;
        funct7_reg = 3'b0;
        decoded_value_reg = 32'bz;
        rs1_reg = 5'bz;
        rs2_reg = 5'bz;
        rd_reg = 5'bz;  
        trap_reg = 1'b0;
        shift_la_sel_reg = 1'bz;
        e_call_break_reg = 1'bz;
        pred_succ_reg = 8'bz;
    end

endmodule