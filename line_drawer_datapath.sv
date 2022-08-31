/* 
 * EE371 22SP Lab 5 - line_drawer_datapath.sv, May 18, 2022
 * Authors: Haosen Li, Peter Tran
 *
 * Task #2 -- Line-Drawing Algorithm, Datapath
 *
 */
module line_drawer_datapath(input  logic clk, reset, done, swap_x_y, x0_gt_x1, swap_0_1, 
							input  logic load_reg, prep_reg, incr_x, load_xy, load_yx, error_gt_0,
							input  logic [10:0] x0, y0, x1, y1, abs_x, abs_y,
							output logic [10:0] x, y, result_x, new_x0, new_x1,
							output logic signed [11:0] error);
	// intermediate registers		
	logic [10:0] new_y0, new_y1, result_y, delta_x, delta_y, newabs_y;
	logic y_step;
	
	// absolute value
	assign newabs_y = (new_y1 < new_y0) ? (new_y0 - new_y1) : (new_y1 - new_y0);

	// state logics			 
	always_ff @(posedge clk) begin
		if (load_reg) begin
			new_x0 <= x0;
			new_y0 <= y0;
			new_x1 <= x1;
			new_y1 <= y1;
		end
		if (swap_x_y) begin
			new_x0 <= y0;
			new_y0 <= x0;
			new_x1 <= y1;
			new_y1 <= x1;
		end
		if (swap_0_1) begin
			new_x0 <= new_x1;
			new_y0 <= new_y1;
			new_x1 <= new_x0;
			new_y1 <= new_y0;
		end
		if (prep_reg) begin
			delta_x <= new_x1 - new_x0;
			delta_y <= newabs_y;
			error <= -((new_x1 - new_x0)/2);
			result_y <= new_y0;
			y_step <= (new_y0 < new_y1) ? 1 : 0;
			result_x <= new_x0;
		end
		if (load_xy) begin
			x <= result_x;
			y <= result_y;
			error <= error + delta_y;
		end
		else if (load_yx) begin
			x <= result_y;
			y <= result_x;
			error <= error + delta_y;
		end
		if (error_gt_0) begin
			result_y <= (y_step) ? (result_y + 1'b1) : (result_y - 1'b1);
			error <= error - delta_x;
		end
		if (incr_x) begin
			result_x <= result_x + 1'b1;
		end
	end
									 
endmodule
