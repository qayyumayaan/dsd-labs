module fft2_point (
    input signed [15:0] x0,  // Input point 0
    input signed [15:0] x1,  // Input point 1
    output signed [16:0] X0, // Output frequency 0 (increased width to avoid overflow)
    output signed [16:0] X1  // Output frequency 1 (increased width to avoid overflow)
);
    assign X0 = x0 + x1;      // Frequency 0
    assign X1 = x0 - x1;      // Frequency 1
endmodule