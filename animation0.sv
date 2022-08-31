/* 
 * Animation
 *
 * Top level module for line_drawer.sv and clear_screen.sv,
 * creates an animation using the two modules.
 * 
 */
module animation0(input  logic clk, reset,
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
				x0_pre <= 11'd321;
				y0_pre <= 11'd103;
				x1_pre <= 11'd321;
				y1_pre <= 11'd209;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 1 && lines_done) begin
				x0_pre <= 11'd321;
				y0_pre <= 11'd209;
				x1_pre <= 11'd427;
				y1_pre <= 11'd209;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 2 && lines_done) begin
				x0_pre <= 11'd427;
				y0_pre <= 11'd209;
				x1_pre <= 11'd427;
				y1_pre <= 11'd103;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 3 && lines_done) begin
				x0_pre <= 11'd427;
				y0_pre <= 11'd103;
				x1_pre <= 11'd321;
				y1_pre <= 11'd103;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 4 && lines_done) begin
				x0_pre <= 11'd260;
				y0_pre <= 11'd214;
				x1_pre <= 11'd260;
				y1_pre <= 11'd321;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 5 && lines_done) begin
				x0_pre <= 11'd260;
				y0_pre <= 11'd321;
				x1_pre <= 11'd367;
				y1_pre <= 11'd321;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 6 && lines_done) begin
				x0_pre <= 11'd367;
				y0_pre <= 11'd321;
				x1_pre <= 11'd367;
				y1_pre <= 11'd214;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 7 && lines_done) begin
				x0_pre <= 11'd367;
				y0_pre <= 11'd214;
				x1_pre <= 11'd260;
				y1_pre <= 11'd214;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 8 && lines_done) begin
				x0_pre <= 11'd485;
				y0_pre <= 11'd279;
				x1_pre <= 11'd485;
				y1_pre <= 11'd359;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 9 && lines_done) begin
				x0_pre <= 11'd485;
				y0_pre <= 11'd359;
				x1_pre <= 11'd565;
				y1_pre <= 11'd359;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 10 && lines_done) begin
				x0_pre <= 11'd565;
				y0_pre <= 11'd359;
				x1_pre <= 11'd565;
				y1_pre <= 11'd279;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 11 && lines_done) begin
				x0_pre <= 11'd565;
				y0_pre <= 11'd279;
				x1_pre <= 11'd485;
				y1_pre <= 11'd279;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 12 && lines_done) begin
				x0_pre <= 11'd360;
				y0_pre <= 11'd207;
				x1_pre <= 11'd360;
				y1_pre <= 11'd247;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 13 && lines_done) begin
				x0_pre <= 11'd360;
				y0_pre <= 11'd247;
				x1_pre <= 11'd400;
				y1_pre <= 11'd247;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 14 && lines_done) begin
				x0_pre <= 11'd400;
				y0_pre <= 11'd247;
				x1_pre <= 11'd400;
				y1_pre <= 11'd207;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 15 && lines_done) begin
				x0_pre <= 11'd400;
				y0_pre <= 11'd207;
				x1_pre <= 11'd360;
				y1_pre <= 11'd207;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 16 && lines_done) begin
				x0_pre <= 11'd222;
				y0_pre <= 11'd226;
				x1_pre <= 11'd222;
				y1_pre <= 11'd310;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 17 && lines_done) begin
				x0_pre <= 11'd222;
				y0_pre <= 11'd310;
				x1_pre <= 11'd306;
				y1_pre <= 11'd310;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 18 && lines_done) begin
				x0_pre <= 11'd306;
				y0_pre <= 11'd310;
				x1_pre <= 11'd306;
				y1_pre <= 11'd226;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 19 && lines_done) begin
				x0_pre <= 11'd306;
				y0_pre <= 11'd226;
				x1_pre <= 11'd222;
				y1_pre <= 11'd226;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 20 && lines_done) begin
				x0_pre <= 11'd326;
				y0_pre <= 11'd60;
				x1_pre <= 11'd326;
				y1_pre <= 11'd126;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 21 && lines_done) begin
				x0_pre <= 11'd326;
				y0_pre <= 11'd126;
				x1_pre <= 11'd392;
				y1_pre <= 11'd126;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 22 && lines_done) begin
				x0_pre <= 11'd392;
				y0_pre <= 11'd126;
				x1_pre <= 11'd392;
				y1_pre <= 11'd60;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 23 && lines_done) begin
				x0_pre <= 11'd392;
				y0_pre <= 11'd60;
				x1_pre <= 11'd326;
				y1_pre <= 11'd60;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 24 && lines_done) begin
				x0_pre <= 11'd225;
				y0_pre <= 11'd71;
				x1_pre <= 11'd225;
				y1_pre <= 11'd174;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 25 && lines_done) begin
				x0_pre <= 11'd225;
				y0_pre <= 11'd174;
				x1_pre <= 11'd328;
				y1_pre <= 11'd174;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 26 && lines_done) begin
				x0_pre <= 11'd328;
				y0_pre <= 11'd174;
				x1_pre <= 11'd328;
				y1_pre <= 11'd71;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 27 && lines_done) begin
				x0_pre <= 11'd328;
				y0_pre <= 11'd71;
				x1_pre <= 11'd225;
				y1_pre <= 11'd71;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 28 && lines_done) begin
				x0_pre <= 11'd20;
				y0_pre <= 11'd12;
				x1_pre <= 11'd20;
				y1_pre <= 11'd94;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 29 && lines_done) begin
				x0_pre <= 11'd20;
				y0_pre <= 11'd94;
				x1_pre <= 11'd102;
				y1_pre <= 11'd94;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 30 && lines_done) begin
				x0_pre <= 11'd102;
				y0_pre <= 11'd94;
				x1_pre <= 11'd102;
				y1_pre <= 11'd12;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 31 && lines_done) begin
				x0_pre <= 11'd102;
				y0_pre <= 11'd12;
				x1_pre <= 11'd20;
				y1_pre <= 11'd12;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 32 && lines_done) begin
				x0_pre <= 11'd108;
				y0_pre <= 11'd97;
				x1_pre <= 11'd108;
				y1_pre <= 11'd127;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 33 && lines_done) begin
				x0_pre <= 11'd108;
				y0_pre <= 11'd127;
				x1_pre <= 11'd138;
				y1_pre <= 11'd127;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 34 && lines_done) begin
				x0_pre <= 11'd138;
				y0_pre <= 11'd127;
				x1_pre <= 11'd138;
				y1_pre <= 11'd97;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 35 && lines_done) begin
				x0_pre <= 11'd138;
				y0_pre <= 11'd97;
				x1_pre <= 11'd108;
				y1_pre <= 11'd97;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 36 && lines_done) begin
				x0_pre <= 11'd284;
				y0_pre <= 11'd129;
				x1_pre <= 11'd284;
				y1_pre <= 11'd203;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 37 && lines_done) begin
				x0_pre <= 11'd284;
				y0_pre <= 11'd203;
				x1_pre <= 11'd358;
				y1_pre <= 11'd203;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 38 && lines_done) begin
				x0_pre <= 11'd358;
				y0_pre <= 11'd203;
				x1_pre <= 11'd358;
				y1_pre <= 11'd129;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 39 && lines_done) begin
				x0_pre <= 11'd358;
				y0_pre <= 11'd129;
				x1_pre <= 11'd284;
				y1_pre <= 11'd129;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 40 && lines_done) begin
				x0_pre <= 11'd178;
				y0_pre <= 11'd163;
				x1_pre <= 11'd178;
				y1_pre <= 11'd228;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 41 && lines_done) begin
				x0_pre <= 11'd178;
				y0_pre <= 11'd228;
				x1_pre <= 11'd243;
				y1_pre <= 11'd228;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 42 && lines_done) begin
				x0_pre <= 11'd243;
				y0_pre <= 11'd228;
				x1_pre <= 11'd243;
				y1_pre <= 11'd163;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 43 && lines_done) begin
				x0_pre <= 11'd243;
				y0_pre <= 11'd163;
				x1_pre <= 11'd178;
				y1_pre <= 11'd163;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 44 && lines_done) begin
				x0_pre <= 11'd31;
				y0_pre <= 11'd159;
				x1_pre <= 11'd31;
				y1_pre <= 11'd189;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 45 && lines_done) begin
				x0_pre <= 11'd31;
				y0_pre <= 11'd189;
				x1_pre <= 11'd61;
				y1_pre <= 11'd189;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 46 && lines_done) begin
				x0_pre <= 11'd61;
				y0_pre <= 11'd189;
				x1_pre <= 11'd61;
				y1_pre <= 11'd159;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 47 && lines_done) begin
				x0_pre <= 11'd61;
				y0_pre <= 11'd159;
				x1_pre <= 11'd31;
				y1_pre <= 11'd159;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 48 && lines_done) begin
				x0_pre <= 11'd201;
				y0_pre <= 11'd65;
				x1_pre <= 11'd201;
				y1_pre <= 11'd117;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 49 && lines_done) begin
				x0_pre <= 11'd201;
				y0_pre <= 11'd117;
				x1_pre <= 11'd253;
				y1_pre <= 11'd117;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 50 && lines_done) begin
				x0_pre <= 11'd253;
				y0_pre <= 11'd117;
				x1_pre <= 11'd253;
				y1_pre <= 11'd65;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 51 && lines_done) begin
				x0_pre <= 11'd253;
				y0_pre <= 11'd65;
				x1_pre <= 11'd201;
				y1_pre <= 11'd65;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 52 && lines_done) begin
				x0_pre <= 11'd426;
				y0_pre <= 11'd128;
				x1_pre <= 11'd426;
				y1_pre <= 11'd241;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 53 && lines_done) begin
				x0_pre <= 11'd426;
				y0_pre <= 11'd241;
				x1_pre <= 11'd539;
				y1_pre <= 11'd241;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 54 && lines_done) begin
				x0_pre <= 11'd539;
				y0_pre <= 11'd241;
				x1_pre <= 11'd539;
				y1_pre <= 11'd128;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 55 && lines_done) begin
				x0_pre <= 11'd539;
				y0_pre <= 11'd128;
				x1_pre <= 11'd426;
				y1_pre <= 11'd128;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 56 && lines_done) begin
				x0_pre <= 11'd457;
				y0_pre <= 11'd165;
				x1_pre <= 11'd457;
				y1_pre <= 11'd245;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 57 && lines_done) begin
				x0_pre <= 11'd457;
				y0_pre <= 11'd245;
				x1_pre <= 11'd537;
				y1_pre <= 11'd245;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 58 && lines_done) begin
				x0_pre <= 11'd537;
				y0_pre <= 11'd245;
				x1_pre <= 11'd537;
				y1_pre <= 11'd165;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 59 && lines_done) begin
				x0_pre <= 11'd537;
				y0_pre <= 11'd165;
				x1_pre <= 11'd457;
				y1_pre <= 11'd165;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 60 && lines_done) begin
				x0_pre <= 11'd362;
				y0_pre <= 11'd81;
				x1_pre <= 11'd362;
				y1_pre <= 11'd181;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 61 && lines_done) begin
				x0_pre <= 11'd362;
				y0_pre <= 11'd181;
				x1_pre <= 11'd462;
				y1_pre <= 11'd181;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 62 && lines_done) begin
				x0_pre <= 11'd462;
				y0_pre <= 11'd181;
				x1_pre <= 11'd462;
				y1_pre <= 11'd81;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 63 && lines_done) begin
				x0_pre <= 11'd462;
				y0_pre <= 11'd81;
				x1_pre <= 11'd362;
				y1_pre <= 11'd81;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 64 && lines_done) begin
				x0_pre <= 11'd211;
				y0_pre <= 11'd109;
				x1_pre <= 11'd211;
				y1_pre <= 11'd162;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 65 && lines_done) begin
				x0_pre <= 11'd211;
				y0_pre <= 11'd162;
				x1_pre <= 11'd264;
				y1_pre <= 11'd162;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 66 && lines_done) begin
				x0_pre <= 11'd264;
				y0_pre <= 11'd162;
				x1_pre <= 11'd264;
				y1_pre <= 11'd109;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 67 && lines_done) begin
				x0_pre <= 11'd264;
				y0_pre <= 11'd109;
				x1_pre <= 11'd211;
				y1_pre <= 11'd109;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 68 && lines_done) begin
				x0_pre <= 11'd115;
				y0_pre <= 11'd43;
				x1_pre <= 11'd115;
				y1_pre <= 11'd84;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 69 && lines_done) begin
				x0_pre <= 11'd115;
				y0_pre <= 11'd84;
				x1_pre <= 11'd156;
				y1_pre <= 11'd84;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 70 && lines_done) begin
				x0_pre <= 11'd156;
				y0_pre <= 11'd84;
				x1_pre <= 11'd156;
				y1_pre <= 11'd43;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 71 && lines_done) begin
				x0_pre <= 11'd156;
				y0_pre <= 11'd43;
				x1_pre <= 11'd115;
				y1_pre <= 11'd43;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 72 && lines_done) begin
				x0_pre <= 11'd61;
				y0_pre <= 11'd280;
				x1_pre <= 11'd61;
				y1_pre <= 11'd351;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 73 && lines_done) begin
				x0_pre <= 11'd61;
				y0_pre <= 11'd351;
				x1_pre <= 11'd132;
				y1_pre <= 11'd351;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 74 && lines_done) begin
				x0_pre <= 11'd132;
				y0_pre <= 11'd351;
				x1_pre <= 11'd132;
				y1_pre <= 11'd280;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 75 && lines_done) begin
				x0_pre <= 11'd132;
				y0_pre <= 11'd280;
				x1_pre <= 11'd61;
				y1_pre <= 11'd280;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 76 && lines_done) begin
				x0_pre <= 11'd240;
				y0_pre <= 11'd258;
				x1_pre <= 11'd240;
				y1_pre <= 11'd318;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 77 && lines_done) begin
				x0_pre <= 11'd240;
				y0_pre <= 11'd318;
				x1_pre <= 11'd300;
				y1_pre <= 11'd318;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 78 && lines_done) begin
				x0_pre <= 11'd300;
				y0_pre <= 11'd318;
				x1_pre <= 11'd300;
				y1_pre <= 11'd258;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 79 && lines_done) begin
				x0_pre <= 11'd300;
				y0_pre <= 11'd258;
				x1_pre <= 11'd240;
				y1_pre <= 11'd258;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 80 && lines_done) begin
				x0_pre <= 11'd478;
				y0_pre <= 11'd91;
				x1_pre <= 11'd478;
				y1_pre <= 11'd182;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 81 && lines_done) begin
				x0_pre <= 11'd478;
				y0_pre <= 11'd182;
				x1_pre <= 11'd569;
				y1_pre <= 11'd182;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 82 && lines_done) begin
				x0_pre <= 11'd569;
				y0_pre <= 11'd182;
				x1_pre <= 11'd569;
				y1_pre <= 11'd91;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 83 && lines_done) begin
				x0_pre <= 11'd569;
				y0_pre <= 11'd91;
				x1_pre <= 11'd478;
				y1_pre <= 11'd91;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 84 && lines_done) begin
				x0_pre <= 11'd15;
				y0_pre <= 11'd19;
				x1_pre <= 11'd15;
				y1_pre <= 11'd81;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 85 && lines_done) begin
				x0_pre <= 11'd15;
				y0_pre <= 11'd81;
				x1_pre <= 11'd77;
				y1_pre <= 11'd81;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 86 && lines_done) begin
				x0_pre <= 11'd77;
				y0_pre <= 11'd81;
				x1_pre <= 11'd77;
				y1_pre <= 11'd19;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 87 && lines_done) begin
				x0_pre <= 11'd77;
				y0_pre <= 11'd19;
				x1_pre <= 11'd15;
				y1_pre <= 11'd19;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 88 && lines_done) begin
				x0_pre <= 11'd132;
				y0_pre <= 11'd2;
				x1_pre <= 11'd132;
				y1_pre <= 11'd70;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 89 && lines_done) begin
				x0_pre <= 11'd132;
				y0_pre <= 11'd70;
				x1_pre <= 11'd200;
				y1_pre <= 11'd70;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 90 && lines_done) begin
				x0_pre <= 11'd200;
				y0_pre <= 11'd70;
				x1_pre <= 11'd200;
				y1_pre <= 11'd2;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 91 && lines_done) begin
				x0_pre <= 11'd200;
				y0_pre <= 11'd2;
				x1_pre <= 11'd132;
				y1_pre <= 11'd2;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 92 && lines_done) begin
				x0_pre <= 11'd362;
				y0_pre <= 11'd42;
				x1_pre <= 11'd362;
				y1_pre <= 11'd93;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 93 && lines_done) begin
				x0_pre <= 11'd362;
				y0_pre <= 11'd93;
				x1_pre <= 11'd413;
				y1_pre <= 11'd93;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 94 && lines_done) begin
				x0_pre <= 11'd413;
				y0_pre <= 11'd93;
				x1_pre <= 11'd413;
				y1_pre <= 11'd42;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 95 && lines_done) begin
				x0_pre <= 11'd413;
				y0_pre <= 11'd42;
				x1_pre <= 11'd362;
				y1_pre <= 11'd42;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 96 && lines_done) begin
				x0_pre <= 11'd358;
				y0_pre <= 11'd258;
				x1_pre <= 11'd358;
				y1_pre <= 11'd376;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 97 && lines_done) begin
				x0_pre <= 11'd358;
				y0_pre <= 11'd376;
				x1_pre <= 11'd476;
				y1_pre <= 11'd376;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 98 && lines_done) begin
				x0_pre <= 11'd476;
				y0_pre <= 11'd376;
				x1_pre <= 11'd476;
				y1_pre <= 11'd258;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 99 && lines_done) begin
				x0_pre <= 11'd476;
				y0_pre <= 11'd258;
				x1_pre <= 11'd358;
				y1_pre <= 11'd258;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 100 && lines_done) begin
				x0_pre <= 11'd264;
				y0_pre <= 11'd13;
				x1_pre <= 11'd264;
				y1_pre <= 11'd46;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 101 && lines_done) begin
				x0_pre <= 11'd264;
				y0_pre <= 11'd46;
				x1_pre <= 11'd297;
				y1_pre <= 11'd46;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 102 && lines_done) begin
				x0_pre <= 11'd297;
				y0_pre <= 11'd46;
				x1_pre <= 11'd297;
				y1_pre <= 11'd13;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 103 && lines_done) begin
				x0_pre <= 11'd297;
				y0_pre <= 11'd13;
				x1_pre <= 11'd264;
				y1_pre <= 11'd13;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 104 && lines_done) begin
				x0_pre <= 11'd205;
				y0_pre <= 11'd106;
				x1_pre <= 11'd205;
				y1_pre <= 11'd165;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 105 && lines_done) begin
				x0_pre <= 11'd205;
				y0_pre <= 11'd165;
				x1_pre <= 11'd264;
				y1_pre <= 11'd165;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 106 && lines_done) begin
				x0_pre <= 11'd264;
				y0_pre <= 11'd165;
				x1_pre <= 11'd264;
				y1_pre <= 11'd106;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 107 && lines_done) begin
				x0_pre <= 11'd264;
				y0_pre <= 11'd106;
				x1_pre <= 11'd205;
				y1_pre <= 11'd106;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 108 && lines_done) begin
				x0_pre <= 11'd89;
				y0_pre <= 11'd265;
				x1_pre <= 11'd89;
				y1_pre <= 11'd295;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 109 && lines_done) begin
				x0_pre <= 11'd89;
				y0_pre <= 11'd295;
				x1_pre <= 11'd119;
				y1_pre <= 11'd295;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 110 && lines_done) begin
				x0_pre <= 11'd119;
				y0_pre <= 11'd295;
				x1_pre <= 11'd119;
				y1_pre <= 11'd265;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 111 && lines_done) begin
				x0_pre <= 11'd119;
				y0_pre <= 11'd265;
				x1_pre <= 11'd89;
				y1_pre <= 11'd265;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 112 && lines_done) begin
				x0_pre <= 11'd151;
				y0_pre <= 11'd126;
				x1_pre <= 11'd151;
				y1_pre <= 11'd223;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 113 && lines_done) begin
				x0_pre <= 11'd151;
				y0_pre <= 11'd223;
				x1_pre <= 11'd248;
				y1_pre <= 11'd223;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 114 && lines_done) begin
				x0_pre <= 11'd248;
				y0_pre <= 11'd223;
				x1_pre <= 11'd248;
				y1_pre <= 11'd126;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 115 && lines_done) begin
				x0_pre <= 11'd248;
				y0_pre <= 11'd126;
				x1_pre <= 11'd151;
				y1_pre <= 11'd126;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 116 && lines_done) begin
				x0_pre <= 11'd188;
				y0_pre <= 11'd214;
				x1_pre <= 11'd188;
				y1_pre <= 11'd260;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 117 && lines_done) begin
				x0_pre <= 11'd188;
				y0_pre <= 11'd260;
				x1_pre <= 11'd234;
				y1_pre <= 11'd260;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 118 && lines_done) begin
				x0_pre <= 11'd234;
				y0_pre <= 11'd260;
				x1_pre <= 11'd234;
				y1_pre <= 11'd214;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 119 && lines_done) begin
				x0_pre <= 11'd234;
				y0_pre <= 11'd214;
				x1_pre <= 11'd188;
				y1_pre <= 11'd214;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 120 && lines_done) begin
				x0_pre <= 11'd435;
				y0_pre <= 11'd138;
				x1_pre <= 11'd435;
				y1_pre <= 11'd239;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 121 && lines_done) begin
				x0_pre <= 11'd435;
				y0_pre <= 11'd239;
				x1_pre <= 11'd536;
				y1_pre <= 11'd239;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 122 && lines_done) begin
				x0_pre <= 11'd536;
				y0_pre <= 11'd239;
				x1_pre <= 11'd536;
				y1_pre <= 11'd138;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 123 && lines_done) begin
				x0_pre <= 11'd536;
				y0_pre <= 11'd138;
				x1_pre <= 11'd435;
				y1_pre <= 11'd138;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 124 && lines_done) begin
				x0_pre <= 11'd76;
				y0_pre <= 11'd84;
				x1_pre <= 11'd76;
				y1_pre <= 11'd200;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 125 && lines_done) begin
				x0_pre <= 11'd76;
				y0_pre <= 11'd200;
				x1_pre <= 11'd192;
				y1_pre <= 11'd200;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 126 && lines_done) begin
				x0_pre <= 11'd192;
				y0_pre <= 11'd200;
				x1_pre <= 11'd192;
				y1_pre <= 11'd84;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 127 && lines_done) begin
				x0_pre <= 11'd192;
				y0_pre <= 11'd84;
				x1_pre <= 11'd76;
				y1_pre <= 11'd84;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 128 && lines_done) begin
				x0_pre <= 11'd494;
				y0_pre <= 11'd114;
				x1_pre <= 11'd494;
				y1_pre <= 11'd168;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 129 && lines_done) begin
				x0_pre <= 11'd494;
				y0_pre <= 11'd168;
				x1_pre <= 11'd548;
				y1_pre <= 11'd168;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 130 && lines_done) begin
				x0_pre <= 11'd548;
				y0_pre <= 11'd168;
				x1_pre <= 11'd548;
				y1_pre <= 11'd114;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 131 && lines_done) begin
				x0_pre <= 11'd548;
				y0_pre <= 11'd114;
				x1_pre <= 11'd494;
				y1_pre <= 11'd114;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 132 && lines_done) begin
				x0_pre <= 11'd184;
				y0_pre <= 11'd129;
				x1_pre <= 11'd184;
				y1_pre <= 11'd178;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 133 && lines_done) begin
				x0_pre <= 11'd184;
				y0_pre <= 11'd178;
				x1_pre <= 11'd233;
				y1_pre <= 11'd178;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 134 && lines_done) begin
				x0_pre <= 11'd233;
				y0_pre <= 11'd178;
				x1_pre <= 11'd233;
				y1_pre <= 11'd129;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 135 && lines_done) begin
				x0_pre <= 11'd233;
				y0_pre <= 11'd129;
				x1_pre <= 11'd184;
				y1_pre <= 11'd129;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 136 && lines_done) begin
				x0_pre <= 11'd477;
				y0_pre <= 11'd201;
				x1_pre <= 11'd477;
				y1_pre <= 11'd316;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 137 && lines_done) begin
				x0_pre <= 11'd477;
				y0_pre <= 11'd316;
				x1_pre <= 11'd592;
				y1_pre <= 11'd316;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 138 && lines_done) begin
				x0_pre <= 11'd592;
				y0_pre <= 11'd316;
				x1_pre <= 11'd592;
				y1_pre <= 11'd201;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 139 && lines_done) begin
				x0_pre <= 11'd592;
				y0_pre <= 11'd201;
				x1_pre <= 11'd477;
				y1_pre <= 11'd201;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 140 && lines_done) begin
				x0_pre <= 11'd438;
				y0_pre <= 11'd58;
				x1_pre <= 11'd438;
				y1_pre <= 11'd90;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 141 && lines_done) begin
				x0_pre <= 11'd438;
				y0_pre <= 11'd90;
				x1_pre <= 11'd470;
				y1_pre <= 11'd90;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 142 && lines_done) begin
				x0_pre <= 11'd470;
				y0_pre <= 11'd90;
				x1_pre <= 11'd470;
				y1_pre <= 11'd58;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 143 && lines_done) begin
				x0_pre <= 11'd470;
				y0_pre <= 11'd58;
				x1_pre <= 11'd438;
				y1_pre <= 11'd58;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 144 && lines_done) begin
				x0_pre <= 11'd322;
				y0_pre <= 11'd222;
				x1_pre <= 11'd322;
				y1_pre <= 11'd308;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 145 && lines_done) begin
				x0_pre <= 11'd322;
				y0_pre <= 11'd308;
				x1_pre <= 11'd408;
				y1_pre <= 11'd308;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 146 && lines_done) begin
				x0_pre <= 11'd408;
				y0_pre <= 11'd308;
				x1_pre <= 11'd408;
				y1_pre <= 11'd222;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 147 && lines_done) begin
				x0_pre <= 11'd408;
				y0_pre <= 11'd222;
				x1_pre <= 11'd322;
				y1_pre <= 11'd222;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 148 && lines_done) begin
				x0_pre <= 11'd92;
				y0_pre <= 11'd210;
				x1_pre <= 11'd92;
				y1_pre <= 11'd310;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 149 && lines_done) begin
				x0_pre <= 11'd92;
				y0_pre <= 11'd310;
				x1_pre <= 11'd192;
				y1_pre <= 11'd310;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 150 && lines_done) begin
				x0_pre <= 11'd192;
				y0_pre <= 11'd310;
				x1_pre <= 11'd192;
				y1_pre <= 11'd210;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 151 && lines_done) begin
				x0_pre <= 11'd192;
				y0_pre <= 11'd210;
				x1_pre <= 11'd92;
				y1_pre <= 11'd210;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 152 && lines_done) begin
				x0_pre <= 11'd23;
				y0_pre <= 11'd112;
				x1_pre <= 11'd23;
				y1_pre <= 11'd206;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 153 && lines_done) begin
				x0_pre <= 11'd23;
				y0_pre <= 11'd206;
				x1_pre <= 11'd117;
				y1_pre <= 11'd206;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 154 && lines_done) begin
				x0_pre <= 11'd117;
				y0_pre <= 11'd206;
				x1_pre <= 11'd117;
				y1_pre <= 11'd112;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 155 && lines_done) begin
				x0_pre <= 11'd117;
				y0_pre <= 11'd112;
				x1_pre <= 11'd23;
				y1_pre <= 11'd112;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 156 && lines_done) begin
				x0_pre <= 11'd41;
				y0_pre <= 11'd88;
				x1_pre <= 11'd41;
				y1_pre <= 11'd139;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 157 && lines_done) begin
				x0_pre <= 11'd41;
				y0_pre <= 11'd139;
				x1_pre <= 11'd92;
				y1_pre <= 11'd139;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 158 && lines_done) begin
				x0_pre <= 11'd92;
				y0_pre <= 11'd139;
				x1_pre <= 11'd92;
				y1_pre <= 11'd88;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 159 && lines_done) begin
				x0_pre <= 11'd92;
				y0_pre <= 11'd88;
				x1_pre <= 11'd41;
				y1_pre <= 11'd88;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 160 && lines_done) begin
				x0_pre <= 11'd391;
				y0_pre <= 11'd287;
				x1_pre <= 11'd391;
				y1_pre <= 11'd364;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 161 && lines_done) begin
				x0_pre <= 11'd391;
				y0_pre <= 11'd364;
				x1_pre <= 11'd468;
				y1_pre <= 11'd364;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 162 && lines_done) begin
				x0_pre <= 11'd468;
				y0_pre <= 11'd364;
				x1_pre <= 11'd468;
				y1_pre <= 11'd287;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 163 && lines_done) begin
				x0_pre <= 11'd468;
				y0_pre <= 11'd287;
				x1_pre <= 11'd391;
				y1_pre <= 11'd287;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 164 && lines_done) begin
				x0_pre <= 11'd141;
				y0_pre <= 11'd129;
				x1_pre <= 11'd141;
				y1_pre <= 11'd234;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 165 && lines_done) begin
				x0_pre <= 11'd141;
				y0_pre <= 11'd234;
				x1_pre <= 11'd246;
				y1_pre <= 11'd234;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 166 && lines_done) begin
				x0_pre <= 11'd246;
				y0_pre <= 11'd234;
				x1_pre <= 11'd246;
				y1_pre <= 11'd129;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 167 && lines_done) begin
				x0_pre <= 11'd246;
				y0_pre <= 11'd129;
				x1_pre <= 11'd141;
				y1_pre <= 11'd129;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 168 && lines_done) begin
				x0_pre <= 11'd22;
				y0_pre <= 11'd9;
				x1_pre <= 11'd22;
				y1_pre <= 11'd64;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 169 && lines_done) begin
				x0_pre <= 11'd22;
				y0_pre <= 11'd64;
				x1_pre <= 11'd77;
				y1_pre <= 11'd64;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 170 && lines_done) begin
				x0_pre <= 11'd77;
				y0_pre <= 11'd64;
				x1_pre <= 11'd77;
				y1_pre <= 11'd9;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 171 && lines_done) begin
				x0_pre <= 11'd77;
				y0_pre <= 11'd9;
				x1_pre <= 11'd22;
				y1_pre <= 11'd9;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 172 && lines_done) begin
				x0_pre <= 11'd369;
				y0_pre <= 11'd264;
				x1_pre <= 11'd369;
				y1_pre <= 11'd340;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 173 && lines_done) begin
				x0_pre <= 11'd369;
				y0_pre <= 11'd340;
				x1_pre <= 11'd445;
				y1_pre <= 11'd340;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 174 && lines_done) begin
				x0_pre <= 11'd445;
				y0_pre <= 11'd340;
				x1_pre <= 11'd445;
				y1_pre <= 11'd264;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 175 && lines_done) begin
				x0_pre <= 11'd445;
				y0_pre <= 11'd264;
				x1_pre <= 11'd369;
				y1_pre <= 11'd264;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 176 && lines_done) begin
				x0_pre <= 11'd357;
				y0_pre <= 11'd152;
				x1_pre <= 11'd357;
				y1_pre <= 11'd198;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 177 && lines_done) begin
				x0_pre <= 11'd357;
				y0_pre <= 11'd198;
				x1_pre <= 11'd403;
				y1_pre <= 11'd198;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 178 && lines_done) begin
				x0_pre <= 11'd403;
				y0_pre <= 11'd198;
				x1_pre <= 11'd403;
				y1_pre <= 11'd152;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 179 && lines_done) begin
				x0_pre <= 11'd403;
				y0_pre <= 11'd152;
				x1_pre <= 11'd357;
				y1_pre <= 11'd152;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 180 && lines_done) begin
				x0_pre <= 11'd23;
				y0_pre <= 11'd275;
				x1_pre <= 11'd23;
				y1_pre <= 11'd317;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 181 && lines_done) begin
				x0_pre <= 11'd23;
				y0_pre <= 11'd317;
				x1_pre <= 11'd65;
				y1_pre <= 11'd317;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 182 && lines_done) begin
				x0_pre <= 11'd65;
				y0_pre <= 11'd317;
				x1_pre <= 11'd65;
				y1_pre <= 11'd275;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 183 && lines_done) begin
				x0_pre <= 11'd65;
				y0_pre <= 11'd275;
				x1_pre <= 11'd23;
				y1_pre <= 11'd275;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 184 && lines_done) begin
				x0_pre <= 11'd373;
				y0_pre <= 11'd43;
				x1_pre <= 11'd373;
				y1_pre <= 11'd83;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 185 && lines_done) begin
				x0_pre <= 11'd373;
				y0_pre <= 11'd83;
				x1_pre <= 11'd413;
				y1_pre <= 11'd83;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 186 && lines_done) begin
				x0_pre <= 11'd413;
				y0_pre <= 11'd83;
				x1_pre <= 11'd413;
				y1_pre <= 11'd43;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 187 && lines_done) begin
				x0_pre <= 11'd413;
				y0_pre <= 11'd43;
				x1_pre <= 11'd373;
				y1_pre <= 11'd43;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 188 && lines_done) begin
				x0_pre <= 11'd32;
				y0_pre <= 11'd164;
				x1_pre <= 11'd32;
				y1_pre <= 11'd248;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 189 && lines_done) begin
				x0_pre <= 11'd32;
				y0_pre <= 11'd248;
				x1_pre <= 11'd116;
				y1_pre <= 11'd248;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 190 && lines_done) begin
				x0_pre <= 11'd116;
				y0_pre <= 11'd248;
				x1_pre <= 11'd116;
				y1_pre <= 11'd164;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 191 && lines_done) begin
				x0_pre <= 11'd116;
				y0_pre <= 11'd164;
				x1_pre <= 11'd32;
				y1_pre <= 11'd164;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 192 && lines_done) begin
				x0_pre <= 11'd134;
				y0_pre <= 11'd133;
				x1_pre <= 11'd134;
				y1_pre <= 11'd204;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 193 && lines_done) begin
				x0_pre <= 11'd134;
				y0_pre <= 11'd204;
				x1_pre <= 11'd205;
				y1_pre <= 11'd204;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 194 && lines_done) begin
				x0_pre <= 11'd205;
				y0_pre <= 11'd204;
				x1_pre <= 11'd205;
				y1_pre <= 11'd133;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 195 && lines_done) begin
				x0_pre <= 11'd205;
				y0_pre <= 11'd133;
				x1_pre <= 11'd134;
				y1_pre <= 11'd133;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 196 && lines_done) begin
				x0_pre <= 11'd142;
				y0_pre <= 11'd198;
				x1_pre <= 11'd142;
				y1_pre <= 11'd314;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 197 && lines_done) begin
				x0_pre <= 11'd142;
				y0_pre <= 11'd314;
				x1_pre <= 11'd258;
				y1_pre <= 11'd314;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 198 && lines_done) begin
				x0_pre <= 11'd258;
				y0_pre <= 11'd314;
				x1_pre <= 11'd258;
				y1_pre <= 11'd198;
				lines_start <= 1;
				lines_counter <= lines_counter + 1;
			end
			if (~lines_start && lines_counter == 199 && lines_done) begin
				x0_pre <= 11'd258;
				y0_pre <= 11'd198;
				x1_pre <= 11'd142;
				y1_pre <= 11'd198;
				// frame is complete
				lines_counter <= 0;
				frame_complete <= 1;
				x_offset <= x_offset + 20;
				y_offset <= y_offset + 10;
			end
		end
	end
endmodule