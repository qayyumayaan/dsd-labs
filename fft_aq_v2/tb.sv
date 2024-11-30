`timescale 1ns/1ps

module tb;

    // Parameters
    parameter N = 16;
    parameter Q = 15; // Number of fractional bits in Q1.15 format
    parameter DATA_WIDTH = 16;

    // Test input data
	integer x_int [0:N-1] = '{
		 0, 13328, 24351, 31163, 32587, 28377, 19260, 6813, -6813, -19260, -28377, -32587, -31163, -24351, -13328, 0
	};

    logic signed [DATA_WIDTH-1:0] x_real [0:N-1];
    logic signed [DATA_WIDTH-1:0] x_imag [0:N-1];
    logic signed [DATA_WIDTH-1:0] fft_real [0:N-1];
    logic signed [DATA_WIDTH-1:0] fft_imag [0:N-1];

    integer i, max_input_value;

    // Instantiate FFT module
    fft_16_elements fft_inst (
        .x_real(x_real),
        .x_imag(x_imag),
        .fft_real(fft_real),
        .fft_imag(fft_imag)
    );

    initial begin
        for (i = 0; i < N; i++) begin
            x_real[i] = x_int[i];
            x_imag[i] = 16'sd0;
        end

        // Wait for combinational logic to settle
        #10;

        // Log results
        $display("\nFinal FFT Results (Q1.15):");
        for (i = 0; i < N; i++) begin
            $display("FFT[%0d] = %0d + j%0d", i, fft_real[i], fft_imag[i]);
        end

        $finish;
    end

endmodule
