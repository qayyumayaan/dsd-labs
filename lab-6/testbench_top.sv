module testbench_top();

    logic clk, rst;
    logic[1:0] sw; // address for instruction memory
    logic[31:0] ALUResult;
    logic[31:0] RD1, RD2;
    logic[31:0] prode_register_file;

    // Instantiate the top module
    top uut(
        .clk(clk),
        .rst(rst),
        .sw(sw),
        .ALUResult(ALUResult),
        .RD1(RD1),
        .RD2(RD2),
        .prode_register_file(prode_register_file)
    );

    // Reset logic
    initial begin
        rst = 1'b0;
        #50 rst = 1'b1; // Deassert reset after 50 time units
    end

    // Clock generation logic
    initial begin
        clk = 1'b0;
        forever #25 clk = ~clk;  // 50 time unit clock period
    end

    // Stimulus for switch
    initial begin
        sw = 2'b00;  // No-op
        #100;
        sw = 2'b01;  // ADD instruction
        #100;
        sw = 2'b10;  // SUB instruction
    end

endmodule