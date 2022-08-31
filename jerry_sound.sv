module jerry_sound(input logic clk, reset, rd_wr_en,
						 output logic [23:0] wdata_left, wdata_right);
    logic [14:0] address;
    logic [23:0] out;
    

    jerryrom rom (.address, .clock(clk), .q(out));

    always_ff @(posedge clk) begin
		  if (reset | (address == 15'd23999 & rd_wr_en))
				address <= 15'd0;
        else
            address <= address + 15'd1;
    end

    assign wdata_left = out;
    assign wdata_right = out;
endmodule // jerry_sound

`timescale 1 ps / 1 ps
module jerry_sound_testbench();
    logic clk, reset, rd_wr_en;
    logic [23:0] wdata_left, wdata_right;
    
    part2_1 dut (.*);

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
endmodule // jerry_sound_testbench