/* 
 * EE371 22SP Lab 5 - clear_screen.sv, May 18, 2022
 * Authors: Haosen Li, Peter Tran
 *
 * Task #3 -- Screen Clear
 *
 * Clears the entire VGA signal.
 * 
 */
 module clear_screen(input  logic clk, reset,
                     output logic done,
                     output logic [10:0] x, y);

    // iterate through every coordinate of the VGA signal
    always_ff @(posedge clk) begin
        // reset logic
        if (reset) begin
            done <= 1'b0;
            x <= 11'd0;
            y <= 11'd0;
        end
        // loop logic
        if (~done) begin
            if (x == 11'd640) begin
                x <= 11'd0;
                y <= y + 1'b1;
            end 
            else if (y == (11'd480 + 11'd1))
                done <= 1'b1;
            else
                x <= x + 1'b1;   
        end
    end

 endmodule // clear_screen


module clear_screen_testbench();
    logic clk, reset, done, color;
    logic [10:0] x, y;

    clear_screen dut(.*);

    // simulated clock
	parameter period = 100;
    initial begin
        clk <= 0;
        forever begin
            #(period/2)
            clk <= ~clk;
        end
    end

	// begin tests
	initial begin
        // Pre-test setup
        reset <= 1; @(posedge clk);
        // Test 1: clear screen
        // Expected: x, y should iterate through all coordinates of the VGA signal
        reset <= 0; repeat(100) @(posedge clk);
        $stop;
    end

endmodule // screen_clear_testbench
    