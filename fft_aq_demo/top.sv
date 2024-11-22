module top (
    input logic clk,                   // Clock input
    input logic rst_n,                 // Active-low reset
    input logic [7:0] SW_x0,           // 8 slide switches for x0
    input logic [7:0] SW_x1,           // 8 slide switches for x1
    output logic [6:0] HEX0, HEX1, HEX2,  // 7-segment displays for X0
    output logic [6:0] HEX3, HEX4, HEX5   // 7-segment displays for X1
);

    // Input values
    logic signed [15:0] x0, x1; // Increased width to match fft2_point
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x0 <= 16'b0;
            x1 <= 16'b0;
        end else begin
            x0 <= { {8{SW_x0[7]}}, SW_x0 }; // Sign-extend 8-bit SW_x0 to 16 bits
            x1 <= { {8{SW_x1[7]}}, SW_x1 }; // Sign-extend 8-bit SW_x1 to 16 bits
        end
    end

    // FFT outputs
    logic signed [16:0] X0, X1; // Increased width to handle overflow

    // Instantiate the FFT module
    fft2_point fft_inst (
        .x0(x0),
        .x1(x1),
        .X0(X0),
        .X1(X1)
    );

    // Convert X0 and X1 to absolute values
    logic [16:0] abs_X0, abs_X1; // Increased width to handle full range
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            abs_X0 <= 17'b0;
            abs_X1 <= 17'b0;
        end else begin
            abs_X0 <= (X0 < 0) ? -X0 : X0;
            abs_X1 <= (X1 < 0) ? -X1 : X1;
        end
    end

    // Extract decimal digits for X0
    logic [3:0] X0_ones, X0_tens, X0_hundreds;
    logic [3:0] X1_ones, X1_tens, X1_hundreds;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            X0_ones    <= 4'b0;
            X0_tens    <= 4'b0;
            X0_hundreds <= 4'b0;
            X1_ones    <= 4'b0;
            X1_tens    <= 4'b0;
            X1_hundreds <= 4'b0;
        end else begin
            X0_ones    <= abs_X0 % 10;
            X0_tens    <= (abs_X0 / 10) % 10;
            X0_hundreds <= (abs_X0 / 100) % 10;
            X1_ones    <= abs_X1 % 10;
            X1_tens    <= (abs_X1 / 10) % 10;
            X1_hundreds <= (abs_X1 / 100) % 10;
        end
    end

    // Instantiate the display driver for X0 (HEX0, HEX1, HEX2)
    display display_X0_0(.digit(X0_ones),   .segments(HEX0)); // Ones place
    display display_X0_1(.digit(X0_tens),   .segments(HEX1)); // Tens place
    display display_X0_2(.digit(X0_hundreds), .segments(HEX2)); // Hundreds place

    // Instantiate the display driver for X1 (HEX3, HEX4, HEX5)
    display display_X1_0(.digit(X1_ones),   .segments(HEX3)); // Ones place
    display display_X1_1(.digit(X1_tens),   .segments(HEX4)); // Tens place
    display display_X1_2(.digit(X1_hundreds), .segments(HEX5)); // Hundreds place

endmodule
