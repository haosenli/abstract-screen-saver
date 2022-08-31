/* 
 * Line-Drawing Algorithm, Control
 *
 */
module line_drawer_control(clk, reset, x0, y0, x1, y1, result_x, new_x0, new_x1, error, abs_x, abs_y,
						   done, load_reg, swap_x_y, x0_gt_x1, swap_0_1, prep_reg, incr_x, 
						   error_gt_0, load_xy, load_yx);
	input logic clk, reset;
	input logic [10:0]	x0, y0, x1, y1, result_x, new_x0, new_x1, abs_x, abs_y;
	input logic signed [11:0] error;
	output logic done, load_reg, swap_x_y, x0_gt_x1, swap_0_1, prep_reg, incr_x, load_xy, load_yx, error_gt_0;
	
	/* You'll need to create some registers to keep track of things
	 * such as error and direction.
	 */
	// registers specified in Bresenham's line algorithm pseudocode
	logic is_steep, end_for;
	
	// state declaration
	enum {s_load, s_wait0, s_wait1, s_draw, s_wait2, s_done} ps, ns;

	// reset and state logic
	always_ff @(posedge clk) begin
		if (reset) ps <= s_load;
		else ps <= ns;
	end

	// ps, ns logic
	always_comb begin
		case (ps)
			s_load: ns = s_wait0;
			s_wait0: ns = s_wait1;
			s_wait1: ns = s_draw;
			s_draw: ns = (end_for) ? s_done : s_wait2;
			s_wait2: ns = s_draw;
			s_done: ns = s_done;
		endcase
	end
	
	assign is_steep = abs_y > abs_x;
	assign end_for  = result_x == new_x1;
	assign load_reg = (ps == s_load);
	assign swap_x_y = (ps == s_load) && is_steep;
	assign x0_gt_x1 = new_x0 > new_x1;
	assign swap_0_1 = (ps == s_wait0) && x0_gt_x1;
	assign prep_reg = (ps == s_wait1);
	assign incr_x   = (ps == s_wait2) && ~(end_for);
	assign load_xy  = (ps == s_draw) && ~is_steep;
	assign load_yx  = (ps == s_draw) && is_steep;
	assign error_gt_0 = (ps == s_wait2) && (error >= 0);
	assign done     = (ps == s_done);
	
endmodule
