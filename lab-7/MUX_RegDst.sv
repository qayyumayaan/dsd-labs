module MUX_RegDst(
    input logic RegDst,
    input logic [4:0] rt,   // destination register from instruction
    input logic [4:0] rd,   // destination register for R-type instructions
    output logic [4:0] RegDst_out
);
    assign RegDst_out = RegDst ? rd : rt;
endmodule