/* Top level module of the FPGA that takes the onboard resources 
 * as input and outputs the lines drawn from the VGA port.
 *
 * Inputs:
 *   KEY 			- On board keys of the FPGA
 *   SW 			- On board switches of the FPGA
 *   CLOCK_50 		- On board 50 MHz clock of the FPGA
 *
 * Outputs:
 *   HEX 			- On board 7 segment displays of the FPGA
 *   LEDR 			- On board LEDs of the FPGA
 *   VGA_R 			- Red data of the VGA connection
 *   VGA_G 			- Green data of the VGA connection
 *   VGA_B 			- Blue data of the VGA connection
 *   VGA_BLANK_N 	- Blanking interval of the VGA connection
 *   VGA_CLK 		- VGA's clock signal
 *   VGA_HS 		- Horizontal Sync of the VGA connection
 *   VGA_SYNC_N 	- Enable signal for the sync of the VGA connection
 *   VGA_VS 		- Vertical Sync of the VGA connection
 */

	module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50, 
	VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS,
	CLOCK2_50, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, AUD_DACLRCK, AUD_ADCLRCK, 
	AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	input CLOCK_50, CLOCK2_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	assign LEDR[0] = SW[0];
	
	logic [10:0] x0, y0, x1, y1, x, y;
	logic [10:0] an0_x, an0_y, an1_x, an1_y, an2_x, an2_y;
	logic color, color0, color1, color2;
	
	VGA_framebuffer fb (
		.clk50			(CLOCK_50), 
		.reset			(1'b0), 
		.x, 
		.y,
		.pixel_color	(color), 
		.pixel_write	(1'b1),
		.VGA_R, 
		.VGA_G, 
		.VGA_B, 
		.VGA_CLK, 
		.VGA_HS, 
		.VGA_VS,
		.VGA_BLANK_n	(VGA_BLANK_N), 
		.VGA_SYNC_n		(VGA_SYNC_N));
				
	logic done;
	logic KEY1_IN, KEY2_IN, KEY1_OUT, KEY2_OUT, next, back;
	
	// Metastability
	always_ff @(posedge CLOCK_50) begin
		KEY1_IN <= ~KEY[1];
		KEY2_IN <= ~KEY[2];
		KEY1_OUT <= KEY1_IN;
		KEY2_OUT <= KEY2_IN;
	end
	
	// Makes sure the key doesn't get held down
	trigger_fsm key1 (.clk(CLOCK_50), .in(KEY1_OUT), .out(next));
	trigger_fsm key2 (.clk(CLOCK_50), .in(KEY2_OUT), .out(back));
	
	// select sound to play
	always_ff @(posedge CLOCK_50) begin
		if (SW[0])
			sound <= 2'd0;
		if (next)
			if (sound == 2'd2)
				sound <= 2'd0;
			else
				sound <= sound + 2'b1;
		if (back)
			if (sound == 2'd0)
				sound <= 2'd3;
			else
				sound <= sound - 2'b1;
	end

	// select gif to play
	always_comb begin
		if (sound == 2'd0) begin
			x = an0_x;
			y = an0_y;
			color = color0;
		end
		else if (sound == 2'd1) begin
			x = an1_x;
			y = an1_y;
			color = color1;
		end
		else begin
			x = an2_x;
			y = an2_y;
			color = color2;
		end
	end

	animation0 anime0 (.clk(CLOCK_50), .reset(SW[0]), .new_clk(max_counter), .x(an0_x), .y(an0_y),
							 .color(color0), .*); 
	animation1 anime1 (.clk(CLOCK_50), .reset(SW[0]), .new_clk(max_counter), .x(an1_x), .y(an1_y),
							 .color(color1), .*); 
	animation2 anime2 (.clk(CLOCK_50), .reset(SW[0]), .new_clk(max_counter), .x(an2_x), .y(an2_y),
							 .color(color2), .*);

	
	/* Audio Top-Level */
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	
	// Local wires
	logic read_ready, write_ready, read, write, rd_wr_en;
	logic signed [23:0] readdata_left, readdata_right;
	logic signed [23:0] writedata_left, writedata_right;
	logic signed [23:0] animation0_left, animation0_right, animation1_left, animation1_right;
	logic signed [23:0] animation2_left, animation2_right;
	logic reset;
	
	logic [1:0] sound;
	
	animation0_sound animate0 (.clk(CLOCK_50), .reset(SW[9]), .rd_wr_en, .wdata_left(animation0_left),
										.wdata_right(animation0_right));
										
	animation1_sound animate1 (.clk(CLOCK_50), .reset(SW[9]), .rd_wr_en, .wdata_left(animation1_left),
										.wdata_right(animation1_right));
										
	animation2_sound animate2 (.clk(CLOCK_50), .reset(SW[9]), .rd_wr_en, .wdata_left(animation2_left),
										.wdata_right(animation2_right));
	
	always_comb begin
		case(sound)
			2'b00: begin // Plays animation0 sound
				writedata_left = animation0_left;
				writedata_right = animation0_right;
			end
			2'b01: begin // Plays animation1 sound
				writedata_left = animation1_left;
				writedata_right = animation1_right;
			end
			2'b10: begin // Plays animation2 sound
				writedata_left = animation2_left;
				writedata_right = animation2_right;
			end
			default: begin // default output raw data
				writedata_left = readdata_left;
				writedata_right = readdata_right;
			end
		endcase
	end
	
	// only read or write when both are possible
	assign read = read_ready & write_ready;
	assign write = read_ready & write_ready;
	assign rd_wr_en = read & write;
	
/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following wires:
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		1'b0,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		1'b0,

		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		// Inputs
		CLOCK_50,
		1'b0,

		read,	write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);
	
	
	logic [27:0] max_counter;
	logic [2:0] speed;
	logic KEY3_IN, KEY0_IN, KEY3_OUT, KEY0_OUT, fast_forward, slow_down;
	
	// Defines how fast the animations get drawn.
	always_comb begin
		case(speed)
			3'b000: max_counter = 28'd200000000;
			3'b001: max_counter = 28'd100000000;
			3'b010: max_counter = 28'd50000000;
			3'b011: max_counter = 28'd25000000;
			3'b100: max_counter = 28'd1250000;
			default: max_counter = 28'd50000000;
		endcase
	end
	
	// Defines how fast the animations get drawn.
	always_ff @(posedge CLOCK_50) begin
		if (SW[0])
			speed <= 3'd2;
		if (fast_forward && (speed < 3'd6))
			speed <= speed + 3'b1;
		if (slow_down && (speed > 3'd0))
			speed <= speed - 3'b1;
	end
	
	// Metastability
	always_ff @(posedge CLOCK_50) begin
		KEY3_IN <= ~KEY[3];
		KEY0_IN <= ~KEY[0];
		KEY3_OUT <= KEY3_IN;
		KEY0_OUT <= KEY0_IN;
	end
	
	// Makes sure the key doesn't get held down.
	trigger_fsm key0 (.clk(CLOCK_50), .in(KEY0_OUT), .out(fast_forward));
	trigger_fsm key3 (.clk(CLOCK_50), .in(KEY3_OUT), .out(slow_down));
	
endmodule  // DE1_SoC

module DE1_SoC_testbench();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	logic CLOCK_50, CLOCK2_50;
	logic [7:0] VGA_R;
	logic [7:0] VGA_G;
	logic [7:0] VGA_B;
	logic VGA_BLANK_N;
	logic VGA_CLK;
	logic VGA_HS;
	logic VGA_SYNC_N;
	logic VGA_VS;
	logic FPGA_I2C_SCLK;
	logic FPGA_I2C_SDAT;
	logic AUD_XCK;
	logic AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	logic AUD_ADCDAT;
	logic AUD_DACDAT;
	logic [10:0] x, y, an0_x, an0_y, an1_x, an1_y, an2_x, an2_y;
	logic [27:0] max_counter;
	logic [2:0] speed;
	logic [1:0] sound;
	logic next, back, fast_forward, slow_down;
	logic [23:0] animation0_left, animation0_right, animation1_left, animation1_right;
	logic [23:0] writedata_left, writedata_right, animation2_left, animation2_right;
	
	DE1_SoC dut (.*);
	
	//simulated clock
    parameter period = 100;
	 logic clk;
    initial begin
        clk <= 0;
        forever begin
            #(period/2)
            clk <= ~CLOCK_50;
        end
    end

    // begin tests
    initial begin
	 // Pre-Setup
			SW[0] <= 1; max_counter <= 28'd0; speed <= 3'd0; sound <= 2'b0; KEY[3:0] <= 1; @(posedge clk);
			SW[0] <= 0;																							 @(posedge clk);
			
	// Test 1: Check if max_counter/speed changes
			fast_forward <= 0; slow_down <= 0; 															 @(posedge clk);
			fast_forward <= 1; repeat(5)																 	 @(posedge clk);
			fast_forward <= 0; slow_down <= 1; repeat(10)											 @(posedge clk);

	// Test 2: Check if sound and writedata_left/writedata_right changes
			writedata_left <= 0; writedata_right <= 0; animation0_left <= 24'd1; animation0_right <= 24'd1;
			animation1_left <= 24'd2; animation1_right <= 24'd2; animation2_left <= 24'd3;
			animation2_right <= 24'd3; x <= 0; y <= 0; an0_x <= 11'd1; an0_y <= 11'd1; 
			an1_x <= 11'd2; an1_y <= 11'd2; an2_x <= 11'd3; an2_y <= 11'd3;    @(posedge clk);
			
			next <= 0; back <= 0; 															 @(posedge clk);
			next <= 1; repeat(5)																 @(posedge clk);
			next <= 0; back <= 1; repeat(10)											 	 @(posedge clk);
			
			$stop;
	 end
endmodule

			
