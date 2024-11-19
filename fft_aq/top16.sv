module top16 (
    input logic clk,                              // Clock signal
    input logic reset,                            // Reset signal
    input logic signed [15:0] inputs[15:0],       // 16 signed 16-bit inputs
    output logic [15:0] magnitude_out[15:0]       // 16 magnitudes of FFT outputs
);

    // Wires for FFT outputs
    logic signed [31:0] fft_real[15:0];
    logic signed [31:0] fft_imag[15:0];

    // Intermediate wires for reduced magnitude inputs
    logic signed [15:0] fft_real_reduced[15:0];
    logic signed [15:0] fft_imag_reduced[15:0];

    // Instantiate FFT module
    fft16 fft_inst (
        .inputs(inputs),
        .fft_real(fft_real),
        .fft_imag(fft_imag)
    );

    // Reduce FFT output to 16-bit for magnitude calculation
    always_comb begin
        for (int i = 0; i < 16; i++) begin
            fft_real_reduced[i] = fft_real[i][31:16]; // Truncate to 16 MSBs
            fft_imag_reduced[i] = fft_imag[i][31:16];
        end
    end

    // Instantiate magnitude calculation module
    magnitude magnitude_inst (
        .real_in(fft_real_reduced),
        .imag_in(fft_imag_reduced),
        .magnitude_out(magnitude_out)
    );

endmodule
