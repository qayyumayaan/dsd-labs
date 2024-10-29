module ALU (
    input logic [31:0] SrcA,  // First operand
    input logic [31:0] SrcB,  // Second operand
    input logic [2:0] ALUControl,  // ALU control signal to select operation
    output logic [31:0] ALUResult  // Output of the ALU
);

    always_comb begin
        case(ALUControl)
            3'b010: ALUResult = SrcA + SrcB;  // ADD operation
            3'b110: ALUResult = SrcA - SrcB;  // SUB operation
            default: ALUResult = 32'b0;  // Default case: no operation
        endcase
    end

endmodule
