module MUX_MemtoReg(
    input logic MemtoReg,
    input logic [31:0] ALUResult,
    input logic [31:0] RD, // from data memory
    output logic [31:0] MemtoReg_out
);
    assign MemtoReg_out = MemtoReg ? RD : ALUResult;
endmodule
