module sword (
    input logic sw,    // Switch input
    input logic reset, // Reset signal
    input logic clk,   // Clock signal
    output logic v     // Output
);

    // Internal signals for state variables
    logic S1, S1_next;

    // Instantiate the D Flip-Flop for state S1
    d_ff dff_S1 (
        .d(S1_next),    // Next state logic
        .clk(clk),      // Clock input
        .q(S1)          // Current state output
    );

    // Next state logic for S1
    always_comb begin
        if (reset)
            S1_next = 0;               // Reset state
        else
            S1_next = S1 | (~S1 & sw); // Based on equation S1' = S1 + (~S1 & sw)
    end

    // Output logic based on S1
    assign v = S1;

endmodule