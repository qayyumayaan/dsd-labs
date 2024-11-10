module MUX_ALUSrc(
    input logic ALUSrc,
    input logic [31:0] ReadData2,  // from Register File
    input logic [31:0] SignImm,    // sign-extended immediate
    output logic [31:0] ALUSrc_out
);
    assign ALUSrc_out = ALUSrc ? SignImm : ReadData2;
endmodule