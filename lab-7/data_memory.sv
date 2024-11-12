module data_memory(
    input logic clk, rst,
    input logic [31:0] A,     // address
    input logic [31:0] WD,    // input data
    input logic WE,           // enable input
    output logic [31:0] RD,   // output data
	output logic [31:0] probe // Data memory probe
);
    logic [31:0] memory [0:255]; // 256 words of 32-bit memory

    // Write operation
    always_ff @(posedge clk or negedge rst) begin
        if (~rst) begin // Active low reset
            integer i;
            for (i = 0; i < 256; i = i + 1) begin
                memory[i] <= 32'b0;
            end
        end else if (WE) begin
            memory[A] <= WD;
        end
    end

    // Read operation
    assign RD = memory[A];
	 assign probe = memory[1];
endmodule