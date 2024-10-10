module game (
    input logic clk, n, s, e, w, reset,
    output logic s6, win, s5, d, s4, s3, sw, s2, s1, s0, v
);

    // Internal signal to connect the Sword FSM output to the Room FSM input
    logic sword_active;

    // Instantiate the Room FSM
    room room_fsm (
        .clk(clk),
        .n(n),
        .s(s),
        .e(e),
        .w(w),
        .v(sword_active),  // Connect Sword FSM's output (v) to Room FSM's input
        .reset(reset),
        .s6(s6),
        .win(win),
        .s5(s5),
        .d(d),
        .s4(s4),
        .s3(s3),
        .sw(sw),
        .s2(s2),
        .s1(s1),
        .s0(s0)
    );

    // Instantiate the Sword FSM
    sword sword_fsm (
        .sw(sw),          // Room FSM output connected to Sword FSM input
        .reset(reset),
        .clk(clk),
        .v(sword_active)  // Sword FSM output connected to Room FSM input
    );

    // Assign the internal sword_active signal to the output v
    assign v = sword_active;

endmodule
