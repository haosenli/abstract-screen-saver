/* Given two points on the screen this module draws a line between
 * those two points by coloring necessary pixels
 *
 * Inputs:
 *   clk    - should be connected to a 50 MHz clock
 *   reset  - resets the module and starts over the drawing process
 *	 x0 	- x coordinate of the first end point
 *   y0 	- y coordinate of the first end point
 *   x1 	- x coordinate of the second end point
 *   y1 	- y coordinate of the second end point
 *
 * Outputs:
 *   x 		- x coordinate of the pixel to color
 *   y 		- y coordinate of the pixel to color
 *   done	- flag that line has finished drawing
 *
 */
module line_drawer(clk, reset, x0, y0, x1, y1, x, y, done);
	input logic clk, reset;
	input logic [10:0]	x0, y0, x1, y1;
	output logic done;
	output logic [10:0]	x, y;
	
	/* You'll need to create some registers to keep track of things
	 * such as error and direction.
	 */
	// intermediate registers
	logic [10:0] abs_x, abs_y, new_x0, new_y0, new_x1, new_y1, result_x, result_y;
	// registers specified in Bresenham's line algorithm pseudocode
	logic signed [11:0] error;
	logic [10:0] delta_x, delta_y;
	logic is_steep, y_step, swap_x_y, x0_gt_x1, swap_0_1, load_reg, prep_reg, incr_x, load_xy, load_yx, error_gt_0;
	// absolute values
	assign abs_x = (x0 > x1) ? (x0 - x1) : (x1 - x0);
	assign abs_y = (y0 > y1) ? (y0 - y1) : (y1 - y0);
	// control and datapath circuits
	line_drawer_control c_unit (.*);
	line_drawer_datapath d_unit (.*);
	
endmodule  // line_drawer


module line_drawer_testbench();
	logic clk, reset;
	logic [10:0] x0, y0, x1, y1;
	logic done;
	logic [10:0] x, y;

	line_drawer dut (.*);

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
		reset <= 0;														@(posedge clk);
		/*
		// TEST 1: Horiz. line
		// Expected: (0, 0) -> (10, 0)
		reset <= 1; x0 <= 0; y0 <= 0; x1 <= 10; y1 <= 0; 		@(posedge clk);
		reset <= 0;											repeat(64) 	@(posedge clk);
		
		// TEST 2: Horiz. line (reversed)
		// Expected: (10, 0) -> (0, 0)
		reset <= 1; x0 <= 10; y0 <= 0; x1 <= 0; y1 <= 0; 		@(posedge clk);
		reset <= 0;											repeat(64) 	@(posedge clk);
		
		// TEST 3: Shallow line
		// Expected: (0, 0) -> (10, 5)
		reset <= 1; x0 <= 0; y0 <= 0; x1 <= 10; y1 <= 5; 		@(posedge clk);
		reset <= 0;											repeat(64) 	@(posedge clk);
		
		// TEST 4: Shallow line (reversed)
		// Expected: (10, 5) -> (0, 0)  
		reset <= 1; x0 <= 10; y0 <= 5; x1 <= 0; y1 <= 0; 		@(posedge clk);
		reset <= 0;											repeat(64) 	@(posedge clk);
		
		// TEST 5: 45 deg line
		// Expected: (0, 0) -> (10, 10)
		reset <= 1; x0 <= 0; y0 <= 0; x1 <= 10; y1 <= 10; 		@(posedge clk);
		reset <= 0;											repeat(64) 	@(posedge clk);
		
		// TEST 6: 45 deg line (reversed)
		// Expected: (10, 10) -> (0, 0)
		reset <= 1; x0 <= 10; y0 <= 10; x1 <= 0; y1 <= 0; 		@(posedge clk);
		reset <= 0;											repeat(64) 	@(posedge clk);
		
		// TEST 7: Steep line
		// Expected: (0, 0) -> (5, 10)
		reset <= 1; x0 <= 0; y0 <= 0; x1 <= 5; y1 <= 10; 		@(posedge clk);
		reset <= 0;											repeat(64) 	@(posedge clk);
		
		// TEST 8: Steep line (reversed)
		// Expected: (5, 10) -> (0, 0)
		reset <= 1; x0 <= 5; y0 <= 10; x1 <= 0; y1 <= 0; 		@(posedge clk);
		reset <= 0;											repeat(64) 	@(posedge clk);
		
		// TEST 9: Vertical line
		// Expected: (0, 0) -> (0, 10)
		reset <= 1; x0 <= 0; y0 <= 0; x1 <= 0; y1 <= 10; 		@(posedge clk);
		reset <= 0;											repeat(64) 	@(posedge clk);
		
		// TEST 10: Vertical line (reversed)
		// Expected: (0, 0) -> (0, 10)
		reset <= 1; x0 <= 0; y0 <= 0; x1 <= 0; y1 <= 10; 		@(posedge clk);
		reset <= 0;											repeat(64) 	@(posedge clk);
		*/
		// TEST 10: Vertical line (reversed)
		// Expected: (0, 0) -> (0, 10)
		reset <= 1; x0 <= 0; y0 <= 200; x1 <= 50; y1 <= 190; 		@(posedge clk);
		reset <= 0;											repeat(200) 	@(posedge clk);
		$stop;
	end
endmodule // line_drawer_testbench