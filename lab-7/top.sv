module top(
    input logic clk, rst,
    input logic [1:0] sw, // address selector for instructions
    output logic [31:0] ALUResult, // output for pre-lab simulation
    output logic [31:0] RD1, RD2, // output for pre-lab simulation
    output logic [31:0] probe_register_file, // output for pre-lab simulation
    output logic [31:0] probe_data_memory,   // probe for data memory
    output logic [6:0] display_led, // output for in-lab
    output logic [6:0] display_led2 // secondary output
);

    // Define example I-type instructions for testing LW and SW
    logic [31:0] inst_0 = 32'b0;  // No-op instruction
    // LW: Load data_memory[5] -> rf_regs[1]
    // SW: Store rf_regs[6] -> data_memory[2]
    logic [31:0] inst_lw = 32'b010101_00000_00001_0000_0000_0000_0101; 
    logic [31:0] inst_sw = 32'b010100_00000_00110_0000_0000_0000_0010; 

    // Instruction selection based on `sw`
    logic [31:0] inst_ex;
    assign inst_ex = (sw == 2'b01) ? inst_lw : (sw == 2'b10) ? inst_sw : inst_0;

    // Control signals extracted from instruction
    logic MemtoReg, ALUSrc, RegDst, WE_data_memory;
    assign MemtoReg = inst_ex[31:26] == 6'b010101; // 1 for LW
    assign ALUSrc = 1; // Always 1 for I-type instructions
    assign RegDst = 0; // Always 0 for I-type (dest is `rt`)
    assign WE_data_memory = inst_ex[31:26] == 6'b010100; // 1 for SW

    // Register and Immediate Signals
    logic [2:0] ALUControl = 3'b010;
    logic [31:0] SignImm;
    logic [31:0] ALUSrc_out;
    logic [4:0] RegDst_out;
    logic [31:0] RD;  // New signal for data_memory output
    logic [31:0] MemtoReg_out;
    
    // Sign extend the immediate value
    sign_extend sign_ext(
        .Imm(inst_ex[15:0]),
        .SignImm(SignImm)
    );

    // Register File
    register_file r_f(
        .clk(clk),
        .rst(rst),
        .A1(inst_ex[25:21]), // rs
        .A2(inst_ex[20:16]), // rt
        .A3(RegDst_out),     // destination register
        .WD3(MemtoReg_out),  // data to write to register file
        .WE3(1),      // write enable
        .RD1(RD1),
        .RD2(RD2),
        .probe(probe_register_file)
    );

    // MUX for ALUSrc
    MUX_ALUSrc mux_alusrc(
        .ALUSrc(ALUSrc),
        .RD2(RD2),
        .SignImm(SignImm),
        .ALUSrc_out(ALUSrc_out)
    );

    // MUX for RegDst
    MUX_RegDst mux_regdst(
        .RegDst(RegDst),
        .rt(inst_ex[20:16]), // rt field
        .rd(inst_ex[15:11]), // rd field (not used for I-type)
        .RegDst_out(RegDst_out)
    );

    // ALU
    ALU alu(
        .SrcA(RD1),
        .SrcB(ALUSrc_out),
        .ALUControl(ALUControl), // ADD operation for address calculation
        .ALUResult(ALUResult)
    );

    // Data Memory
    data_memory data_mem(
        .clk(clk),
        .rst(rst),
        .A(ALUResult),       // address from ALU result
        .WD(RD2),            // data to write (from rt register)
        .WE(WE_data_memory), // write enable (1 for SW, 0 otherwise)
        .RD(RD) // Output data for MemtoReg MUX
		.probe(probe_data_memory)
    );

    // MUX for MemtoReg
    MUX_MemtoReg mux_memtoreg(
        .MemtoReg(MemtoReg),
        .ALUResult(ALUResult),
        .RD(RD),   // data from memory
        .MemtoReg_out(MemtoReg_out)
    );

    // Display output (for in-lab display on 7-segment)
    display t1(
        .data_in(probe_register_file),
        .segments(display_led)
    );
    
    display t2(
        .data_in(probe_data_memory),
        .segments(display_led2)
    );

endmodule
