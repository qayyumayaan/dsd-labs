module room (
    input logic clk, n, s, e, w, v, reset,
    output logic s6, win, s5, d, s4, s3, sw, s2, s1, s0
);

    // Internal signals for next states
    logic s0_next, s1_next, s2_next, s3_next, s4_next, s5_next, s6_next;

    // State flip-flops
    d_ff dff_S0 (.d(s0_next), .clk(clk), .q(s0));
    d_ff dff_S1 (.d(s1_next), .clk(clk), .q(s1));
    d_ff dff_S2 (.d(s2_next), .clk(clk), .q(s2));
    d_ff dff_S3 (.d(s3_next), .clk(clk), .q(s3));
    d_ff dff_S4 (.d(s4_next), .clk(clk), .q(s4));
    d_ff dff_S5 (.d(s5_next), .clk(clk), .q(s5));
    d_ff dff_S6 (.d(s6_next), .clk(clk), .q(s6));

    // Next state logic
    always_comb begin
        if (reset) begin
            s0_next = 1; // Assuming initial state is S0
            s1_next = 0;
            s2_next = 0;
            s3_next = 0;
            s4_next = 0;
            s5_next = 0;
            s6_next = 0;
        end else begin
            // State equations
            s0_next = (reset | (~reset & s1 & ~s & w) | (s0 & ~s1));
            s1_next = ((e & s0) | (~w & ~e & n & s2) | (~s2 & s1 & ~s0)) & ~reset;
            s2_next = ((s & s1 & ~w) | (e & s3) | (~s1 & s2 & ~s3 & ~s4)) & ~reset;
            s3_next = ((w & ~e & ~s & ~n & s2) | (~s2 & s3 & ~s4)) & ~reset;
            s4_next = (~w & e & s & ~n & s2 & ~reset);
            s5_next = ((~v & s4) | s5) & ~reset;
            s6_next = ((v & s4) | s6) & ~reset;
        end
    end

    // Output logic
    assign win = s6;
    assign d = s5;
    assign sw = s3;

endmodule
