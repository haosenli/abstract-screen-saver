/* 
 * EE371 22SP Lab 6 - animation0_sound.sv
 * Authors: Haosen Li, Peter Tran
 *
 * Animation Sounds
 *
 * Top level module for animation0rom.v,
 * Reads through the mif file through the rom and returns the values read.
 */
module animation0_sound(input logic clk, reset, rd_wr_en,
								output logic [23:0] wdata_left, wdata_right);
    logic [14:0] address;
    logic [23:0] out;
    

    animation0rom rom (.address, .clock(clk), .q(out));

    always_ff @(posedge clk) begin
		  if (reset | (address == 15'd23999 & rd_wr_en))
				address <= 15'd0;
        else
            address <= address + 15'd1;
    end

    assign wdata_left = out;
    assign wdata_right = out;
endmodule // animation0_sound

`timescale 1 ps / 1 ps
module animation0_sound_testbench();
    logic clk, reset, rd_wr_en;
    logic [23:0] wdata_left, wdata_right;
    
    animation0_sound dut (.*);

    //simulated clock
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
		  reset <= 1; @(posedge clk);
		  reset <= 0; @(posedge clk);
        rd_wr_en <= 1; repeat(50)   @(posedge clk);
        $stop;
    end
endmodule // animation0_sound_testbench