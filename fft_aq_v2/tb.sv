`timescale 1ns/1ps

module tb;

    // Parameters
    parameter N = 16;
    parameter Q = 15; // Number of fractional bits in Q1.15 format
    parameter DATA_WIDTH = 16;

    // Test input data
    integer x_int [0:N-1] = '{
        2404, 4756, 7005, 9102, 11002, 12665, 14053, 15136,
        15892, 16305, 16364, 16069, 15426, 14449, 13159, 11585
    };

    logic signed [DATA_WIDTH-1:0] x_real [0:N-1];
    logic signed [DATA_WIDTH-1:0] x_imag [0:N-1];
    logic signed [DATA_WIDTH-1:0] fft_real [0:N-1];
    logic signed [DATA_WIDTH-1:0] fft_imag [0:N-1];

    integer i, max_input_value, scaling_factor_num, scaling_factor_den, scaled_value_int;

    // Instantiate FFT module
    fft_16_elements fft_inst (
        .x_real(x_real),
        .x_imag(x_imag),
        .fft_real(fft_real),
        .fft_imag(fft_imag)
    );

    initial begin
        // Scaling inputs
        max_input_value = 0;
        for (i = 0; i < N; i++) begin
            max_input_value = (x_int[i] > max_input_value) ? x_int[i] : max_input_value;
        end
        scaling_factor_num = 9 * (1 << Q);
        scaling_factor_den = 10 * max_input_value;

        for (i = 0; i < N; i++) begin
            scaled_value_int = (x_int[i] * scaling_factor_num) / scaling_factor_den;
            x_real[i] = scaled_value_int;
            x_imag[i] = 16'sd0;
        end

        // Wait for combinational logic to settle
        #10;

        // Log results
        $display("\nFFT Results (Q1.15):");
        for (i = 0; i < N; i++) begin
            $display("FFT[%0d] = %0d + j%0d", i, fft_real[i], fft_imag[i]);
        end

        $finish;
    end

endmodule
