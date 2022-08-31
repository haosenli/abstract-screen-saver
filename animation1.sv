/* 
 * EE371 22SP Lab 6 - animation.sv
 * Authors: Haosen Li, Peter Tran
 *
 * Animation
 *
 * Top level module for line_drawer.sv and clear_screen.sv,
 * creates an animation using the two modules.
 * 
 */
module animation1(input  logic clk, reset,
                 input  logic [27:0] new_clk,
                 output logic color,
                 output logic [10:0] x, y);

    // 26'd50000000 represents 1 second of delay
    logic [27:0] delay_counter;
    logic frame_counter; // tracks which frame to draw out
    logic [11:0] lines_counter; // edit if needed
    logic frame_complete, reset_start;
    // inputs to submodules, manipulate these values
    logic [10:0] x0, y0, x1, y1;
    logic [10:0] x0_pre, y0_pre, x1_pre, y1_pre, y_offset, x_offset;
    logic lines_start, clear_start;
    // outputs from submodules, no need to manipulate
    logic [10:0] lines_x, lines_y, clear_x, clear_y;
    logic lines_done, clear_done, flip_x, flip_y;

    // instantiate modules
    line_drawer lines(.x(lines_x), .y(lines_y), .reset(lines_start), .done(lines_done), .*);
    clear_screen clear(.x(clear_x), .y(clear_y), .reset(clear_start), .done(clear_done), .*);
    trigger_fsm r_trigger(.in(reset), .out(reset_start), .*);

    // x & y outputs depends on pixel color
    assign x = (color == 1'd1) ? lines_x : clear_x;
    assign y = (color == 1'd1) ? lines_y : clear_y;
    assign x0 = (x0_pre + x_offset) % 640;
    assign y0 = (y0_pre + y_offset) % 480;
    assign x1 = (x1_pre + x_offset) % 640;
    assign y1 = (y1_pre + y_offset) % 480;
    
    always_ff @(posedge clk) begin
        // reset registers
        if (reset) begin
            frame_complete <= 1'd0;
            delay_counter <= 0;
            frame_counter <= 1'd0;
            lines_counter <= 0; // edit this to include more lines
            color <= 1'd0; // black
            x0_pre <= 11'd0;
            y0_pre <= 11'd0;
            x1_pre <= 11'd0;
            y1_pre <= 11'd0;
            x_offset <= 0;
            y_offset <= 0;
        end
        
        if (reset_start) begin
            lines_start <= 1'd1;
            clear_start <= 1'd1;
        end

        // ensures the start signals are only on for one cycle
        if (lines_start == 1'b1)
            lines_start <= 1'b0;
        if (clear_start == 1'b1)
            clear_start <= 1'b0;

        
        /* === FRAMES PER SECOND CONTROL === */
        if (~reset) begin
            // frame delay logic
            if (delay_counter == new_clk) begin
                // increment counters after delay
                // frame_counter <= frame_counter + 1'd1;
                frame_complete <= 0;
                delay_counter <= 0;
                // clear drawing every 1 second
                clear_start <= 1;
                color <= 0; // black
            end else
                // increment delay counter
                delay_counter <= delay_counter + 26'd1;
        end

        /* === ANIMATION === */
		if (~frame_complete && clear_done && ~reset && ~clear_start) begin
			color <= 1;
			if (~lines_start && lines_counter == 0 && lines_done) begin
				x0_pre <= 11'd371;
				y0_pre <= 11'd238;
				x1_pre <= 11'd417;
				y1_pre <= 11'd146;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 1 && lines_done) begin
				x0_pre <= 11'd417;
				y0_pre <= 11'd146;
				x1_pre <= 11'd325;
				y1_pre <= 11'd146;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 2 && lines_done) begin
				x0_pre <= 11'd325;
				y0_pre <= 11'd146;
				x1_pre <= 11'd371;
				y1_pre <= 11'd238;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 3 && lines_done) begin
				x0_pre <= 11'd419;
				y0_pre <= 11'd232;
				x1_pre <= 11'd451;
				y1_pre <= 11'd296;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 4 && lines_done) begin
				x0_pre <= 11'd451;
				y0_pre <= 11'd296;
				x1_pre <= 11'd387;
				y1_pre <= 11'd296;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 5 && lines_done) begin
				x0_pre <= 11'd387;
				y0_pre <= 11'd296;
				x1_pre <= 11'd419;
				y1_pre <= 11'd232;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 6 && lines_done) begin
				x0_pre <= 11'd395;
				y0_pre <= 11'd241;
				x1_pre <= 11'd416;
				y1_pre <= 11'd284;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 7 && lines_done) begin
				x0_pre <= 11'd416;
				y0_pre <= 11'd284;
				x1_pre <= 11'd374;
				y1_pre <= 11'd284;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 8 && lines_done) begin
				x0_pre <= 11'd374;
				y0_pre <= 11'd284;
				x1_pre <= 11'd395;
				y1_pre <= 11'd241;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 9 && lines_done) begin
				x0_pre <= 11'd208;
				y0_pre <= 11'd290;
				x1_pre <= 11'd223;
				y1_pre <= 11'd260;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 10 && lines_done) begin
				x0_pre <= 11'd223;
				y0_pre <= 11'd260;
				x1_pre <= 11'd193;
				y1_pre <= 11'd260;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 11 && lines_done) begin
				x0_pre <= 11'd193;
				y0_pre <= 11'd260;
				x1_pre <= 11'd208;
				y1_pre <= 11'd290;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 12 && lines_done) begin
				x0_pre <= 11'd272;
				y0_pre <= 11'd121;
				x1_pre <= 11'd289;
				y1_pre <= 11'd156;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 13 && lines_done) begin
				x0_pre <= 11'd289;
				y0_pre <= 11'd156;
				x1_pre <= 11'd255;
				y1_pre <= 11'd156;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 14 && lines_done) begin
				x0_pre <= 11'd255;
				y0_pre <= 11'd156;
				x1_pre <= 11'd272;
				y1_pre <= 11'd121;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 15 && lines_done) begin
				x0_pre <= 11'd156;
				y0_pre <= 11'd176;
				x1_pre <= 11'd176;
				y1_pre <= 11'd217;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 16 && lines_done) begin
				x0_pre <= 11'd176;
				y0_pre <= 11'd217;
				x1_pre <= 11'd136;
				y1_pre <= 11'd217;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 17 && lines_done) begin
				x0_pre <= 11'd136;
				y0_pre <= 11'd217;
				x1_pre <= 11'd156;
				y1_pre <= 11'd176;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 18 && lines_done) begin
				x0_pre <= 11'd102;
				y0_pre <= 11'd143;
				x1_pre <= 11'd117;
				y1_pre <= 11'd174;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 19 && lines_done) begin
				x0_pre <= 11'd117;
				y0_pre <= 11'd174;
				x1_pre <= 11'd87;
				y1_pre <= 11'd174;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 20 && lines_done) begin
				x0_pre <= 11'd87;
				y0_pre <= 11'd174;
				x1_pre <= 11'd102;
				y1_pre <= 11'd143;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 21 && lines_done) begin
				x0_pre <= 11'd257;
				y0_pre <= 11'd166;
				x1_pre <= 11'd273;
				y1_pre <= 11'd198;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 22 && lines_done) begin
				x0_pre <= 11'd273;
				y0_pre <= 11'd198;
				x1_pre <= 11'd241;
				y1_pre <= 11'd198;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 23 && lines_done) begin
				x0_pre <= 11'd241;
				y0_pre <= 11'd198;
				x1_pre <= 11'd257;
				y1_pre <= 11'd166;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 24 && lines_done) begin
				x0_pre <= 11'd337;
				y0_pre <= 11'd166;
				x1_pre <= 11'd380;
				y1_pre <= 11'd80;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 25 && lines_done) begin
				x0_pre <= 11'd380;
				y0_pre <= 11'd80;
				x1_pre <= 11'd294;
				y1_pre <= 11'd80;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 26 && lines_done) begin
				x0_pre <= 11'd294;
				y0_pre <= 11'd80;
				x1_pre <= 11'd337;
				y1_pre <= 11'd166;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 27 && lines_done) begin
				x0_pre <= 11'd264;
				y0_pre <= 11'd113;
				x1_pre <= 11'd310;
				y1_pre <= 11'd206;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 28 && lines_done) begin
				x0_pre <= 11'd310;
				y0_pre <= 11'd206;
				x1_pre <= 11'd218;
				y1_pre <= 11'd206;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 29 && lines_done) begin
				x0_pre <= 11'd218;
				y0_pre <= 11'd206;
				x1_pre <= 11'd264;
				y1_pre <= 11'd113;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 30 && lines_done) begin
				x0_pre <= 11'd467;
				y0_pre <= 11'd111;
				x1_pre <= 11'd517;
				y1_pre <= 11'd211;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 31 && lines_done) begin
				x0_pre <= 11'd517;
				y0_pre <= 11'd211;
				x1_pre <= 11'd417;
				y1_pre <= 11'd211;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 32 && lines_done) begin
				x0_pre <= 11'd417;
				y0_pre <= 11'd211;
				x1_pre <= 11'd467;
				y1_pre <= 11'd111;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 33 && lines_done) begin
				x0_pre <= 11'd377;
				y0_pre <= 11'd315;
				x1_pre <= 11'd424;
				y1_pre <= 11'd410;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 34 && lines_done) begin
				x0_pre <= 11'd424;
				y0_pre <= 11'd410;
				x1_pre <= 11'd330;
				y1_pre <= 11'd410;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 35 && lines_done) begin
				x0_pre <= 11'd330;
				y0_pre <= 11'd410;
				x1_pre <= 11'd377;
				y1_pre <= 11'd315;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 36 && lines_done) begin
				x0_pre <= 11'd225;
				y0_pre <= 11'd273;
				x1_pre <= 11'd241;
				y1_pre <= 11'd240;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 37 && lines_done) begin
				x0_pre <= 11'd241;
				y0_pre <= 11'd240;
				x1_pre <= 11'd209;
				y1_pre <= 11'd240;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 38 && lines_done) begin
				x0_pre <= 11'd209;
				y0_pre <= 11'd240;
				x1_pre <= 11'd225;
				y1_pre <= 11'd273;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 39 && lines_done) begin
				x0_pre <= 11'd130;
				y0_pre <= 11'd270;
				x1_pre <= 11'd174;
				y1_pre <= 11'd359;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 40 && lines_done) begin
				x0_pre <= 11'd174;
				y0_pre <= 11'd359;
				x1_pre <= 11'd86;
				y1_pre <= 11'd359;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 41 && lines_done) begin
				x0_pre <= 11'd86;
				y0_pre <= 11'd359;
				x1_pre <= 11'd130;
				y1_pre <= 11'd270;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 42 && lines_done) begin
				x0_pre <= 11'd286;
				y0_pre <= 11'd199;
				x1_pre <= 11'd328;
				y1_pre <= 11'd284;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 43 && lines_done) begin
				x0_pre <= 11'd328;
				y0_pre <= 11'd284;
				x1_pre <= 11'd244;
				y1_pre <= 11'd284;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 44 && lines_done) begin
				x0_pre <= 11'd244;
				y0_pre <= 11'd284;
				x1_pre <= 11'd286;
				y1_pre <= 11'd199;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 45 && lines_done) begin
				x0_pre <= 11'd349;
				y0_pre <= 11'd137;
				x1_pre <= 11'd369;
				y1_pre <= 11'd97;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 46 && lines_done) begin
				x0_pre <= 11'd369;
				y0_pre <= 11'd97;
				x1_pre <= 11'd329;
				y1_pre <= 11'd97;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 47 && lines_done) begin
				x0_pre <= 11'd329;
				y0_pre <= 11'd97;
				x1_pre <= 11'd349;
				y1_pre <= 11'd137;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 48 && lines_done) begin
				x0_pre <= 11'd481;
				y0_pre <= 11'd223;
				x1_pre <= 11'd509;
				y1_pre <= 11'd280;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 49 && lines_done) begin
				x0_pre <= 11'd509;
				y0_pre <= 11'd280;
				x1_pre <= 11'd453;
				y1_pre <= 11'd280;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 50 && lines_done) begin
				x0_pre <= 11'd453;
				y0_pre <= 11'd280;
				x1_pre <= 11'd481;
				y1_pre <= 11'd223;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 51 && lines_done) begin
				x0_pre <= 11'd448;
				y0_pre <= 11'd133;
				x1_pre <= 11'd492;
				y1_pre <= 11'd222;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 52 && lines_done) begin
				x0_pre <= 11'd492;
				y0_pre <= 11'd222;
				x1_pre <= 11'd404;
				y1_pre <= 11'd222;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 53 && lines_done) begin
				x0_pre <= 11'd404;
				y0_pre <= 11'd222;
				x1_pre <= 11'd448;
				y1_pre <= 11'd133;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 54 && lines_done) begin
				x0_pre <= 11'd280;
				y0_pre <= 11'd141;
				x1_pre <= 11'd303;
				y1_pre <= 11'd188;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 55 && lines_done) begin
				x0_pre <= 11'd303;
				y0_pre <= 11'd188;
				x1_pre <= 11'd257;
				y1_pre <= 11'd188;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 56 && lines_done) begin
				x0_pre <= 11'd257;
				y0_pre <= 11'd188;
				x1_pre <= 11'd280;
				y1_pre <= 11'd141;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 57 && lines_done) begin
				x0_pre <= 11'd221;
				y0_pre <= 11'd124;
				x1_pre <= 11'd237;
				y1_pre <= 11'd91;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 58 && lines_done) begin
				x0_pre <= 11'd237;
				y0_pre <= 11'd91;
				x1_pre <= 11'd205;
				y1_pre <= 11'd91;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 59 && lines_done) begin
				x0_pre <= 11'd205;
				y0_pre <= 11'd91;
				x1_pre <= 11'd221;
				y1_pre <= 11'd124;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 60 && lines_done) begin
				x0_pre <= 11'd173;
				y0_pre <= 11'd203;
				x1_pre <= 11'd221;
				y1_pre <= 11'd106;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 61 && lines_done) begin
				x0_pre <= 11'd221;
				y0_pre <= 11'd106;
				x1_pre <= 11'd125;
				y1_pre <= 11'd106;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 62 && lines_done) begin
				x0_pre <= 11'd125;
				y0_pre <= 11'd106;
				x1_pre <= 11'd173;
				y1_pre <= 11'd203;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 63 && lines_done) begin
				x0_pre <= 11'd300;
				y0_pre <= 11'd153;
				x1_pre <= 11'd341;
				y1_pre <= 11'd71;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 64 && lines_done) begin
				x0_pre <= 11'd341;
				y0_pre <= 11'd71;
				x1_pre <= 11'd259;
				y1_pre <= 11'd71;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 65 && lines_done) begin
				x0_pre <= 11'd259;
				y0_pre <= 11'd71;
				x1_pre <= 11'd300;
				y1_pre <= 11'd153;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 66 && lines_done) begin
				x0_pre <= 11'd464;
				y0_pre <= 11'd172;
				x1_pre <= 11'd497;
				y1_pre <= 11'd239;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 67 && lines_done) begin
				x0_pre <= 11'd497;
				y0_pre <= 11'd239;
				x1_pre <= 11'd431;
				y1_pre <= 11'd239;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 68 && lines_done) begin
				x0_pre <= 11'd431;
				y0_pre <= 11'd239;
				x1_pre <= 11'd464;
				y1_pre <= 11'd172;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 69 && lines_done) begin
				x0_pre <= 11'd114;
				y0_pre <= 11'd311;
				x1_pre <= 11'd135;
				y1_pre <= 11'd269;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 70 && lines_done) begin
				x0_pre <= 11'd135;
				y0_pre <= 11'd269;
				x1_pre <= 11'd93;
				y1_pre <= 11'd269;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 71 && lines_done) begin
				x0_pre <= 11'd93;
				y0_pre <= 11'd269;
				x1_pre <= 11'd114;
				y1_pre <= 11'd311;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 72 && lines_done) begin
				x0_pre <= 11'd424;
				y0_pre <= 11'd198;
				x1_pre <= 11'd460;
				y1_pre <= 11'd125;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 73 && lines_done) begin
				x0_pre <= 11'd460;
				y0_pre <= 11'd125;
				x1_pre <= 11'd388;
				y1_pre <= 11'd125;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 74 && lines_done) begin
				x0_pre <= 11'd388;
				y0_pre <= 11'd125;
				x1_pre <= 11'd424;
				y1_pre <= 11'd198;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 75 && lines_done) begin
				x0_pre <= 11'd380;
				y0_pre <= 11'd241;
				x1_pre <= 11'd402;
				y1_pre <= 11'd196;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 76 && lines_done) begin
				x0_pre <= 11'd402;
				y0_pre <= 11'd196;
				x1_pre <= 11'd358;
				y1_pre <= 11'd196;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 77 && lines_done) begin
				x0_pre <= 11'd358;
				y0_pre <= 11'd196;
				x1_pre <= 11'd380;
				y1_pre <= 11'd241;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 78 && lines_done) begin
				x0_pre <= 11'd138;
				y0_pre <= 11'd202;
				x1_pre <= 11'd163;
				y1_pre <= 11'd151;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 79 && lines_done) begin
				x0_pre <= 11'd163;
				y0_pre <= 11'd151;
				x1_pre <= 11'd113;
				y1_pre <= 11'd151;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 80 && lines_done) begin
				x0_pre <= 11'd113;
				y0_pre <= 11'd151;
				x1_pre <= 11'd138;
				y1_pre <= 11'd202;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 81 && lines_done) begin
				x0_pre <= 11'd227;
				y0_pre <= 11'd159;
				x1_pre <= 11'd264;
				y1_pre <= 11'd84;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 82 && lines_done) begin
				x0_pre <= 11'd264;
				y0_pre <= 11'd84;
				x1_pre <= 11'd190;
				y1_pre <= 11'd84;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 83 && lines_done) begin
				x0_pre <= 11'd190;
				y0_pre <= 11'd84;
				x1_pre <= 11'd227;
				y1_pre <= 11'd159;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 84 && lines_done) begin
				x0_pre <= 11'd311;
				y0_pre <= 11'd283;
				x1_pre <= 11'd329;
				y1_pre <= 11'd246;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 85 && lines_done) begin
				x0_pre <= 11'd329;
				y0_pre <= 11'd246;
				x1_pre <= 11'd293;
				y1_pre <= 11'd246;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 86 && lines_done) begin
				x0_pre <= 11'd293;
				y0_pre <= 11'd246;
				x1_pre <= 11'd311;
				y1_pre <= 11'd283;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 87 && lines_done) begin
				x0_pre <= 11'd251;
				y0_pre <= 11'd190;
				x1_pre <= 11'd266;
				y1_pre <= 11'd159;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 88 && lines_done) begin
				x0_pre <= 11'd266;
				y0_pre <= 11'd159;
				x1_pre <= 11'd236;
				y1_pre <= 11'd159;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 89 && lines_done) begin
				x0_pre <= 11'd236;
				y0_pre <= 11'd159;
				x1_pre <= 11'd251;
				y1_pre <= 11'd190;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 90 && lines_done) begin
				x0_pre <= 11'd276;
				y0_pre <= 11'd237;
				x1_pre <= 11'd309;
				y1_pre <= 11'd303;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 91 && lines_done) begin
				x0_pre <= 11'd309;
				y0_pre <= 11'd303;
				x1_pre <= 11'd243;
				y1_pre <= 11'd303;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 92 && lines_done) begin
				x0_pre <= 11'd243;
				y0_pre <= 11'd303;
				x1_pre <= 11'd276;
				y1_pre <= 11'd237;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 93 && lines_done) begin
				x0_pre <= 11'd102;
				y0_pre <= 11'd139;
				x1_pre <= 11'd118;
				y1_pre <= 11'd106;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 94 && lines_done) begin
				x0_pre <= 11'd118;
				y0_pre <= 11'd106;
				x1_pre <= 11'd86;
				y1_pre <= 11'd106;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 95 && lines_done) begin
				x0_pre <= 11'd86;
				y0_pre <= 11'd106;
				x1_pre <= 11'd102;
				y1_pre <= 11'd139;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 96 && lines_done) begin
				x0_pre <= 11'd112;
				y0_pre <= 11'd166;
				x1_pre <= 11'd129;
				y1_pre <= 11'd132;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 97 && lines_done) begin
				x0_pre <= 11'd129;
				y0_pre <= 11'd132;
				x1_pre <= 11'd95;
				y1_pre <= 11'd132;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 98 && lines_done) begin
				x0_pre <= 11'd95;
				y0_pre <= 11'd132;
				x1_pre <= 11'd112;
				y1_pre <= 11'd166;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 99 && lines_done) begin
				x0_pre <= 11'd321;
				y0_pre <= 11'd109;
				x1_pre <= 11'd336;
				y1_pre <= 11'd140;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 100 && lines_done) begin
				x0_pre <= 11'd336;
				y0_pre <= 11'd140;
				x1_pre <= 11'd306;
				y1_pre <= 11'd140;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 101 && lines_done) begin
				x0_pre <= 11'd306;
				y0_pre <= 11'd140;
				x1_pre <= 11'd321;
				y1_pre <= 11'd109;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 102 && lines_done) begin
				x0_pre <= 11'd479;
				y0_pre <= 11'd227;
				x1_pre <= 11'd518;
				y1_pre <= 11'd149;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 103 && lines_done) begin
				x0_pre <= 11'd518;
				y0_pre <= 11'd149;
				x1_pre <= 11'd440;
				y1_pre <= 11'd149;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 104 && lines_done) begin
				x0_pre <= 11'd440;
				y0_pre <= 11'd149;
				x1_pre <= 11'd479;
				y1_pre <= 11'd227;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 105 && lines_done) begin
				x0_pre <= 11'd345;
				y0_pre <= 11'd167;
				x1_pre <= 11'd371;
				y1_pre <= 11'd219;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 106 && lines_done) begin
				x0_pre <= 11'd371;
				y0_pre <= 11'd219;
				x1_pre <= 11'd319;
				y1_pre <= 11'd219;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 107 && lines_done) begin
				x0_pre <= 11'd319;
				y0_pre <= 11'd219;
				x1_pre <= 11'd345;
				y1_pre <= 11'd167;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 108 && lines_done) begin
				x0_pre <= 11'd334;
				y0_pre <= 11'd279;
				x1_pre <= 11'd362;
				y1_pre <= 11'd223;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 109 && lines_done) begin
				x0_pre <= 11'd362;
				y0_pre <= 11'd223;
				x1_pre <= 11'd306;
				y1_pre <= 11'd223;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 110 && lines_done) begin
				x0_pre <= 11'd306;
				y0_pre <= 11'd223;
				x1_pre <= 11'd334;
				y1_pre <= 11'd279;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 111 && lines_done) begin
				x0_pre <= 11'd449;
				y0_pre <= 11'd188;
				x1_pre <= 11'd464;
				y1_pre <= 11'd219;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 112 && lines_done) begin
				x0_pre <= 11'd464;
				y0_pre <= 11'd219;
				x1_pre <= 11'd434;
				y1_pre <= 11'd219;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 113 && lines_done) begin
				x0_pre <= 11'd434;
				y0_pre <= 11'd219;
				x1_pre <= 11'd449;
				y1_pre <= 11'd188;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 114 && lines_done) begin
				x0_pre <= 11'd168;
				y0_pre <= 11'd170;
				x1_pre <= 11'd192;
				y1_pre <= 11'd219;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 115 && lines_done) begin
				x0_pre <= 11'd192;
				y0_pre <= 11'd219;
				x1_pre <= 11'd144;
				y1_pre <= 11'd219;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 116 && lines_done) begin
				x0_pre <= 11'd144;
				y0_pre <= 11'd219;
				x1_pre <= 11'd168;
				y1_pre <= 11'd170;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 117 && lines_done) begin
				x0_pre <= 11'd280;
				y0_pre <= 11'd175;
				x1_pre <= 11'd311;
				y1_pre <= 11'd238;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 118 && lines_done) begin
				x0_pre <= 11'd311;
				y0_pre <= 11'd238;
				x1_pre <= 11'd249;
				y1_pre <= 11'd238;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 119 && lines_done) begin
				x0_pre <= 11'd249;
				y0_pre <= 11'd238;
				x1_pre <= 11'd280;
				y1_pre <= 11'd175;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 120 && lines_done) begin
				x0_pre <= 11'd127;
				y0_pre <= 11'd129;
				x1_pre <= 11'd142;
				y1_pre <= 11'd99;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 121 && lines_done) begin
				x0_pre <= 11'd142;
				y0_pre <= 11'd99;
				x1_pre <= 11'd112;
				y1_pre <= 11'd99;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 122 && lines_done) begin
				x0_pre <= 11'd112;
				y0_pre <= 11'd99;
				x1_pre <= 11'd127;
				y1_pre <= 11'd129;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 123 && lines_done) begin
				x0_pre <= 11'd341;
				y0_pre <= 11'd283;
				x1_pre <= 11'd376;
				y1_pre <= 11'd354;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 124 && lines_done) begin
				x0_pre <= 11'd376;
				y0_pre <= 11'd354;
				x1_pre <= 11'd306;
				y1_pre <= 11'd354;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 125 && lines_done) begin
				x0_pre <= 11'd306;
				y0_pre <= 11'd354;
				x1_pre <= 11'd341;
				y1_pre <= 11'd283;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 126 && lines_done) begin
				x0_pre <= 11'd445;
				y0_pre <= 11'd209;
				x1_pre <= 11'd493;
				y1_pre <= 11'd113;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 127 && lines_done) begin
				x0_pre <= 11'd493;
				y0_pre <= 11'd113;
				x1_pre <= 11'd397;
				y1_pre <= 11'd113;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 128 && lines_done) begin
				x0_pre <= 11'd397;
				y0_pre <= 11'd113;
				x1_pre <= 11'd445;
				y1_pre <= 11'd209;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 129 && lines_done) begin
				x0_pre <= 11'd470;
				y0_pre <= 11'd102;
				x1_pre <= 11'd499;
				y1_pre <= 11'd44;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 130 && lines_done) begin
				x0_pre <= 11'd499;
				y0_pre <= 11'd44;
				x1_pre <= 11'd441;
				y1_pre <= 11'd44;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 131 && lines_done) begin
				x0_pre <= 11'd441;
				y0_pre <= 11'd44;
				x1_pre <= 11'd470;
				y1_pre <= 11'd102;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 132 && lines_done) begin
				x0_pre <= 11'd153;
				y0_pre <= 11'd123;
				x1_pre <= 11'd178;
				y1_pre <= 11'd173;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 133 && lines_done) begin
				x0_pre <= 11'd178;
				y0_pre <= 11'd173;
				x1_pre <= 11'd128;
				y1_pre <= 11'd173;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 134 && lines_done) begin
				x0_pre <= 11'd128;
				y0_pre <= 11'd173;
				x1_pre <= 11'd153;
				y1_pre <= 11'd123;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 135 && lines_done) begin
				x0_pre <= 11'd152;
				y0_pre <= 11'd154;
				x1_pre <= 11'd189;
				y1_pre <= 11'd229;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 136 && lines_done) begin
				x0_pre <= 11'd189;
				y0_pre <= 11'd229;
				x1_pre <= 11'd115;
				y1_pre <= 11'd229;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 137 && lines_done) begin
				x0_pre <= 11'd115;
				y0_pre <= 11'd229;
				x1_pre <= 11'd152;
				y1_pre <= 11'd154;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 138 && lines_done) begin
				x0_pre <= 11'd390;
				y0_pre <= 11'd237;
				x1_pre <= 11'd410;
				y1_pre <= 11'd196;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 139 && lines_done) begin
				x0_pre <= 11'd410;
				y0_pre <= 11'd196;
				x1_pre <= 11'd370;
				y1_pre <= 11'd196;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 140 && lines_done) begin
				x0_pre <= 11'd370;
				y0_pre <= 11'd196;
				x1_pre <= 11'd390;
				y1_pre <= 11'd237;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 141 && lines_done) begin
				x0_pre <= 11'd115;
				y0_pre <= 11'd101;
				x1_pre <= 11'd155;
				y1_pre <= 11'd182;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 142 && lines_done) begin
				x0_pre <= 11'd155;
				y0_pre <= 11'd182;
				x1_pre <= 11'd75;
				y1_pre <= 11'd182;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 143 && lines_done) begin
				x0_pre <= 11'd75;
				y0_pre <= 11'd182;
				x1_pre <= 11'd115;
				y1_pre <= 11'd101;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 144 && lines_done) begin
				x0_pre <= 11'd425;
				y0_pre <= 11'd201;
				x1_pre <= 11'd451;
				y1_pre <= 11'd148;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 145 && lines_done) begin
				x0_pre <= 11'd451;
				y0_pre <= 11'd148;
				x1_pre <= 11'd399;
				y1_pre <= 11'd148;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 146 && lines_done) begin
				x0_pre <= 11'd399;
				y0_pre <= 11'd148;
				x1_pre <= 11'd425;
				y1_pre <= 11'd201;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 147 && lines_done) begin
				x0_pre <= 11'd360;
				y0_pre <= 11'd199;
				x1_pre <= 11'd402;
				y1_pre <= 11'd115;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 148 && lines_done) begin
				x0_pre <= 11'd402;
				y0_pre <= 11'd115;
				x1_pre <= 11'd318;
				y1_pre <= 11'd115;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 149 && lines_done) begin
				x0_pre <= 11'd318;
				y0_pre <= 11'd115;
				x1_pre <= 11'd360;
				y1_pre <= 11'd199;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 150 && lines_done) begin
				x0_pre <= 11'd211;
				y0_pre <= 11'd212;
				x1_pre <= 11'd229;
				y1_pre <= 11'd176;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 151 && lines_done) begin
				x0_pre <= 11'd229;
				y0_pre <= 11'd176;
				x1_pre <= 11'd193;
				y1_pre <= 11'd176;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 152 && lines_done) begin
				x0_pre <= 11'd193;
				y0_pre <= 11'd176;
				x1_pre <= 11'd211;
				y1_pre <= 11'd212;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 153 && lines_done) begin
				x0_pre <= 11'd146;
				y0_pre <= 11'd198;
				x1_pre <= 11'd173;
				y1_pre <= 11'd252;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 154 && lines_done) begin
				x0_pre <= 11'd173;
				y0_pre <= 11'd252;
				x1_pre <= 11'd119;
				y1_pre <= 11'd252;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 155 && lines_done) begin
				x0_pre <= 11'd119;
				y0_pre <= 11'd252;
				x1_pre <= 11'd146;
				y1_pre <= 11'd198;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 156 && lines_done) begin
				x0_pre <= 11'd448;
				y0_pre <= 11'd183;
				x1_pre <= 11'd491;
				y1_pre <= 11'd97;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 157 && lines_done) begin
				x0_pre <= 11'd491;
				y0_pre <= 11'd97;
				x1_pre <= 11'd405;
				y1_pre <= 11'd97;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 158 && lines_done) begin
				x0_pre <= 11'd405;
				y0_pre <= 11'd97;
				x1_pre <= 11'd448;
				y1_pre <= 11'd183;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 159 && lines_done) begin
				x0_pre <= 11'd264;
				y0_pre <= 11'd219;
				x1_pre <= 11'd309;
				y1_pre <= 11'd129;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 160 && lines_done) begin
				x0_pre <= 11'd309;
				y0_pre <= 11'd129;
				x1_pre <= 11'd219;
				y1_pre <= 11'd129;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 161 && lines_done) begin
				x0_pre <= 11'd219;
				y0_pre <= 11'd129;
				x1_pre <= 11'd264;
				y1_pre <= 11'd219;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 162 && lines_done) begin
				x0_pre <= 11'd288;
				y0_pre <= 11'd187;
				x1_pre <= 11'd308;
				y1_pre <= 11'd227;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 163 && lines_done) begin
				x0_pre <= 11'd308;
				y0_pre <= 11'd227;
				x1_pre <= 11'd268;
				y1_pre <= 11'd227;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 164 && lines_done) begin
				x0_pre <= 11'd268;
				y0_pre <= 11'd227;
				x1_pre <= 11'd288;
				y1_pre <= 11'd187;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 165 && lines_done) begin
				x0_pre <= 11'd376;
				y0_pre <= 11'd134;
				x1_pre <= 11'd410;
				y1_pre <= 11'd66;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 166 && lines_done) begin
				x0_pre <= 11'd410;
				y0_pre <= 11'd66;
				x1_pre <= 11'd342;
				y1_pre <= 11'd66;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 167 && lines_done) begin
				x0_pre <= 11'd342;
				y0_pre <= 11'd66;
				x1_pre <= 11'd376;
				y1_pre <= 11'd134;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 168 && lines_done) begin
				x0_pre <= 11'd341;
				y0_pre <= 11'd217;
				x1_pre <= 11'd374;
				y1_pre <= 11'd284;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 169 && lines_done) begin
				x0_pre <= 11'd374;
				y0_pre <= 11'd284;
				x1_pre <= 11'd308;
				y1_pre <= 11'd284;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 170 && lines_done) begin
				x0_pre <= 11'd308;
				y0_pre <= 11'd284;
				x1_pre <= 11'd341;
				y1_pre <= 11'd217;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 171 && lines_done) begin
				x0_pre <= 11'd418;
				y0_pre <= 11'd178;
				x1_pre <= 11'd448;
				y1_pre <= 11'd239;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 172 && lines_done) begin
				x0_pre <= 11'd448;
				y0_pre <= 11'd239;
				x1_pre <= 11'd388;
				y1_pre <= 11'd239;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 173 && lines_done) begin
				x0_pre <= 11'd388;
				y0_pre <= 11'd239;
				x1_pre <= 11'd418;
				y1_pre <= 11'd178;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 174 && lines_done) begin
				x0_pre <= 11'd371;
				y0_pre <= 11'd158;
				x1_pre <= 11'd396;
				y1_pre <= 11'd107;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 175 && lines_done) begin
				x0_pre <= 11'd396;
				y0_pre <= 11'd107;
				x1_pre <= 11'd346;
				y1_pre <= 11'd107;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 176 && lines_done) begin
				x0_pre <= 11'd346;
				y0_pre <= 11'd107;
				x1_pre <= 11'd371;
				y1_pre <= 11'd158;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 177 && lines_done) begin
				x0_pre <= 11'd304;
				y0_pre <= 11'd277;
				x1_pre <= 11'd338;
				y1_pre <= 11'd346;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 178 && lines_done) begin
				x0_pre <= 11'd338;
				y0_pre <= 11'd346;
				x1_pre <= 11'd270;
				y1_pre <= 11'd346;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 179 && lines_done) begin
				x0_pre <= 11'd270;
				y0_pre <= 11'd346;
				x1_pre <= 11'd304;
				y1_pre <= 11'd277;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 180 && lines_done) begin
				x0_pre <= 11'd165;
				y0_pre <= 11'd215;
				x1_pre <= 11'd193;
				y1_pre <= 11'd272;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 181 && lines_done) begin
				x0_pre <= 11'd193;
				y0_pre <= 11'd272;
				x1_pre <= 11'd137;
				y1_pre <= 11'd272;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 182 && lines_done) begin
				x0_pre <= 11'd137;
				y0_pre <= 11'd272;
				x1_pre <= 11'd165;
				y1_pre <= 11'd215;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 183 && lines_done) begin
				x0_pre <= 11'd236;
				y0_pre <= 11'd310;
				x1_pre <= 11'd264;
				y1_pre <= 11'd367;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 184 && lines_done) begin
				x0_pre <= 11'd264;
				y0_pre <= 11'd367;
				x1_pre <= 11'd208;
				y1_pre <= 11'd367;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 185 && lines_done) begin
				x0_pre <= 11'd208;
				y0_pre <= 11'd367;
				x1_pre <= 11'd236;
				y1_pre <= 11'd310;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 186 && lines_done) begin
				x0_pre <= 11'd394;
				y0_pre <= 11'd267;
				x1_pre <= 11'd411;
				y1_pre <= 11'd302;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 187 && lines_done) begin
				x0_pre <= 11'd411;
				y0_pre <= 11'd302;
				x1_pre <= 11'd377;
				y1_pre <= 11'd302;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 188 && lines_done) begin
				x0_pre <= 11'd377;
				y0_pre <= 11'd302;
				x1_pre <= 11'd394;
				y1_pre <= 11'd267;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 189 && lines_done) begin
				x0_pre <= 11'd377;
				y0_pre <= 11'd271;
				x1_pre <= 11'd426;
				y1_pre <= 11'd173;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 190 && lines_done) begin
				x0_pre <= 11'd426;
				y0_pre <= 11'd173;
				x1_pre <= 11'd328;
				y1_pre <= 11'd173;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 191 && lines_done) begin
				x0_pre <= 11'd328;
				y0_pre <= 11'd173;
				x1_pre <= 11'd377;
				y1_pre <= 11'd271;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 192 && lines_done) begin
				x0_pre <= 11'd498;
				y0_pre <= 11'd194;
				x1_pre <= 11'd522;
				y1_pre <= 11'd145;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 193 && lines_done) begin
				x0_pre <= 11'd522;
				y0_pre <= 11'd145;
				x1_pre <= 11'd474;
				y1_pre <= 11'd145;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 194 && lines_done) begin
				x0_pre <= 11'd474;
				y0_pre <= 11'd145;
				x1_pre <= 11'd498;
				y1_pre <= 11'd194;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 195 && lines_done) begin
				x0_pre <= 11'd389;
				y0_pre <= 11'd111;
				x1_pre <= 11'd406;
				y1_pre <= 11'd146;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 196 && lines_done) begin
				x0_pre <= 11'd406;
				y0_pre <= 11'd146;
				x1_pre <= 11'd372;
				y1_pre <= 11'd146;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 197 && lines_done) begin
				x0_pre <= 11'd372;
				y0_pre <= 11'd146;
				x1_pre <= 11'd389;
				y1_pre <= 11'd111;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 198 && lines_done) begin
				x0_pre <= 11'd449;
				y0_pre <= 11'd237;
				x1_pre <= 11'd485;
				y1_pre <= 11'd164;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 199 && lines_done) begin
				x0_pre <= 11'd485;
				y0_pre <= 11'd164;
				x1_pre <= 11'd413;
				y1_pre <= 11'd164;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 200 && lines_done) begin
				x0_pre <= 11'd413;
				y0_pre <= 11'd164;
				x1_pre <= 11'd449;
				y1_pre <= 11'd237;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 201 && lines_done) begin
				x0_pre <= 11'd155;
				y0_pre <= 11'd288;
				x1_pre <= 11'd180;
				y1_pre <= 11'd338;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 202 && lines_done) begin
				x0_pre <= 11'd180;
				y0_pre <= 11'd338;
				x1_pre <= 11'd130;
				y1_pre <= 11'd338;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 203 && lines_done) begin
				x0_pre <= 11'd130;
				y0_pre <= 11'd338;
				x1_pre <= 11'd155;
				y1_pre <= 11'd288;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 204 && lines_done) begin
				x0_pre <= 11'd391;
				y0_pre <= 11'd243;
				x1_pre <= 11'd407;
				y1_pre <= 11'd276;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 205 && lines_done) begin
				x0_pre <= 11'd407;
				y0_pre <= 11'd276;
				x1_pre <= 11'd375;
				y1_pre <= 11'd276;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 206 && lines_done) begin
				x0_pre <= 11'd375;
				y0_pre <= 11'd276;
				x1_pre <= 11'd391;
				y1_pre <= 11'd243;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 207 && lines_done) begin
				x0_pre <= 11'd202;
				y0_pre <= 11'd239;
				x1_pre <= 11'd247;
				y1_pre <= 11'd329;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 208 && lines_done) begin
				x0_pre <= 11'd247;
				y0_pre <= 11'd329;
				x1_pre <= 11'd157;
				y1_pre <= 11'd329;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 209 && lines_done) begin
				x0_pre <= 11'd157;
				y0_pre <= 11'd329;
				x1_pre <= 11'd202;
				y1_pre <= 11'd239;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 210 && lines_done) begin
				x0_pre <= 11'd486;
				y0_pre <= 11'd206;
				x1_pre <= 11'd526;
				y1_pre <= 11'd126;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 211 && lines_done) begin
				x0_pre <= 11'd526;
				y0_pre <= 11'd126;
				x1_pre <= 11'd446;
				y1_pre <= 11'd126;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 212 && lines_done) begin
				x0_pre <= 11'd446;
				y0_pre <= 11'd126;
				x1_pre <= 11'd486;
				y1_pre <= 11'd206;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 213 && lines_done) begin
				x0_pre <= 11'd329;
				y0_pre <= 11'd268;
				x1_pre <= 11'd346;
				y1_pre <= 11'd303;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 214 && lines_done) begin
				x0_pre <= 11'd346;
				y0_pre <= 11'd303;
				x1_pre <= 11'd312;
				y1_pre <= 11'd303;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 215 && lines_done) begin
				x0_pre <= 11'd312;
				y0_pre <= 11'd303;
				x1_pre <= 11'd329;
				y1_pre <= 11'd268;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 216 && lines_done) begin
				x0_pre <= 11'd380;
				y0_pre <= 11'd280;
				x1_pre <= 11'd403;
				y1_pre <= 11'd326;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 217 && lines_done) begin
				x0_pre <= 11'd403;
				y0_pre <= 11'd326;
				x1_pre <= 11'd357;
				y1_pre <= 11'd326;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 218 && lines_done) begin
				x0_pre <= 11'd357;
				y0_pre <= 11'd326;
				x1_pre <= 11'd380;
				y1_pre <= 11'd280;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 219 && lines_done) begin
				x0_pre <= 11'd329;
				y0_pre <= 11'd268;
				x1_pre <= 11'd367;
				y1_pre <= 11'd191;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 220 && lines_done) begin
				x0_pre <= 11'd367;
				y0_pre <= 11'd191;
				x1_pre <= 11'd291;
				y1_pre <= 11'd191;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 221 && lines_done) begin
				x0_pre <= 11'd291;
				y0_pre <= 11'd191;
				x1_pre <= 11'd329;
				y1_pre <= 11'd268;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 222 && lines_done) begin
				x0_pre <= 11'd474;
				y0_pre <= 11'd172;
				x1_pre <= 11'd510;
				y1_pre <= 11'd245;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 223 && lines_done) begin
				x0_pre <= 11'd510;
				y0_pre <= 11'd245;
				x1_pre <= 11'd438;
				y1_pre <= 11'd245;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 224 && lines_done) begin
				x0_pre <= 11'd438;
				y0_pre <= 11'd245;
				x1_pre <= 11'd474;
				y1_pre <= 11'd172;
				// frame is complete
				lines_counter <= 0;
				frame_complete <= 1;
				x_offset <= x_offset + 20;
				y_offset <= y_offset + 10;
			end
		end
	end
endmodule