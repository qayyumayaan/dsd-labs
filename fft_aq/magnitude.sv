module magnitude (
    input logic signed [15:0] real_in[15:0], // Real parts of FFT output
    input logic signed [15:0] imag_in[15:0], // Imaginary parts of FFT output
    output logic [15:0] magnitude_out[15:0]  // Magnitude output
);

    // Calculate magnitude for each complex input
    always_comb begin
        for (int i = 0; i < 16; i++) begin
            // Declare abs_real and abs_imag here to avoid non-constant expression errors
            logic signed [15:0] abs_real;
            logic signed [15:0] abs_imag;
            
            // Absolute values of real and imaginary parts
            abs_real = (real_in[i] < 0) ? -real_in[i] : real_in[i];
            abs_imag = (imag_in[i] < 0) ? -imag_in[i] : imag_in[i];
            
            // Calculate approximate magnitude
            if (abs_real > abs_imag) begin
                magnitude_out[i] = abs_real + (abs_imag >> 1); // max(abs_real, abs_imag) + min(abs_real, abs_imag) / 2
            end else begin
                magnitude_out[i] = abs_imag + (abs_real >> 1); // max(abs_real, abs_imag) + min(abs_real, abs_imag) / 2
            end
        end
    end

endmodule
