module fft16 (
    input  logic signed [15:0] inputs[15:0],  // 16 16-bit signed inputs
    output logic signed [31:0] fft_real[15:0], // 16 32-bit signed real parts
    output logic signed [31:0] fft_imag[15:0]  // 16 32-bit signed imaginary parts
);

    // Internal buffers for intermediate stages
    logic signed [31:0] real_stage[3:0][15:0];
    logic signed [31:0] imag_stage[3:0][15:0];

    // Indices and temporary variables
    integer stage, butterfly, group;
    logic [7:0] twiddle_index;
    logic signed [15:0] twiddle_real, twiddle_imag;
    logic signed [31:0] temp_real, temp_imag;

    // Instantiate twiddle factor lookup
    twiddle_factors tf(
        .index(twiddle_index),
        .twiddle_real(twiddle_real),
        .twiddle_imag(twiddle_imag)
    );

    always_comb begin
        // Stage 0: Load inputs
        for (group = 0; group < 16; group++) begin
            real_stage[0][group] = inputs[group];
            imag_stage[0][group] = 0;
        end

        // FFT computation across stages
        for (stage = 1; stage <= 4; stage++) begin
            int step = 1 << stage; // Step size doubles per stage
            int half_step = step >> 1;

            for (group = 0; group < 16; group += step) begin
                for (butterfly = 0; butterfly < half_step; butterfly++) begin
                    // Compute twiddle factor index
                    twiddle_index = (butterfly << (4 - stage)) % 16;

                    // Fetch twiddle factors
                    temp_real = real_stage[stage-1][group + butterfly + half_step] * twiddle_real -
                                imag_stage[stage-1][group + butterfly + half_step] * twiddle_imag;
                    temp_imag = real_stage[stage-1][group + butterfly + half_step] * twiddle_imag +
                                imag_stage[stage-1][group + butterfly + half_step] * twiddle_real;

                    // Scale down by 15 bits
                    temp_real = temp_real >>> 15;
                    temp_imag = temp_imag >>> 15;

                    // Butterfly computation
                    real_stage[stage][group + butterfly] = real_stage[stage-1][group + butterfly] + temp_real;
                    imag_stage[stage][group + butterfly] = imag_stage[stage-1][group + butterfly] + temp_imag;
                    real_stage[stage][group + butterfly + half_step] = real_stage[stage-1][group + butterfly] - temp_real;
                    imag_stage[stage][group + butterfly + half_step] = imag_stage[stage-1][group + butterfly] - temp_imag;
                end
            end
        end

        // Assign final stage outputs
        for (group = 0; group < 16; group++) begin
            fft_real[group] = real_stage[4][group];
            fft_imag[group] = imag_stage[4][group];
        end
    end

endmodule