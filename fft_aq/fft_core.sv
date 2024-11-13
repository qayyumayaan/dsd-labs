module fft_core (
    input logic clk,                // Clock
    input logic rst,                // Reset
    input logic valid_in,           // Input data valid signal
    input logic signed [15:0] real_in[7:0], // Real parts of the input (8-point)
    output logic valid_out,         // Output data valid signal
    output logic signed [15:0] real_out[7:0], // Real parts of the output
    output logic signed [15:0] imag_out[7:0]  // Imaginary parts of the output
);

    // Twiddle factors for 8-point FFT (fixed-point, signed 1.15 format)
    localparam logic signed [15:0] TWIDDLE_REAL[7:0] = 
        '{16'sh7FFF, 16'sh5A82, 16'sh0000, -16'sh5A82, -16'sh7FFF, -16'sh5A82, 16'sh0000, 16'sh5A82};
    localparam logic signed [15:0] TWIDDLE_IMAG[7:0] = 
        '{16'sh0000, -16'sh5A82, -16'sh7FFF, -16'sh5A82, 16'sh0000, 16'sh5A82, 16'sh7FFF, 16'sh5A82};

    // Intermediate signals for butterfly stages
    logic signed [15:0] real_stage1[7:0], imag_stage1[7:0];
    logic signed [15:0] real_stage2[7:0], imag_stage2[7:0];

    // Stage 1: First Butterfly (Radix-2, 8-point FFT)
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            for (int i = 0; i < 8; i++) begin
                real_stage1[i] <= 0;
                imag_stage1[i] <= 0;
            end
        end else if (valid_in) begin
            // Butterfly operations for 8-point FFT
            real_stage1[0] <= real_in[0] + real_in[4];
            imag_stage1[0] <= 0; // Initial imaginary part is 0
            real_stage1[1] <= real_in[1] + real_in[5];
            imag_stage1[1] <= 0;
            real_stage1[2] <= real_in[2] + real_in[6];
            imag_stage1[2] <= 0;
            real_stage1[3] <= real_in[3] + real_in[7];
            imag_stage1[3] <= 0;
            real_stage1[4] <= real_in[0] - real_in[4];
            imag_stage1[4] <= 0;
            real_stage1[5] <= real_in[1] - real_in[5];
            imag_stage1[5] <= 0;
            real_stage1[6] <= real_in[2] - real_in[6];
            imag_stage1[6] <= 0;
            real_stage1[7] <= real_in[3] - real_in[7];
            imag_stage1[7] <= 0;
        end
    end

    // Stage 2: Multiply by Twiddle Factors for 8-point FFT
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            for (int i = 0; i < 8; i++) begin
                real_stage2[i] <= 0;
                imag_stage2[i] <= 0;
            end
        end else begin
            // Multiply by twiddle factors
            for (int i = 0; i < 8; i++) begin
                real_stage2[i] <= (real_stage1[i] * TWIDDLE_REAL[i] - imag_stage1[i] * TWIDDLE_IMAG[i]) >>> 15;
                imag_stage2[i] <= (real_stage1[i] * TWIDDLE_IMAG[i] + imag_stage1[i] * TWIDDLE_REAL[i]) >>> 15;
            end
        end
    end

    // Output assignment
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            valid_out <= 0;
            for (int i = 0; i < 8; i++) begin
                real_out[i] <= 0;
                imag_out[i] <= 0;
            end
        end else begin
            valid_out <= valid_in;
            for (int i = 0; i < 8; i++) begin
                real_out[i] <= real_stage2[i];
                imag_out[i] <= imag_stage2[i];
            end
        end
    end

endmodule
