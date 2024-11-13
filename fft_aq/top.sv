module top (
    input logic clk,                // Clock
    input logic rst,                // Reset
    input logic start,              // Start signal to initiate FFT
    output logic valid_out,         // FFT output data valid signal
    output logic [15:0] out[7:0]    // Magnitude of FFT output
);

    // Internal control signal to indicate valid input for FFT core
    logic valid_in;
    logic signed [15:0] time_points[7:0]; // Internal time points array
    logic signed [15:0] real_in[7:0];
    logic signed [15:0] real_out[7:0];    // Internal real parts of FFT output
    logic signed [15:0] imag_out[7:0];    // Internal imaginary parts of FFT output
    logic [15:0] magnitude_out[7:0];      // Magnitude output from the magnitude module

    // Assign time_points to real_in
    assign real_in = time_points;

    // Instantiate FFT core
    fft_core fft_inst (
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),
        .real_in(real_in),
        .valid_out(valid_out),
        .real_out(real_out),
        .imag_out(imag_out)
    );

    // Instantiate Magnitude module
    magnitude mag_inst (
        .real_in(real_out),
        .imag_in(imag_out),
        .magnitude_out(magnitude_out)
    );

    // Assign magnitude output to top module's output
    assign out = magnitude_out;

    // Initial assignment of sine wave values to time_points
    initial begin
        time_points = '{0, 16'sd55146, 16'sd59591, 16'sd9248, -16'sd49598, -16'sd62845, -16'sd18312, 16'sd43056};
    end

    // Generate valid_in signal based on the start signal
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            valid_in <= 0;
        end else begin
            valid_in <= start; // valid_in is asserted when start is high
        end
    end

endmodule
