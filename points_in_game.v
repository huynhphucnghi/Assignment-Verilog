module points_in_game(
	output reg [6:0]p1_point_0, p1_point_1, p2_point_0, p2_point_1,
	output reg p1_win, p2_win,
	input p1, p2, rst, clk
	);
	
	parameter [6:0]
		BLANK = 7'b1111111,
		ZERO	= 7'b1000000,
		ONE	= 7'b1111001,
		TWO	= 7'b0100100,
		THREE	= 7'b0110000,
		FOUR	= 7'b0011001,
		FIVE	= 7'b0010010,
		SIX	= 7'b0000011,
		SEVEN	= 7'b1111000,
		EIGHT = 7'b0000000,
		NINE	= 7'b0010000;
		
	parameter [13:0]
		_00 = {ZERO,ZERO},
		_15 = {ONE,FIVE},
		_30 = {THREE,ZERO},
		_40 = {FOUR,ZERO};
		
	// Set flags
	wire flag_250ns, flag_42us, flag_100us, flag_1640us, flag_4100us, flag_15000us, flag_2s;
	reg flag_rst = 1;
	flag_controller flag(clk, flag_rst, flag_250ns, flag_42us, flag_100us, flag_1640us, flag_4100us, flag_15000us, flag_250ms, flag_2s);
		
		
	reg [3:0] p1_count, p2_count;
	reg [1:0] state;
	
	initial begin
		p1_count = 0;
		p2_count = 0;
		p1_win = 0;
		p2_win = 0;
	end
	
	always @(posedge clk) begin
		if(!rst) begin
			p1_count <= 0;
			p2_count <= 0;
			p1_win <= 0;
			p2_win <= 0;
			state <= 0;
		end
		else begin
			case (state)
				0:	begin
						p1_win <= 0;
						p2_win <= 0;
						if(!flag_250ms) begin						
							state 		<=	state;				
							flag_rst		<=	1'b0; 									
						end
						else begin
							case ({p1,p2})
								2'b01: begin
									state <= 1;
									flag_rst <= 1'b1;
									end
								2'b10: begin
									state <= 2;
									flag_rst <= 1'b1;
									end
								default: begin
									state <= state;
									flag_rst <= flag_rst;
								end
							endcase
						end
					end
				1: begin
					if (p1_count == 3) begin
						p1_count <= 0;
						p2_count <= 0;
						p1_win <= 1;
						p2_win <= 0;
						end
					else p1_count <= p1_count + 1;
					state <= 0;
					end
				2: begin
					if (p2_count == 3) begin
						p1_count <= 0;
						p2_count <= 0;
						p1_win <= 0;
						p2_win <= 1;
						end
					else p2_count <= p2_count + 1;
					state <= 0;
					end
				default: state <= state;
			endcase
		end
	end
	
////////////////////////////////////////////////////////////////////////////////////////////////////	
	always@(p1_count) begin
		case (p1_count)
			0 : {p1_point_1, p1_point_0} = _00;
			1 : {p1_point_1, p1_point_0} = _15;
			2 : {p1_point_1, p1_point_0} = _30;
			3 : {p1_point_1, p1_point_0} = _40;
			default: {p1_point_1, p1_point_0} = {p1_point_1, p1_point_0};
		endcase
	end
	
	always@(p2_count) begin
		case (p2_count)
			0 : {p2_point_1, p2_point_0} = _00;
			1 : {p2_point_1, p2_point_0} = _15;
			2 : {p2_point_1, p2_point_0} = _30;
			3 : {p2_point_1, p2_point_0} = _40;
			default: {p2_point_1, p2_point_0} = {p2_point_1, p2_point_0};
		endcase
	end
	
endmodule	
