module d_ff (
    input logic d, clk,    // Input: d (data), clk (clock)
    output logic q         // Output: q (stored value)
);
    
    always @ (posedge clk) begin
        q <= d;            // On the rising edge of clk, q takes the value of d
    end
    
endmodule