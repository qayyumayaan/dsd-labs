module register_file (
    input logic clk,  // Clock
    input logic rst,  // Reset signal (active-low)
    input logic [4:0] A1,  // First read address
    input logic [4:0] A2,  // Second read address
    input logic [4:0] A3,  // Write address
    input logic [31:0] WD3,  // Write data
    input logic WE3,  // Write enable
    output logic [31:0] RD1,  // First read data
    output logic [31:0] RD2,  // Second read data
    output logic [31:0] probe  // Probe for display
);

    logic [31:0] rf_regs [31:0];  // 32 registers each 32 bits wide

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin  // Active-low reset
            for (int i = 0; i < 32; i++) begin
                rf_regs[i] <= i;  // Initialize registers with their index
            end
        end else if (WE3) begin
            rf_regs[A3] <= WD3;  // Write to register on positive clock edge
        end
    end

    assign RD1 = rf_regs[A1];
    assign RD2 = rf_regs[A2];
    assign probe = rf_regs[A1];  // Probe the register content for display

endmodule