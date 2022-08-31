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
module animation2(input  logic clk, reset,
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
				x0_pre <= 11'd362;
				y0_pre <= 11'd217;
				x1_pre <= 11'd372;
				y1_pre <= 11'd196;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 1 && lines_done) begin
				x0_pre <= 11'd372;
				y0_pre <= 11'd196;
				x1_pre <= 11'd393;
				y1_pre <= 11'd186;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 2 && lines_done) begin
				x0_pre <= 11'd393;
				y0_pre <= 11'd186;
				x1_pre <= 11'd372;
				y1_pre <= 11'd176;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 3 && lines_done) begin
				x0_pre <= 11'd372;
				y0_pre <= 11'd176;
				x1_pre <= 11'd362;
				y1_pre <= 11'd155;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 4 && lines_done) begin
				x0_pre <= 11'd362;
				y0_pre <= 11'd155;
				x1_pre <= 11'd352;
				y1_pre <= 11'd176;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 5 && lines_done) begin
				x0_pre <= 11'd352;
				y0_pre <= 11'd176;
				x1_pre <= 11'd331;
				y1_pre <= 11'd186;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 6 && lines_done) begin
				x0_pre <= 11'd331;
				y0_pre <= 11'd186;
				x1_pre <= 11'd352;
				y1_pre <= 11'd196;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 7 && lines_done) begin
				x0_pre <= 11'd352;
				y0_pre <= 11'd196;
				x1_pre <= 11'd362;
				y1_pre <= 11'd217;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 8 && lines_done) begin
				x0_pre <= 11'd225;
				y0_pre <= 11'd338;
				x1_pre <= 11'd249;
				y1_pre <= 11'd288;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 9 && lines_done) begin
				x0_pre <= 11'd249;
				y0_pre <= 11'd288;
				x1_pre <= 11'd299;
				y1_pre <= 11'd264;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 10 && lines_done) begin
				x0_pre <= 11'd299;
				y0_pre <= 11'd264;
				x1_pre <= 11'd249;
				y1_pre <= 11'd240;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 11 && lines_done) begin
				x0_pre <= 11'd249;
				y0_pre <= 11'd240;
				x1_pre <= 11'd225;
				y1_pre <= 11'd190;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 12 && lines_done) begin
				x0_pre <= 11'd225;
				y0_pre <= 11'd190;
				x1_pre <= 11'd201;
				y1_pre <= 11'd240;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 13 && lines_done) begin
				x0_pre <= 11'd201;
				y0_pre <= 11'd240;
				x1_pre <= 11'd151;
				y1_pre <= 11'd264;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 14 && lines_done) begin
				x0_pre <= 11'd151;
				y0_pre <= 11'd264;
				x1_pre <= 11'd201;
				y1_pre <= 11'd288;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 15 && lines_done) begin
				x0_pre <= 11'd201;
				y0_pre <= 11'd288;
				x1_pre <= 11'd225;
				y1_pre <= 11'd338;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 16 && lines_done) begin
				x0_pre <= 11'd384;
				y0_pre <= 11'd291;
				x1_pre <= 11'd406;
				y1_pre <= 11'd247;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 17 && lines_done) begin
				x0_pre <= 11'd406;
				y0_pre <= 11'd247;
				x1_pre <= 11'd450;
				y1_pre <= 11'd225;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 18 && lines_done) begin
				x0_pre <= 11'd450;
				y0_pre <= 11'd225;
				x1_pre <= 11'd406;
				y1_pre <= 11'd203;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 19 && lines_done) begin
				x0_pre <= 11'd406;
				y0_pre <= 11'd203;
				x1_pre <= 11'd384;
				y1_pre <= 11'd159;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 20 && lines_done) begin
				x0_pre <= 11'd384;
				y0_pre <= 11'd159;
				x1_pre <= 11'd362;
				y1_pre <= 11'd203;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 21 && lines_done) begin
				x0_pre <= 11'd362;
				y0_pre <= 11'd203;
				x1_pre <= 11'd318;
				y1_pre <= 11'd225;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 22 && lines_done) begin
				x0_pre <= 11'd318;
				y0_pre <= 11'd225;
				x1_pre <= 11'd362;
				y1_pre <= 11'd247;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 23 && lines_done) begin
				x0_pre <= 11'd362;
				y0_pre <= 11'd247;
				x1_pre <= 11'd384;
				y1_pre <= 11'd291;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 24 && lines_done) begin
				x0_pre <= 11'd203;
				y0_pre <= 11'd245;
				x1_pre <= 11'd213;
				y1_pre <= 11'd223;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 25 && lines_done) begin
				x0_pre <= 11'd213;
				y0_pre <= 11'd223;
				x1_pre <= 11'd235;
				y1_pre <= 11'd213;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 26 && lines_done) begin
				x0_pre <= 11'd235;
				y0_pre <= 11'd213;
				x1_pre <= 11'd213;
				y1_pre <= 11'd203;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 27 && lines_done) begin
				x0_pre <= 11'd213;
				y0_pre <= 11'd203;
				x1_pre <= 11'd203;
				y1_pre <= 11'd181;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 28 && lines_done) begin
				x0_pre <= 11'd203;
				y0_pre <= 11'd181;
				x1_pre <= 11'd193;
				y1_pre <= 11'd203;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 29 && lines_done) begin
				x0_pre <= 11'd193;
				y0_pre <= 11'd203;
				x1_pre <= 11'd171;
				y1_pre <= 11'd213;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 30 && lines_done) begin
				x0_pre <= 11'd171;
				y0_pre <= 11'd213;
				x1_pre <= 11'd193;
				y1_pre <= 11'd223;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 31 && lines_done) begin
				x0_pre <= 11'd193;
				y0_pre <= 11'd223;
				x1_pre <= 11'd203;
				y1_pre <= 11'd245;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 32 && lines_done) begin
				x0_pre <= 11'd187;
				y0_pre <= 11'd312;
				x1_pre <= 11'd212;
				y1_pre <= 11'd262;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 33 && lines_done) begin
				x0_pre <= 11'd212;
				y0_pre <= 11'd262;
				x1_pre <= 11'd262;
				y1_pre <= 11'd237;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 34 && lines_done) begin
				x0_pre <= 11'd262;
				y0_pre <= 11'd237;
				x1_pre <= 11'd212;
				y1_pre <= 11'd212;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 35 && lines_done) begin
				x0_pre <= 11'd212;
				y0_pre <= 11'd212;
				x1_pre <= 11'd187;
				y1_pre <= 11'd162;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 36 && lines_done) begin
				x0_pre <= 11'd187;
				y0_pre <= 11'd162;
				x1_pre <= 11'd162;
				y1_pre <= 11'd212;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 37 && lines_done) begin
				x0_pre <= 11'd162;
				y0_pre <= 11'd212;
				x1_pre <= 11'd112;
				y1_pre <= 11'd237;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 38 && lines_done) begin
				x0_pre <= 11'd112;
				y0_pre <= 11'd237;
				x1_pre <= 11'd162;
				y1_pre <= 11'd262;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 39 && lines_done) begin
				x0_pre <= 11'd162;
				y0_pre <= 11'd262;
				x1_pre <= 11'd187;
				y1_pre <= 11'd312;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 40 && lines_done) begin
				x0_pre <= 11'd288;
				y0_pre <= 11'd287;
				x1_pre <= 11'd302;
				y1_pre <= 11'd258;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 41 && lines_done) begin
				x0_pre <= 11'd302;
				y0_pre <= 11'd258;
				x1_pre <= 11'd331;
				y1_pre <= 11'd244;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 42 && lines_done) begin
				x0_pre <= 11'd331;
				y0_pre <= 11'd244;
				x1_pre <= 11'd302;
				y1_pre <= 11'd230;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 43 && lines_done) begin
				x0_pre <= 11'd302;
				y0_pre <= 11'd230;
				x1_pre <= 11'd288;
				y1_pre <= 11'd201;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 44 && lines_done) begin
				x0_pre <= 11'd288;
				y0_pre <= 11'd201;
				x1_pre <= 11'd274;
				y1_pre <= 11'd230;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 45 && lines_done) begin
				x0_pre <= 11'd274;
				y0_pre <= 11'd230;
				x1_pre <= 11'd245;
				y1_pre <= 11'd244;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 46 && lines_done) begin
				x0_pre <= 11'd245;
				y0_pre <= 11'd244;
				x1_pre <= 11'd274;
				y1_pre <= 11'd258;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 47 && lines_done) begin
				x0_pre <= 11'd274;
				y0_pre <= 11'd258;
				x1_pre <= 11'd288;
				y1_pre <= 11'd287;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 48 && lines_done) begin
				x0_pre <= 11'd188;
				y0_pre <= 11'd334;
				x1_pre <= 11'd202;
				y1_pre <= 11'd306;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 49 && lines_done) begin
				x0_pre <= 11'd202;
				y0_pre <= 11'd306;
				x1_pre <= 11'd230;
				y1_pre <= 11'd292;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 50 && lines_done) begin
				x0_pre <= 11'd230;
				y0_pre <= 11'd292;
				x1_pre <= 11'd202;
				y1_pre <= 11'd278;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 51 && lines_done) begin
				x0_pre <= 11'd202;
				y0_pre <= 11'd278;
				x1_pre <= 11'd188;
				y1_pre <= 11'd250;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 52 && lines_done) begin
				x0_pre <= 11'd188;
				y0_pre <= 11'd250;
				x1_pre <= 11'd174;
				y1_pre <= 11'd278;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 53 && lines_done) begin
				x0_pre <= 11'd174;
				y0_pre <= 11'd278;
				x1_pre <= 11'd146;
				y1_pre <= 11'd292;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 54 && lines_done) begin
				x0_pre <= 11'd146;
				y0_pre <= 11'd292;
				x1_pre <= 11'd174;
				y1_pre <= 11'd306;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 55 && lines_done) begin
				x0_pre <= 11'd174;
				y0_pre <= 11'd306;
				x1_pre <= 11'd188;
				y1_pre <= 11'd334;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 56 && lines_done) begin
				x0_pre <= 11'd265;
				y0_pre <= 11'd263;
				x1_pre <= 11'd291;
				y1_pre <= 11'd210;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 57 && lines_done) begin
				x0_pre <= 11'd291;
				y0_pre <= 11'd210;
				x1_pre <= 11'd344;
				y1_pre <= 11'd184;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 58 && lines_done) begin
				x0_pre <= 11'd344;
				y0_pre <= 11'd184;
				x1_pre <= 11'd291;
				y1_pre <= 11'd158;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 59 && lines_done) begin
				x0_pre <= 11'd291;
				y0_pre <= 11'd158;
				x1_pre <= 11'd265;
				y1_pre <= 11'd105;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 60 && lines_done) begin
				x0_pre <= 11'd265;
				y0_pre <= 11'd105;
				x1_pre <= 11'd239;
				y1_pre <= 11'd158;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 61 && lines_done) begin
				x0_pre <= 11'd239;
				y0_pre <= 11'd158;
				x1_pre <= 11'd186;
				y1_pre <= 11'd184;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 62 && lines_done) begin
				x0_pre <= 11'd186;
				y0_pre <= 11'd184;
				x1_pre <= 11'd239;
				y1_pre <= 11'd210;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 63 && lines_done) begin
				x0_pre <= 11'd239;
				y0_pre <= 11'd210;
				x1_pre <= 11'd265;
				y1_pre <= 11'd263;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 64 && lines_done) begin
				x0_pre <= 11'd459;
				y0_pre <= 11'd184;
				x1_pre <= 11'd469;
				y1_pre <= 11'd164;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 65 && lines_done) begin
				x0_pre <= 11'd469;
				y0_pre <= 11'd164;
				x1_pre <= 11'd489;
				y1_pre <= 11'd154;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 66 && lines_done) begin
				x0_pre <= 11'd489;
				y0_pre <= 11'd154;
				x1_pre <= 11'd469;
				y1_pre <= 11'd144;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 67 && lines_done) begin
				x0_pre <= 11'd469;
				y0_pre <= 11'd144;
				x1_pre <= 11'd459;
				y1_pre <= 11'd124;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 68 && lines_done) begin
				x0_pre <= 11'd459;
				y0_pre <= 11'd124;
				x1_pre <= 11'd449;
				y1_pre <= 11'd144;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 69 && lines_done) begin
				x0_pre <= 11'd449;
				y0_pre <= 11'd144;
				x1_pre <= 11'd429;
				y1_pre <= 11'd154;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 70 && lines_done) begin
				x0_pre <= 11'd429;
				y0_pre <= 11'd154;
				x1_pre <= 11'd449;
				y1_pre <= 11'd164;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 71 && lines_done) begin
				x0_pre <= 11'd449;
				y0_pre <= 11'd164;
				x1_pre <= 11'd459;
				y1_pre <= 11'd184;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 72 && lines_done) begin
				x0_pre <= 11'd459;
				y0_pre <= 11'd208;
				x1_pre <= 11'd481;
				y1_pre <= 11'd163;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 73 && lines_done) begin
				x0_pre <= 11'd481;
				y0_pre <= 11'd163;
				x1_pre <= 11'd526;
				y1_pre <= 11'd141;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 74 && lines_done) begin
				x0_pre <= 11'd526;
				y0_pre <= 11'd141;
				x1_pre <= 11'd481;
				y1_pre <= 11'd119;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 75 && lines_done) begin
				x0_pre <= 11'd481;
				y0_pre <= 11'd119;
				x1_pre <= 11'd459;
				y1_pre <= 11'd74;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 76 && lines_done) begin
				x0_pre <= 11'd459;
				y0_pre <= 11'd74;
				x1_pre <= 11'd437;
				y1_pre <= 11'd119;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 77 && lines_done) begin
				x0_pre <= 11'd437;
				y0_pre <= 11'd119;
				x1_pre <= 11'd392;
				y1_pre <= 11'd141;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 78 && lines_done) begin
				x0_pre <= 11'd392;
				y0_pre <= 11'd141;
				x1_pre <= 11'd437;
				y1_pre <= 11'd163;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 79 && lines_done) begin
				x0_pre <= 11'd437;
				y0_pre <= 11'd163;
				x1_pre <= 11'd459;
				y1_pre <= 11'd208;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 80 && lines_done) begin
				x0_pre <= 11'd451;
				y0_pre <= 11'd327;
				x1_pre <= 11'd475;
				y1_pre <= 11'd277;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 81 && lines_done) begin
				x0_pre <= 11'd475;
				y0_pre <= 11'd277;
				x1_pre <= 11'd525;
				y1_pre <= 11'd253;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 82 && lines_done) begin
				x0_pre <= 11'd525;
				y0_pre <= 11'd253;
				x1_pre <= 11'd475;
				y1_pre <= 11'd229;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 83 && lines_done) begin
				x0_pre <= 11'd475;
				y0_pre <= 11'd229;
				x1_pre <= 11'd451;
				y1_pre <= 11'd179;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 84 && lines_done) begin
				x0_pre <= 11'd451;
				y0_pre <= 11'd179;
				x1_pre <= 11'd427;
				y1_pre <= 11'd229;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 85 && lines_done) begin
				x0_pre <= 11'd427;
				y0_pre <= 11'd229;
				x1_pre <= 11'd377;
				y1_pre <= 11'd253;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 86 && lines_done) begin
				x0_pre <= 11'd377;
				y0_pre <= 11'd253;
				x1_pre <= 11'd427;
				y1_pre <= 11'd277;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 87 && lines_done) begin
				x0_pre <= 11'd427;
				y0_pre <= 11'd277;
				x1_pre <= 11'd451;
				y1_pre <= 11'd327;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 88 && lines_done) begin
				x0_pre <= 11'd194;
				y0_pre <= 11'd251;
				x1_pre <= 11'd204;
				y1_pre <= 11'd230;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 89 && lines_done) begin
				x0_pre <= 11'd204;
				y0_pre <= 11'd230;
				x1_pre <= 11'd225;
				y1_pre <= 11'd220;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 90 && lines_done) begin
				x0_pre <= 11'd225;
				y0_pre <= 11'd220;
				x1_pre <= 11'd204;
				y1_pre <= 11'd210;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 91 && lines_done) begin
				x0_pre <= 11'd204;
				y0_pre <= 11'd210;
				x1_pre <= 11'd194;
				y1_pre <= 11'd189;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 92 && lines_done) begin
				x0_pre <= 11'd194;
				y0_pre <= 11'd189;
				x1_pre <= 11'd184;
				y1_pre <= 11'd210;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 93 && lines_done) begin
				x0_pre <= 11'd184;
				y0_pre <= 11'd210;
				x1_pre <= 11'd163;
				y1_pre <= 11'd220;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 94 && lines_done) begin
				x0_pre <= 11'd163;
				y0_pre <= 11'd220;
				x1_pre <= 11'd184;
				y1_pre <= 11'd230;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 95 && lines_done) begin
				x0_pre <= 11'd184;
				y0_pre <= 11'd230;
				x1_pre <= 11'd194;
				y1_pre <= 11'd251;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 96 && lines_done) begin
				x0_pre <= 11'd198;
				y0_pre <= 11'd373;
				x1_pre <= 11'd216;
				y1_pre <= 11'd336;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 97 && lines_done) begin
				x0_pre <= 11'd216;
				y0_pre <= 11'd336;
				x1_pre <= 11'd253;
				y1_pre <= 11'd318;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 98 && lines_done) begin
				x0_pre <= 11'd253;
				y0_pre <= 11'd318;
				x1_pre <= 11'd216;
				y1_pre <= 11'd300;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 99 && lines_done) begin
				x0_pre <= 11'd216;
				y0_pre <= 11'd300;
				x1_pre <= 11'd198;
				y1_pre <= 11'd263;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 100 && lines_done) begin
				x0_pre <= 11'd198;
				y0_pre <= 11'd263;
				x1_pre <= 11'd180;
				y1_pre <= 11'd300;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 101 && lines_done) begin
				x0_pre <= 11'd180;
				y0_pre <= 11'd300;
				x1_pre <= 11'd143;
				y1_pre <= 11'd318;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 102 && lines_done) begin
				x0_pre <= 11'd143;
				y0_pre <= 11'd318;
				x1_pre <= 11'd180;
				y1_pre <= 11'd336;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 103 && lines_done) begin
				x0_pre <= 11'd180;
				y0_pre <= 11'd336;
				x1_pre <= 11'd198;
				y1_pre <= 11'd373;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 104 && lines_done) begin
				x0_pre <= 11'd221;
				y0_pre <= 11'd250;
				x1_pre <= 11'd234;
				y1_pre <= 11'd224;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 105 && lines_done) begin
				x0_pre <= 11'd234;
				y0_pre <= 11'd224;
				x1_pre <= 11'd260;
				y1_pre <= 11'd211;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 106 && lines_done) begin
				x0_pre <= 11'd260;
				y0_pre <= 11'd211;
				x1_pre <= 11'd234;
				y1_pre <= 11'd198;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 107 && lines_done) begin
				x0_pre <= 11'd234;
				y0_pre <= 11'd198;
				x1_pre <= 11'd221;
				y1_pre <= 11'd172;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 108 && lines_done) begin
				x0_pre <= 11'd221;
				y0_pre <= 11'd172;
				x1_pre <= 11'd208;
				y1_pre <= 11'd198;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 109 && lines_done) begin
				x0_pre <= 11'd208;
				y0_pre <= 11'd198;
				x1_pre <= 11'd182;
				y1_pre <= 11'd211;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 110 && lines_done) begin
				x0_pre <= 11'd182;
				y0_pre <= 11'd211;
				x1_pre <= 11'd208;
				y1_pre <= 11'd224;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 111 && lines_done) begin
				x0_pre <= 11'd208;
				y0_pre <= 11'd224;
				x1_pre <= 11'd221;
				y1_pre <= 11'd250;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 112 && lines_done) begin
				x0_pre <= 11'd247;
				y0_pre <= 11'd203;
				x1_pre <= 11'd271;
				y1_pre <= 11'd155;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 113 && lines_done) begin
				x0_pre <= 11'd271;
				y0_pre <= 11'd155;
				x1_pre <= 11'd319;
				y1_pre <= 11'd131;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 114 && lines_done) begin
				x0_pre <= 11'd319;
				y0_pre <= 11'd131;
				x1_pre <= 11'd271;
				y1_pre <= 11'd107;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 115 && lines_done) begin
				x0_pre <= 11'd271;
				y0_pre <= 11'd107;
				x1_pre <= 11'd247;
				y1_pre <= 11'd59;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 116 && lines_done) begin
				x0_pre <= 11'd247;
				y0_pre <= 11'd59;
				x1_pre <= 11'd223;
				y1_pre <= 11'd107;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 117 && lines_done) begin
				x0_pre <= 11'd223;
				y0_pre <= 11'd107;
				x1_pre <= 11'd175;
				y1_pre <= 11'd131;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 118 && lines_done) begin
				x0_pre <= 11'd175;
				y0_pre <= 11'd131;
				x1_pre <= 11'd223;
				y1_pre <= 11'd155;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 119 && lines_done) begin
				x0_pre <= 11'd223;
				y0_pre <= 11'd155;
				x1_pre <= 11'd247;
				y1_pre <= 11'd203;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 120 && lines_done) begin
				x0_pre <= 11'd164;
				y0_pre <= 11'd326;
				x1_pre <= 11'd185;
				y1_pre <= 11'd284;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 121 && lines_done) begin
				x0_pre <= 11'd185;
				y0_pre <= 11'd284;
				x1_pre <= 11'd227;
				y1_pre <= 11'd263;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 122 && lines_done) begin
				x0_pre <= 11'd227;
				y0_pre <= 11'd263;
				x1_pre <= 11'd185;
				y1_pre <= 11'd242;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 123 && lines_done) begin
				x0_pre <= 11'd185;
				y0_pre <= 11'd242;
				x1_pre <= 11'd164;
				y1_pre <= 11'd200;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 124 && lines_done) begin
				x0_pre <= 11'd164;
				y0_pre <= 11'd200;
				x1_pre <= 11'd143;
				y1_pre <= 11'd242;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 125 && lines_done) begin
				x0_pre <= 11'd143;
				y0_pre <= 11'd242;
				x1_pre <= 11'd101;
				y1_pre <= 11'd263;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 126 && lines_done) begin
				x0_pre <= 11'd101;
				y0_pre <= 11'd263;
				x1_pre <= 11'd143;
				y1_pre <= 11'd284;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 127 && lines_done) begin
				x0_pre <= 11'd143;
				y0_pre <= 11'd284;
				x1_pre <= 11'd164;
				y1_pre <= 11'd326;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 128 && lines_done) begin
				x0_pre <= 11'd138;
				y0_pre <= 11'd348;
				x1_pre <= 11'd156;
				y1_pre <= 11'd310;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 129 && lines_done) begin
				x0_pre <= 11'd156;
				y0_pre <= 11'd310;
				x1_pre <= 11'd194;
				y1_pre <= 11'd292;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 130 && lines_done) begin
				x0_pre <= 11'd194;
				y0_pre <= 11'd292;
				x1_pre <= 11'd156;
				y1_pre <= 11'd274;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 131 && lines_done) begin
				x0_pre <= 11'd156;
				y0_pre <= 11'd274;
				x1_pre <= 11'd138;
				y1_pre <= 11'd236;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 132 && lines_done) begin
				x0_pre <= 11'd138;
				y0_pre <= 11'd236;
				x1_pre <= 11'd120;
				y1_pre <= 11'd274;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 133 && lines_done) begin
				x0_pre <= 11'd120;
				y0_pre <= 11'd274;
				x1_pre <= 11'd82;
				y1_pre <= 11'd292;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 134 && lines_done) begin
				x0_pre <= 11'd82;
				y0_pre <= 11'd292;
				x1_pre <= 11'd120;
				y1_pre <= 11'd310;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 135 && lines_done) begin
				x0_pre <= 11'd120;
				y0_pre <= 11'd310;
				x1_pre <= 11'd138;
				y1_pre <= 11'd348;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 136 && lines_done) begin
				x0_pre <= 11'd196;
				y0_pre <= 11'd195;
				x1_pre <= 11'd210;
				y1_pre <= 11'd167;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 137 && lines_done) begin
				x0_pre <= 11'd210;
				y0_pre <= 11'd167;
				x1_pre <= 11'd238;
				y1_pre <= 11'd153;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 138 && lines_done) begin
				x0_pre <= 11'd238;
				y0_pre <= 11'd153;
				x1_pre <= 11'd210;
				y1_pre <= 11'd139;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 139 && lines_done) begin
				x0_pre <= 11'd210;
				y0_pre <= 11'd139;
				x1_pre <= 11'd196;
				y1_pre <= 11'd111;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 140 && lines_done) begin
				x0_pre <= 11'd196;
				y0_pre <= 11'd111;
				x1_pre <= 11'd182;
				y1_pre <= 11'd139;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 141 && lines_done) begin
				x0_pre <= 11'd182;
				y0_pre <= 11'd139;
				x1_pre <= 11'd154;
				y1_pre <= 11'd153;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 142 && lines_done) begin
				x0_pre <= 11'd154;
				y0_pre <= 11'd153;
				x1_pre <= 11'd182;
				y1_pre <= 11'd167;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 143 && lines_done) begin
				x0_pre <= 11'd182;
				y0_pre <= 11'd167;
				x1_pre <= 11'd196;
				y1_pre <= 11'd195;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 144 && lines_done) begin
				x0_pre <= 11'd417;
				y0_pre <= 11'd246;
				x1_pre <= 11'd432;
				y1_pre <= 11'd215;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 145 && lines_done) begin
				x0_pre <= 11'd432;
				y0_pre <= 11'd215;
				x1_pre <= 11'd463;
				y1_pre <= 11'd200;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 146 && lines_done) begin
				x0_pre <= 11'd463;
				y0_pre <= 11'd200;
				x1_pre <= 11'd432;
				y1_pre <= 11'd185;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 147 && lines_done) begin
				x0_pre <= 11'd432;
				y0_pre <= 11'd185;
				x1_pre <= 11'd417;
				y1_pre <= 11'd154;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 148 && lines_done) begin
				x0_pre <= 11'd417;
				y0_pre <= 11'd154;
				x1_pre <= 11'd402;
				y1_pre <= 11'd185;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 149 && lines_done) begin
				x0_pre <= 11'd402;
				y0_pre <= 11'd185;
				x1_pre <= 11'd371;
				y1_pre <= 11'd200;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 150 && lines_done) begin
				x0_pre <= 11'd371;
				y0_pre <= 11'd200;
				x1_pre <= 11'd402;
				y1_pre <= 11'd215;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 151 && lines_done) begin
				x0_pre <= 11'd402;
				y0_pre <= 11'd215;
				x1_pre <= 11'd417;
				y1_pre <= 11'd246;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 152 && lines_done) begin
				x0_pre <= 11'd447;
				y0_pre <= 11'd413;
				x1_pre <= 11'd478;
				y1_pre <= 11'd349;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 153 && lines_done) begin
				x0_pre <= 11'd478;
				y0_pre <= 11'd349;
				x1_pre <= 11'd542;
				y1_pre <= 11'd318;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 154 && lines_done) begin
				x0_pre <= 11'd542;
				y0_pre <= 11'd318;
				x1_pre <= 11'd478;
				y1_pre <= 11'd287;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 155 && lines_done) begin
				x0_pre <= 11'd478;
				y0_pre <= 11'd287;
				x1_pre <= 11'd447;
				y1_pre <= 11'd223;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 156 && lines_done) begin
				x0_pre <= 11'd447;
				y0_pre <= 11'd223;
				x1_pre <= 11'd416;
				y1_pre <= 11'd287;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 157 && lines_done) begin
				x0_pre <= 11'd416;
				y0_pre <= 11'd287;
				x1_pre <= 11'd352;
				y1_pre <= 11'd318;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 158 && lines_done) begin
				x0_pre <= 11'd352;
				y0_pre <= 11'd318;
				x1_pre <= 11'd416;
				y1_pre <= 11'd349;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 159 && lines_done) begin
				x0_pre <= 11'd416;
				y0_pre <= 11'd349;
				x1_pre <= 11'd447;
				y1_pre <= 11'd413;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 160 && lines_done) begin
				x0_pre <= 11'd359;
				y0_pre <= 11'd352;
				x1_pre <= 11'd376;
				y1_pre <= 11'd316;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 161 && lines_done) begin
				x0_pre <= 11'd376;
				y0_pre <= 11'd316;
				x1_pre <= 11'd412;
				y1_pre <= 11'd299;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 162 && lines_done) begin
				x0_pre <= 11'd412;
				y0_pre <= 11'd299;
				x1_pre <= 11'd376;
				y1_pre <= 11'd282;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 163 && lines_done) begin
				x0_pre <= 11'd376;
				y0_pre <= 11'd282;
				x1_pre <= 11'd359;
				y1_pre <= 11'd246;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 164 && lines_done) begin
				x0_pre <= 11'd359;
				y0_pre <= 11'd246;
				x1_pre <= 11'd342;
				y1_pre <= 11'd282;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 165 && lines_done) begin
				x0_pre <= 11'd342;
				y0_pre <= 11'd282;
				x1_pre <= 11'd306;
				y1_pre <= 11'd299;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 166 && lines_done) begin
				x0_pre <= 11'd306;
				y0_pre <= 11'd299;
				x1_pre <= 11'd342;
				y1_pre <= 11'd316;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 167 && lines_done) begin
				x0_pre <= 11'd342;
				y0_pre <= 11'd316;
				x1_pre <= 11'd359;
				y1_pre <= 11'd352;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 168 && lines_done) begin
				x0_pre <= 11'd478;
				y0_pre <= 11'd347;
				x1_pre <= 11'd494;
				y1_pre <= 11'd314;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 169 && lines_done) begin
				x0_pre <= 11'd494;
				y0_pre <= 11'd314;
				x1_pre <= 11'd527;
				y1_pre <= 11'd298;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 170 && lines_done) begin
				x0_pre <= 11'd527;
				y0_pre <= 11'd298;
				x1_pre <= 11'd494;
				y1_pre <= 11'd282;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 171 && lines_done) begin
				x0_pre <= 11'd494;
				y0_pre <= 11'd282;
				x1_pre <= 11'd478;
				y1_pre <= 11'd249;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 172 && lines_done) begin
				x0_pre <= 11'd478;
				y0_pre <= 11'd249;
				x1_pre <= 11'd462;
				y1_pre <= 11'd282;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 173 && lines_done) begin
				x0_pre <= 11'd462;
				y0_pre <= 11'd282;
				x1_pre <= 11'd429;
				y1_pre <= 11'd298;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 174 && lines_done) begin
				x0_pre <= 11'd429;
				y0_pre <= 11'd298;
				x1_pre <= 11'd462;
				y1_pre <= 11'd314;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 175 && lines_done) begin
				x0_pre <= 11'd462;
				y0_pre <= 11'd314;
				x1_pre <= 11'd478;
				y1_pre <= 11'd347;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 176 && lines_done) begin
				x0_pre <= 11'd426;
				y0_pre <= 11'd344;
				x1_pre <= 11'd447;
				y1_pre <= 11'd301;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 177 && lines_done) begin
				x0_pre <= 11'd447;
				y0_pre <= 11'd301;
				x1_pre <= 11'd490;
				y1_pre <= 11'd280;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 178 && lines_done) begin
				x0_pre <= 11'd490;
				y0_pre <= 11'd280;
				x1_pre <= 11'd447;
				y1_pre <= 11'd259;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 179 && lines_done) begin
				x0_pre <= 11'd447;
				y0_pre <= 11'd259;
				x1_pre <= 11'd426;
				y1_pre <= 11'd216;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 180 && lines_done) begin
				x0_pre <= 11'd426;
				y0_pre <= 11'd216;
				x1_pre <= 11'd405;
				y1_pre <= 11'd259;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 181 && lines_done) begin
				x0_pre <= 11'd405;
				y0_pre <= 11'd259;
				x1_pre <= 11'd362;
				y1_pre <= 11'd280;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 182 && lines_done) begin
				x0_pre <= 11'd362;
				y0_pre <= 11'd280;
				x1_pre <= 11'd405;
				y1_pre <= 11'd301;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 183 && lines_done) begin
				x0_pre <= 11'd405;
				y0_pre <= 11'd301;
				x1_pre <= 11'd426;
				y1_pre <= 11'd344;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 184 && lines_done) begin
				x0_pre <= 11'd437;
				y0_pre <= 11'd221;
				x1_pre <= 11'd470;
				y1_pre <= 11'd154;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 185 && lines_done) begin
				x0_pre <= 11'd470;
				y0_pre <= 11'd154;
				x1_pre <= 11'd537;
				y1_pre <= 11'd121;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 186 && lines_done) begin
				x0_pre <= 11'd537;
				y0_pre <= 11'd121;
				x1_pre <= 11'd470;
				y1_pre <= 11'd88;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 187 && lines_done) begin
				x0_pre <= 11'd470;
				y0_pre <= 11'd88;
				x1_pre <= 11'd437;
				y1_pre <= 11'd21;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 188 && lines_done) begin
				x0_pre <= 11'd437;
				y0_pre <= 11'd21;
				x1_pre <= 11'd404;
				y1_pre <= 11'd88;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 189 && lines_done) begin
				x0_pre <= 11'd404;
				y0_pre <= 11'd88;
				x1_pre <= 11'd337;
				y1_pre <= 11'd121;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 190 && lines_done) begin
				x0_pre <= 11'd337;
				y0_pre <= 11'd121;
				x1_pre <= 11'd404;
				y1_pre <= 11'd154;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 191 && lines_done) begin
				x0_pre <= 11'd404;
				y0_pre <= 11'd154;
				x1_pre <= 11'd437;
				y1_pre <= 11'd221;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 192 && lines_done) begin
				x0_pre <= 11'd375;
				y0_pre <= 11'd261;
				x1_pre <= 11'd404;
				y1_pre <= 11'd202;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 193 && lines_done) begin
				x0_pre <= 11'd404;
				y0_pre <= 11'd202;
				x1_pre <= 11'd463;
				y1_pre <= 11'd173;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 194 && lines_done) begin
				x0_pre <= 11'd463;
				y0_pre <= 11'd173;
				x1_pre <= 11'd404;
				y1_pre <= 11'd144;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 195 && lines_done) begin
				x0_pre <= 11'd404;
				y0_pre <= 11'd144;
				x1_pre <= 11'd375;
				y1_pre <= 11'd85;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 196 && lines_done) begin
				x0_pre <= 11'd375;
				y0_pre <= 11'd85;
				x1_pre <= 11'd346;
				y1_pre <= 11'd144;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 197 && lines_done) begin
				x0_pre <= 11'd346;
				y0_pre <= 11'd144;
				x1_pre <= 11'd287;
				y1_pre <= 11'd173;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 198 && lines_done) begin
				x0_pre <= 11'd287;
				y0_pre <= 11'd173;
				x1_pre <= 11'd346;
				y1_pre <= 11'd202;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 199 && lines_done) begin
				x0_pre <= 11'd346;
				y0_pre <= 11'd202;
				x1_pre <= 11'd375;
				y1_pre <= 11'd261;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 200 && lines_done) begin
				x0_pre <= 11'd284;
				y0_pre <= 11'd250;
				x1_pre <= 11'd299;
				y1_pre <= 11'd218;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 201 && lines_done) begin
				x0_pre <= 11'd299;
				y0_pre <= 11'd218;
				x1_pre <= 11'd331;
				y1_pre <= 11'd203;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 202 && lines_done) begin
				x0_pre <= 11'd331;
				y0_pre <= 11'd203;
				x1_pre <= 11'd299;
				y1_pre <= 11'd188;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 203 && lines_done) begin
				x0_pre <= 11'd299;
				y0_pre <= 11'd188;
				x1_pre <= 11'd284;
				y1_pre <= 11'd156;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 204 && lines_done) begin
				x0_pre <= 11'd284;
				y0_pre <= 11'd156;
				x1_pre <= 11'd269;
				y1_pre <= 11'd188;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 205 && lines_done) begin
				x0_pre <= 11'd269;
				y0_pre <= 11'd188;
				x1_pre <= 11'd237;
				y1_pre <= 11'd203;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 206 && lines_done) begin
				x0_pre <= 11'd237;
				y0_pre <= 11'd203;
				x1_pre <= 11'd269;
				y1_pre <= 11'd218;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 207 && lines_done) begin
				x0_pre <= 11'd269;
				y0_pre <= 11'd218;
				x1_pre <= 11'd284;
				y1_pre <= 11'd250;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 208 && lines_done) begin
				x0_pre <= 11'd386;
				y0_pre <= 11'd334;
				x1_pre <= 11'd400;
				y1_pre <= 11'd304;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 209 && lines_done) begin
				x0_pre <= 11'd400;
				y0_pre <= 11'd304;
				x1_pre <= 11'd430;
				y1_pre <= 11'd290;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 210 && lines_done) begin
				x0_pre <= 11'd430;
				y0_pre <= 11'd290;
				x1_pre <= 11'd400;
				y1_pre <= 11'd276;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 211 && lines_done) begin
				x0_pre <= 11'd400;
				y0_pre <= 11'd276;
				x1_pre <= 11'd386;
				y1_pre <= 11'd246;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 212 && lines_done) begin
				x0_pre <= 11'd386;
				y0_pre <= 11'd246;
				x1_pre <= 11'd372;
				y1_pre <= 11'd276;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 213 && lines_done) begin
				x0_pre <= 11'd372;
				y0_pre <= 11'd276;
				x1_pre <= 11'd342;
				y1_pre <= 11'd290;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 214 && lines_done) begin
				x0_pre <= 11'd342;
				y0_pre <= 11'd290;
				x1_pre <= 11'd372;
				y1_pre <= 11'd304;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 215 && lines_done) begin
				x0_pre <= 11'd372;
				y0_pre <= 11'd304;
				x1_pre <= 11'd386;
				y1_pre <= 11'd334;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 216 && lines_done) begin
				x0_pre <= 11'd231;
				y0_pre <= 11'd223;
				x1_pre <= 11'd246;
				y1_pre <= 11'd191;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 217 && lines_done) begin
				x0_pre <= 11'd246;
				y0_pre <= 11'd191;
				x1_pre <= 11'd278;
				y1_pre <= 11'd176;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 218 && lines_done) begin
				x0_pre <= 11'd278;
				y0_pre <= 11'd176;
				x1_pre <= 11'd246;
				y1_pre <= 11'd161;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 219 && lines_done) begin
				x0_pre <= 11'd246;
				y0_pre <= 11'd161;
				x1_pre <= 11'd231;
				y1_pre <= 11'd129;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 220 && lines_done) begin
				x0_pre <= 11'd231;
				y0_pre <= 11'd129;
				x1_pre <= 11'd216;
				y1_pre <= 11'd161;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 221 && lines_done) begin
				x0_pre <= 11'd216;
				y0_pre <= 11'd161;
				x1_pre <= 11'd184;
				y1_pre <= 11'd176;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 222 && lines_done) begin
				x0_pre <= 11'd184;
				y0_pre <= 11'd176;
				x1_pre <= 11'd216;
				y1_pre <= 11'd191;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 223 && lines_done) begin
				x0_pre <= 11'd216;
				y0_pre <= 11'd191;
				x1_pre <= 11'd231;
				y1_pre <= 11'd223;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 224 && lines_done) begin
				x0_pre <= 11'd171;
				y0_pre <= 11'd260;
				x1_pre <= 11'd187;
				y1_pre <= 11'd226;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 225 && lines_done) begin
				x0_pre <= 11'd187;
				y0_pre <= 11'd226;
				x1_pre <= 11'd221;
				y1_pre <= 11'd210;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 226 && lines_done) begin
				x0_pre <= 11'd221;
				y0_pre <= 11'd210;
				x1_pre <= 11'd187;
				y1_pre <= 11'd194;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 227 && lines_done) begin
				x0_pre <= 11'd187;
				y0_pre <= 11'd194;
				x1_pre <= 11'd171;
				y1_pre <= 11'd160;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 228 && lines_done) begin
				x0_pre <= 11'd171;
				y0_pre <= 11'd160;
				x1_pre <= 11'd155;
				y1_pre <= 11'd194;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 229 && lines_done) begin
				x0_pre <= 11'd155;
				y0_pre <= 11'd194;
				x1_pre <= 11'd121;
				y1_pre <= 11'd210;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 230 && lines_done) begin
				x0_pre <= 11'd121;
				y0_pre <= 11'd210;
				x1_pre <= 11'd155;
				y1_pre <= 11'd226;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 231 && lines_done) begin
				x0_pre <= 11'd155;
				y0_pre <= 11'd226;
				x1_pre <= 11'd171;
				y1_pre <= 11'd260;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 232 && lines_done) begin
				x0_pre <= 11'd444;
				y0_pre <= 11'd193;
				x1_pre <= 11'd461;
				y1_pre <= 11'd158;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 233 && lines_done) begin
				x0_pre <= 11'd461;
				y0_pre <= 11'd158;
				x1_pre <= 11'd496;
				y1_pre <= 11'd141;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 234 && lines_done) begin
				x0_pre <= 11'd496;
				y0_pre <= 11'd141;
				x1_pre <= 11'd461;
				y1_pre <= 11'd124;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 235 && lines_done) begin
				x0_pre <= 11'd461;
				y0_pre <= 11'd124;
				x1_pre <= 11'd444;
				y1_pre <= 11'd89;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 236 && lines_done) begin
				x0_pre <= 11'd444;
				y0_pre <= 11'd89;
				x1_pre <= 11'd427;
				y1_pre <= 11'd124;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 237 && lines_done) begin
				x0_pre <= 11'd427;
				y0_pre <= 11'd124;
				x1_pre <= 11'd392;
				y1_pre <= 11'd141;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 238 && lines_done) begin
				x0_pre <= 11'd392;
				y0_pre <= 11'd141;
				x1_pre <= 11'd427;
				y1_pre <= 11'd158;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 239 && lines_done) begin
				x0_pre <= 11'd427;
				y0_pre <= 11'd158;
				x1_pre <= 11'd444;
				y1_pre <= 11'd193;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 240 && lines_done) begin
				x0_pre <= 11'd190;
				y0_pre <= 11'd185;
				x1_pre <= 11'd210;
				y1_pre <= 11'd145;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 241 && lines_done) begin
				x0_pre <= 11'd210;
				y0_pre <= 11'd145;
				x1_pre <= 11'd250;
				y1_pre <= 11'd125;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 242 && lines_done) begin
				x0_pre <= 11'd250;
				y0_pre <= 11'd125;
				x1_pre <= 11'd210;
				y1_pre <= 11'd105;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 243 && lines_done) begin
				x0_pre <= 11'd210;
				y0_pre <= 11'd105;
				x1_pre <= 11'd190;
				y1_pre <= 11'd65;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 244 && lines_done) begin
				x0_pre <= 11'd190;
				y0_pre <= 11'd65;
				x1_pre <= 11'd170;
				y1_pre <= 11'd105;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 245 && lines_done) begin
				x0_pre <= 11'd170;
				y0_pre <= 11'd105;
				x1_pre <= 11'd130;
				y1_pre <= 11'd125;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 246 && lines_done) begin
				x0_pre <= 11'd130;
				y0_pre <= 11'd125;
				x1_pre <= 11'd170;
				y1_pre <= 11'd145;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 247 && lines_done) begin
				x0_pre <= 11'd170;
				y0_pre <= 11'd145;
				x1_pre <= 11'd190;
				y1_pre <= 11'd185;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 248 && lines_done) begin
				x0_pre <= 11'd303;
				y0_pre <= 11'd405;
				x1_pre <= 11'd335;
				y1_pre <= 11'd340;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 249 && lines_done) begin
				x0_pre <= 11'd335;
				y0_pre <= 11'd340;
				x1_pre <= 11'd400;
				y1_pre <= 11'd308;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 250 && lines_done) begin
				x0_pre <= 11'd400;
				y0_pre <= 11'd308;
				x1_pre <= 11'd335;
				y1_pre <= 11'd276;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 251 && lines_done) begin
				x0_pre <= 11'd335;
				y0_pre <= 11'd276;
				x1_pre <= 11'd303;
				y1_pre <= 11'd211;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 252 && lines_done) begin
				x0_pre <= 11'd303;
				y0_pre <= 11'd211;
				x1_pre <= 11'd271;
				y1_pre <= 11'd276;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 253 && lines_done) begin
				x0_pre <= 11'd271;
				y0_pre <= 11'd276;
				x1_pre <= 11'd206;
				y1_pre <= 11'd308;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 254 && lines_done) begin
				x0_pre <= 11'd206;
				y0_pre <= 11'd308;
				x1_pre <= 11'd271;
				y1_pre <= 11'd340;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 255 && lines_done) begin
				x0_pre <= 11'd271;
				y0_pre <= 11'd340;
				x1_pre <= 11'd303;
				y1_pre <= 11'd405;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 256 && lines_done) begin
				x0_pre <= 11'd170;
				y0_pre <= 11'd178;
				x1_pre <= 11'd192;
				y1_pre <= 11'd134;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 257 && lines_done) begin
				x0_pre <= 11'd192;
				y0_pre <= 11'd134;
				x1_pre <= 11'd236;
				y1_pre <= 11'd112;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 258 && lines_done) begin
				x0_pre <= 11'd236;
				y0_pre <= 11'd112;
				x1_pre <= 11'd192;
				y1_pre <= 11'd90;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 259 && lines_done) begin
				x0_pre <= 11'd192;
				y0_pre <= 11'd90;
				x1_pre <= 11'd170;
				y1_pre <= 11'd46;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 260 && lines_done) begin
				x0_pre <= 11'd170;
				y0_pre <= 11'd46;
				x1_pre <= 11'd148;
				y1_pre <= 11'd90;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 261 && lines_done) begin
				x0_pre <= 11'd148;
				y0_pre <= 11'd90;
				x1_pre <= 11'd104;
				y1_pre <= 11'd112;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 262 && lines_done) begin
				x0_pre <= 11'd104;
				y0_pre <= 11'd112;
				x1_pre <= 11'd148;
				y1_pre <= 11'd134;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 263 && lines_done) begin
				x0_pre <= 11'd148;
				y0_pre <= 11'd134;
				x1_pre <= 11'd170;
				y1_pre <= 11'd178;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 264 && lines_done) begin
				x0_pre <= 11'd161;
				y0_pre <= 11'd315;
				x1_pre <= 11'd193;
				y1_pre <= 11'd250;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 265 && lines_done) begin
				x0_pre <= 11'd193;
				y0_pre <= 11'd250;
				x1_pre <= 11'd258;
				y1_pre <= 11'd218;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 266 && lines_done) begin
				x0_pre <= 11'd258;
				y0_pre <= 11'd218;
				x1_pre <= 11'd193;
				y1_pre <= 11'd186;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 267 && lines_done) begin
				x0_pre <= 11'd193;
				y0_pre <= 11'd186;
				x1_pre <= 11'd161;
				y1_pre <= 11'd121;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 268 && lines_done) begin
				x0_pre <= 11'd161;
				y0_pre <= 11'd121;
				x1_pre <= 11'd129;
				y1_pre <= 11'd186;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 269 && lines_done) begin
				x0_pre <= 11'd129;
				y0_pre <= 11'd186;
				x1_pre <= 11'd64;
				y1_pre <= 11'd218;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 270 && lines_done) begin
				x0_pre <= 11'd64;
				y0_pre <= 11'd218;
				x1_pre <= 11'd129;
				y1_pre <= 11'd250;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 271 && lines_done) begin
				x0_pre <= 11'd129;
				y0_pre <= 11'd250;
				x1_pre <= 11'd161;
				y1_pre <= 11'd315;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 272 && lines_done) begin
				x0_pre <= 11'd407;
				y0_pre <= 11'd251;
				x1_pre <= 11'd437;
				y1_pre <= 11'd191;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 273 && lines_done) begin
				x0_pre <= 11'd437;
				y0_pre <= 11'd191;
				x1_pre <= 11'd497;
				y1_pre <= 11'd161;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 274 && lines_done) begin
				x0_pre <= 11'd497;
				y0_pre <= 11'd161;
				x1_pre <= 11'd437;
				y1_pre <= 11'd131;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 275 && lines_done) begin
				x0_pre <= 11'd437;
				y0_pre <= 11'd131;
				x1_pre <= 11'd407;
				y1_pre <= 11'd71;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 276 && lines_done) begin
				x0_pre <= 11'd407;
				y0_pre <= 11'd71;
				x1_pre <= 11'd377;
				y1_pre <= 11'd131;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 277 && lines_done) begin
				x0_pre <= 11'd377;
				y0_pre <= 11'd131;
				x1_pre <= 11'd317;
				y1_pre <= 11'd161;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 278 && lines_done) begin
				x0_pre <= 11'd317;
				y0_pre <= 11'd161;
				x1_pre <= 11'd377;
				y1_pre <= 11'd191;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 279 && lines_done) begin
				x0_pre <= 11'd377;
				y0_pre <= 11'd191;
				x1_pre <= 11'd407;
				y1_pre <= 11'd251;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 280 && lines_done) begin
				x0_pre <= 11'd500;
				y0_pre <= 11'd202;
				x1_pre <= 11'd524;
				y1_pre <= 11'd154;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 281 && lines_done) begin
				x0_pre <= 11'd524;
				y0_pre <= 11'd154;
				x1_pre <= 11'd572;
				y1_pre <= 11'd130;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 282 && lines_done) begin
				x0_pre <= 11'd572;
				y0_pre <= 11'd130;
				x1_pre <= 11'd524;
				y1_pre <= 11'd106;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 283 && lines_done) begin
				x0_pre <= 11'd524;
				y0_pre <= 11'd106;
				x1_pre <= 11'd500;
				y1_pre <= 11'd58;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 284 && lines_done) begin
				x0_pre <= 11'd500;
				y0_pre <= 11'd58;
				x1_pre <= 11'd476;
				y1_pre <= 11'd106;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 285 && lines_done) begin
				x0_pre <= 11'd476;
				y0_pre <= 11'd106;
				x1_pre <= 11'd428;
				y1_pre <= 11'd130;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 286 && lines_done) begin
				x0_pre <= 11'd428;
				y0_pre <= 11'd130;
				x1_pre <= 11'd476;
				y1_pre <= 11'd154;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 287 && lines_done) begin
				x0_pre <= 11'd476;
				y0_pre <= 11'd154;
				x1_pre <= 11'd500;
				y1_pre <= 11'd202;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 288 && lines_done) begin
				x0_pre <= 11'd384;
				y0_pre <= 11'd206;
				x1_pre <= 11'd407;
				y1_pre <= 11'd158;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 289 && lines_done) begin
				x0_pre <= 11'd407;
				y0_pre <= 11'd158;
				x1_pre <= 11'd455;
				y1_pre <= 11'd135;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 290 && lines_done) begin
				x0_pre <= 11'd455;
				y0_pre <= 11'd135;
				x1_pre <= 11'd407;
				y1_pre <= 11'd112;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 291 && lines_done) begin
				x0_pre <= 11'd407;
				y0_pre <= 11'd112;
				x1_pre <= 11'd384;
				y1_pre <= 11'd64;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 292 && lines_done) begin
				x0_pre <= 11'd384;
				y0_pre <= 11'd64;
				x1_pre <= 11'd361;
				y1_pre <= 11'd112;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 293 && lines_done) begin
				x0_pre <= 11'd361;
				y0_pre <= 11'd112;
				x1_pre <= 11'd313;
				y1_pre <= 11'd135;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 294 && lines_done) begin
				x0_pre <= 11'd313;
				y0_pre <= 11'd135;
				x1_pre <= 11'd361;
				y1_pre <= 11'd158;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 295 && lines_done) begin
				x0_pre <= 11'd361;
				y0_pre <= 11'd158;
				x1_pre <= 11'd384;
				y1_pre <= 11'd206;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 296 && lines_done) begin
				x0_pre <= 11'd386;
				y0_pre <= 11'd351;
				x1_pre <= 11'd416;
				y1_pre <= 11'd291;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 297 && lines_done) begin
				x0_pre <= 11'd416;
				y0_pre <= 11'd291;
				x1_pre <= 11'd476;
				y1_pre <= 11'd261;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 298 && lines_done) begin
				x0_pre <= 11'd476;
				y0_pre <= 11'd261;
				x1_pre <= 11'd416;
				y1_pre <= 11'd231;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 299 && lines_done) begin
				x0_pre <= 11'd416;
				y0_pre <= 11'd231;
				x1_pre <= 11'd386;
				y1_pre <= 11'd171;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 300 && lines_done) begin
				x0_pre <= 11'd386;
				y0_pre <= 11'd171;
				x1_pre <= 11'd356;
				y1_pre <= 11'd231;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 301 && lines_done) begin
				x0_pre <= 11'd356;
				y0_pre <= 11'd231;
				x1_pre <= 11'd296;
				y1_pre <= 11'd261;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 302 && lines_done) begin
				x0_pre <= 11'd296;
				y0_pre <= 11'd261;
				x1_pre <= 11'd356;
				y1_pre <= 11'd291;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 303 && lines_done) begin
				x0_pre <= 11'd356;
				y0_pre <= 11'd291;
				x1_pre <= 11'd386;
				y1_pre <= 11'd351;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 304 && lines_done) begin
				x0_pre <= 11'd403;
				y0_pre <= 11'd229;
				x1_pre <= 11'd425;
				y1_pre <= 11'd183;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 305 && lines_done) begin
				x0_pre <= 11'd425;
				y0_pre <= 11'd183;
				x1_pre <= 11'd471;
				y1_pre <= 11'd161;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 306 && lines_done) begin
				x0_pre <= 11'd471;
				y0_pre <= 11'd161;
				x1_pre <= 11'd425;
				y1_pre <= 11'd139;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 307 && lines_done) begin
				x0_pre <= 11'd425;
				y0_pre <= 11'd139;
				x1_pre <= 11'd403;
				y1_pre <= 11'd93;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 308 && lines_done) begin
				x0_pre <= 11'd403;
				y0_pre <= 11'd93;
				x1_pre <= 11'd381;
				y1_pre <= 11'd139;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 309 && lines_done) begin
				x0_pre <= 11'd381;
				y0_pre <= 11'd139;
				x1_pre <= 11'd335;
				y1_pre <= 11'd161;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 310 && lines_done) begin
				x0_pre <= 11'd335;
				y0_pre <= 11'd161;
				x1_pre <= 11'd381;
				y1_pre <= 11'd183;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 311 && lines_done) begin
				x0_pre <= 11'd381;
				y0_pre <= 11'd183;
				x1_pre <= 11'd403;
				y1_pre <= 11'd229;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 312 && lines_done) begin
				x0_pre <= 11'd152;
				y0_pre <= 11'd265;
				x1_pre <= 11'd183;
				y1_pre <= 11'd202;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 313 && lines_done) begin
				x0_pre <= 11'd183;
				y0_pre <= 11'd202;
				x1_pre <= 11'd246;
				y1_pre <= 11'd171;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 314 && lines_done) begin
				x0_pre <= 11'd246;
				y0_pre <= 11'd171;
				x1_pre <= 11'd183;
				y1_pre <= 11'd140;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 315 && lines_done) begin
				x0_pre <= 11'd183;
				y0_pre <= 11'd140;
				x1_pre <= 11'd152;
				y1_pre <= 11'd77;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 316 && lines_done) begin
				x0_pre <= 11'd152;
				y0_pre <= 11'd77;
				x1_pre <= 11'd121;
				y1_pre <= 11'd140;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 317 && lines_done) begin
				x0_pre <= 11'd121;
				y0_pre <= 11'd140;
				x1_pre <= 11'd58;
				y1_pre <= 11'd171;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 318 && lines_done) begin
				x0_pre <= 11'd58;
				y0_pre <= 11'd171;
				x1_pre <= 11'd121;
				y1_pre <= 11'd202;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 319 && lines_done) begin
				x0_pre <= 11'd121;
				y0_pre <= 11'd202;
				x1_pre <= 11'd152;
				y1_pre <= 11'd265;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 320 && lines_done) begin
				x0_pre <= 11'd211;
				y0_pre <= 11'd192;
				x1_pre <= 11'd233;
				y1_pre <= 11'd146;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 321 && lines_done) begin
				x0_pre <= 11'd233;
				y0_pre <= 11'd146;
				x1_pre <= 11'd279;
				y1_pre <= 11'd124;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 322 && lines_done) begin
				x0_pre <= 11'd279;
				y0_pre <= 11'd124;
				x1_pre <= 11'd233;
				y1_pre <= 11'd102;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 323 && lines_done) begin
				x0_pre <= 11'd233;
				y0_pre <= 11'd102;
				x1_pre <= 11'd211;
				y1_pre <= 11'd56;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 324 && lines_done) begin
				x0_pre <= 11'd211;
				y0_pre <= 11'd56;
				x1_pre <= 11'd189;
				y1_pre <= 11'd102;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 325 && lines_done) begin
				x0_pre <= 11'd189;
				y0_pre <= 11'd102;
				x1_pre <= 11'd143;
				y1_pre <= 11'd124;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 326 && lines_done) begin
				x0_pre <= 11'd143;
				y0_pre <= 11'd124;
				x1_pre <= 11'd189;
				y1_pre <= 11'd146;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 327 && lines_done) begin
				x0_pre <= 11'd189;
				y0_pre <= 11'd146;
				x1_pre <= 11'd211;
				y1_pre <= 11'd192;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 328 && lines_done) begin
				x0_pre <= 11'd449;
				y0_pre <= 11'd275;
				x1_pre <= 11'd473;
				y1_pre <= 11'd226;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 329 && lines_done) begin
				x0_pre <= 11'd473;
				y0_pre <= 11'd226;
				x1_pre <= 11'd522;
				y1_pre <= 11'd202;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 330 && lines_done) begin
				x0_pre <= 11'd522;
				y0_pre <= 11'd202;
				x1_pre <= 11'd473;
				y1_pre <= 11'd178;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 331 && lines_done) begin
				x0_pre <= 11'd473;
				y0_pre <= 11'd178;
				x1_pre <= 11'd449;
				y1_pre <= 11'd129;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 332 && lines_done) begin
				x0_pre <= 11'd449;
				y0_pre <= 11'd129;
				x1_pre <= 11'd425;
				y1_pre <= 11'd178;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 333 && lines_done) begin
				x0_pre <= 11'd425;
				y0_pre <= 11'd178;
				x1_pre <= 11'd376;
				y1_pre <= 11'd202;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 334 && lines_done) begin
				x0_pre <= 11'd376;
				y0_pre <= 11'd202;
				x1_pre <= 11'd425;
				y1_pre <= 11'd226;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 335 && lines_done) begin
				x0_pre <= 11'd425;
				y0_pre <= 11'd226;
				x1_pre <= 11'd449;
				y1_pre <= 11'd275;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 336 && lines_done) begin
				x0_pre <= 11'd186;
				y0_pre <= 11'd147;
				x1_pre <= 11'd200;
				y1_pre <= 11'd119;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 337 && lines_done) begin
				x0_pre <= 11'd200;
				y0_pre <= 11'd119;
				x1_pre <= 11'd228;
				y1_pre <= 11'd105;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 338 && lines_done) begin
				x0_pre <= 11'd228;
				y0_pre <= 11'd105;
				x1_pre <= 11'd200;
				y1_pre <= 11'd91;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 339 && lines_done) begin
				x0_pre <= 11'd200;
				y0_pre <= 11'd91;
				x1_pre <= 11'd186;
				y1_pre <= 11'd63;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 340 && lines_done) begin
				x0_pre <= 11'd186;
				y0_pre <= 11'd63;
				x1_pre <= 11'd172;
				y1_pre <= 11'd91;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 341 && lines_done) begin
				x0_pre <= 11'd172;
				y0_pre <= 11'd91;
				x1_pre <= 11'd144;
				y1_pre <= 11'd105;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 342 && lines_done) begin
				x0_pre <= 11'd144;
				y0_pre <= 11'd105;
				x1_pre <= 11'd172;
				y1_pre <= 11'd119;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 343 && lines_done) begin
				x0_pre <= 11'd172;
				y0_pre <= 11'd119;
				x1_pre <= 11'd186;
				y1_pre <= 11'd147;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 344 && lines_done) begin
				x0_pre <= 11'd176;
				y0_pre <= 11'd282;
				x1_pre <= 11'd201;
				y1_pre <= 11'd232;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 345 && lines_done) begin
				x0_pre <= 11'd201;
				y0_pre <= 11'd232;
				x1_pre <= 11'd251;
				y1_pre <= 11'd207;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 346 && lines_done) begin
				x0_pre <= 11'd251;
				y0_pre <= 11'd207;
				x1_pre <= 11'd201;
				y1_pre <= 11'd182;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 347 && lines_done) begin
				x0_pre <= 11'd201;
				y0_pre <= 11'd182;
				x1_pre <= 11'd176;
				y1_pre <= 11'd132;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 348 && lines_done) begin
				x0_pre <= 11'd176;
				y0_pre <= 11'd132;
				x1_pre <= 11'd151;
				y1_pre <= 11'd182;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 349 && lines_done) begin
				x0_pre <= 11'd151;
				y0_pre <= 11'd182;
				x1_pre <= 11'd101;
				y1_pre <= 11'd207;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 350 && lines_done) begin
				x0_pre <= 11'd101;
				y0_pre <= 11'd207;
				x1_pre <= 11'd151;
				y1_pre <= 11'd232;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 351 && lines_done) begin
				x0_pre <= 11'd151;
				y0_pre <= 11'd232;
				x1_pre <= 11'd176;
				y1_pre <= 11'd282;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 352 && lines_done) begin
				x0_pre <= 11'd236;
				y0_pre <= 11'd366;
				x1_pre <= 11'd253;
				y1_pre <= 11'd330;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 353 && lines_done) begin
				x0_pre <= 11'd253;
				y0_pre <= 11'd330;
				x1_pre <= 11'd289;
				y1_pre <= 11'd313;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 354 && lines_done) begin
				x0_pre <= 11'd289;
				y0_pre <= 11'd313;
				x1_pre <= 11'd253;
				y1_pre <= 11'd296;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 355 && lines_done) begin
				x0_pre <= 11'd253;
				y0_pre <= 11'd296;
				x1_pre <= 11'd236;
				y1_pre <= 11'd260;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 356 && lines_done) begin
				x0_pre <= 11'd236;
				y0_pre <= 11'd260;
				x1_pre <= 11'd219;
				y1_pre <= 11'd296;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 357 && lines_done) begin
				x0_pre <= 11'd219;
				y0_pre <= 11'd296;
				x1_pre <= 11'd183;
				y1_pre <= 11'd313;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 358 && lines_done) begin
				x0_pre <= 11'd183;
				y0_pre <= 11'd313;
				x1_pre <= 11'd219;
				y1_pre <= 11'd330;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 359 && lines_done) begin
				x0_pre <= 11'd219;
				y0_pre <= 11'd330;
				x1_pre <= 11'd236;
				y1_pre <= 11'd366;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 360 && lines_done) begin
				x0_pre <= 11'd105;
				y0_pre <= 11'd255;
				x1_pre <= 11'd125;
				y1_pre <= 11'd214;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 361 && lines_done) begin
				x0_pre <= 11'd125;
				y0_pre <= 11'd214;
				x1_pre <= 11'd166;
				y1_pre <= 11'd194;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 362 && lines_done) begin
				x0_pre <= 11'd166;
				y0_pre <= 11'd194;
				x1_pre <= 11'd125;
				y1_pre <= 11'd174;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 363 && lines_done) begin
				x0_pre <= 11'd125;
				y0_pre <= 11'd174;
				x1_pre <= 11'd105;
				y1_pre <= 11'd133;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 364 && lines_done) begin
				x0_pre <= 11'd105;
				y0_pre <= 11'd133;
				x1_pre <= 11'd85;
				y1_pre <= 11'd174;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 365 && lines_done) begin
				x0_pre <= 11'd85;
				y0_pre <= 11'd174;
				x1_pre <= 11'd44;
				y1_pre <= 11'd194;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 366 && lines_done) begin
				x0_pre <= 11'd44;
				y0_pre <= 11'd194;
				x1_pre <= 11'd85;
				y1_pre <= 11'd214;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 367 && lines_done) begin
				x0_pre <= 11'd85;
				y0_pre <= 11'd214;
				x1_pre <= 11'd105;
				y1_pre <= 11'd255;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 368 && lines_done) begin
				x0_pre <= 11'd335;
				y0_pre <= 11'd203;
				x1_pre <= 11'd366;
				y1_pre <= 11'd141;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 369 && lines_done) begin
				x0_pre <= 11'd366;
				y0_pre <= 11'd141;
				x1_pre <= 11'd428;
				y1_pre <= 11'd110;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 370 && lines_done) begin
				x0_pre <= 11'd428;
				y0_pre <= 11'd110;
				x1_pre <= 11'd366;
				y1_pre <= 11'd79;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 371 && lines_done) begin
				x0_pre <= 11'd366;
				y0_pre <= 11'd79;
				x1_pre <= 11'd335;
				y1_pre <= 11'd17;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 372 && lines_done) begin
				x0_pre <= 11'd335;
				y0_pre <= 11'd17;
				x1_pre <= 11'd304;
				y1_pre <= 11'd79;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 373 && lines_done) begin
				x0_pre <= 11'd304;
				y0_pre <= 11'd79;
				x1_pre <= 11'd242;
				y1_pre <= 11'd110;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 374 && lines_done) begin
				x0_pre <= 11'd242;
				y0_pre <= 11'd110;
				x1_pre <= 11'd304;
				y1_pre <= 11'd141;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 375 && lines_done) begin
				x0_pre <= 11'd304;
				y0_pre <= 11'd141;
				x1_pre <= 11'd335;
				y1_pre <= 11'd203;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 376 && lines_done) begin
				x0_pre <= 11'd156;
				y0_pre <= 11'd245;
				x1_pre <= 11'd176;
				y1_pre <= 11'd205;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 377 && lines_done) begin
				x0_pre <= 11'd176;
				y0_pre <= 11'd205;
				x1_pre <= 11'd216;
				y1_pre <= 11'd185;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 378 && lines_done) begin
				x0_pre <= 11'd216;
				y0_pre <= 11'd185;
				x1_pre <= 11'd176;
				y1_pre <= 11'd165;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 379 && lines_done) begin
				x0_pre <= 11'd176;
				y0_pre <= 11'd165;
				x1_pre <= 11'd156;
				y1_pre <= 11'd125;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 380 && lines_done) begin
				x0_pre <= 11'd156;
				y0_pre <= 11'd125;
				x1_pre <= 11'd136;
				y1_pre <= 11'd165;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 381 && lines_done) begin
				x0_pre <= 11'd136;
				y0_pre <= 11'd165;
				x1_pre <= 11'd96;
				y1_pre <= 11'd185;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 382 && lines_done) begin
				x0_pre <= 11'd96;
				y0_pre <= 11'd185;
				x1_pre <= 11'd136;
				y1_pre <= 11'd205;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 383 && lines_done) begin
				x0_pre <= 11'd136;
				y0_pre <= 11'd205;
				x1_pre <= 11'd156;
				y1_pre <= 11'd245;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 384 && lines_done) begin
				x0_pre <= 11'd477;
				y0_pre <= 11'd360;
				x1_pre <= 11'd498;
				y1_pre <= 11'd316;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 385 && lines_done) begin
				x0_pre <= 11'd498;
				y0_pre <= 11'd316;
				x1_pre <= 11'd542;
				y1_pre <= 11'd295;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 386 && lines_done) begin
				x0_pre <= 11'd542;
				y0_pre <= 11'd295;
				x1_pre <= 11'd498;
				y1_pre <= 11'd274;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 387 && lines_done) begin
				x0_pre <= 11'd498;
				y0_pre <= 11'd274;
				x1_pre <= 11'd477;
				y1_pre <= 11'd230;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 388 && lines_done) begin
				x0_pre <= 11'd477;
				y0_pre <= 11'd230;
				x1_pre <= 11'd456;
				y1_pre <= 11'd274;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 389 && lines_done) begin
				x0_pre <= 11'd456;
				y0_pre <= 11'd274;
				x1_pre <= 11'd412;
				y1_pre <= 11'd295;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 390 && lines_done) begin
				x0_pre <= 11'd412;
				y0_pre <= 11'd295;
				x1_pre <= 11'd456;
				y1_pre <= 11'd316;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 391 && lines_done) begin
				x0_pre <= 11'd456;
				y0_pre <= 11'd316;
				x1_pre <= 11'd477;
				y1_pre <= 11'd360;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 392 && lines_done) begin
				x0_pre <= 11'd129;
				y0_pre <= 11'd235;
				x1_pre <= 11'd151;
				y1_pre <= 11'd189;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 393 && lines_done) begin
				x0_pre <= 11'd151;
				y0_pre <= 11'd189;
				x1_pre <= 11'd197;
				y1_pre <= 11'd167;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 394 && lines_done) begin
				x0_pre <= 11'd197;
				y0_pre <= 11'd167;
				x1_pre <= 11'd151;
				y1_pre <= 11'd145;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 395 && lines_done) begin
				x0_pre <= 11'd151;
				y0_pre <= 11'd145;
				x1_pre <= 11'd129;
				y1_pre <= 11'd99;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 396 && lines_done) begin
				x0_pre <= 11'd129;
				y0_pre <= 11'd99;
				x1_pre <= 11'd107;
				y1_pre <= 11'd145;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 397 && lines_done) begin
				x0_pre <= 11'd107;
				y0_pre <= 11'd145;
				x1_pre <= 11'd61;
				y1_pre <= 11'd167;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 398 && lines_done) begin
				x0_pre <= 11'd61;
				y0_pre <= 11'd167;
				x1_pre <= 11'd107;
				y1_pre <= 11'd189;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 399 && lines_done) begin
				x0_pre <= 11'd107;
				y0_pre <= 11'd189;
				x1_pre <= 11'd129;
				y1_pre <= 11'd235;
				// frame is complete
				lines_counter <= 0;
				frame_complete <= 1;
				x_offset <= x_offset + 20;
				y_offset <= y_offset + 10;
			end
		end
	end
endmodule