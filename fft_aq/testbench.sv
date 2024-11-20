`timescale 1ns / 1ps

module testbench();

    // Clock and reset signals
    logic clk;
    logic reset;

    // Inputs and outputs
    logic signed [15:0] inputs[15:0];
    logic [15:0] magnitude_out[15:0];

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 10 ns clock period

    // Instantiate the top-level module
    top16 uut (
        .clk(clk),
        .reset(reset),
        .inputs(inputs),
        .magnitude_out(magnitude_out)
    );

    // Stimulus block
    initial begin
        // Open VCD file for waveform generation
        $dumpfile("testbench.vcd");
        $dumpvars(0, testbench);

        // Initialize inputs
        reset = 1;
        #10 reset = 0;

        // Initialize testbench inputs in integer format
        inputs = '{
            16'h0000,
            16'h030F,
            16'h05A8,
            16'h0764,
            16'h0800,
            16'h0764,
            16'h05A8,
            16'h030F,
            16'h0000,
            16'hFCF0,
            16'hFA58,
            16'hF89C,
            16'hF800,
            16'hF89C,
            16'hFA58,
            16'hFCF0
        };

        // Print the inputs
        $display("Input values:");
        for (int i = 0; i < 16; i++) begin
            $display("Input[%0d]: %0d", i, inputs[i]);
        end

        // Wait for the computation to complete
        #100;

        // Print the outputs
        $display("\nMagnitude outputs:");
        for (int i = 0; i < 16; i++) begin
            $display("Output[%0d]: %0d", i, magnitude_out[i]);
        end

        // End simulation
        $finish;
    end

endmodule
