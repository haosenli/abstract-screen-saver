// Given a high signal for unknown amount of duration, output only true for one cycle
module trigger_fsm(input  logic clk, in,
                   output logic out);

    // state enumeration
    enum {S0, S1, S2} ps, ns;
    // state logic
    always_ff @(posedge clk) begin
        ps <= ns;
    end
    // ps, ns logic
    always_comb begin
        case (ps)
            S0: ns = (in) ? S1 : S0;
            S1: ns = S2;
            S2: ns = (in) ? S2 : S0;
        endcase
    end
    // assign output
    assign out = (ps == S1);

endmodule

