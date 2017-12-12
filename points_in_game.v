module points_in_game(
	output reg [6:0]p1_point_0, p1_point_1, p2_point_0, p2_point_1,
	output reg deuce_p1, deuce_p2,
	output reg p1_win, p2_win,
	input en,
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
		SIX	= 7'b0000001,
		SEVEN	= 7'b1111000,
		EIGHT = 7'b0000000,
		NINE	= 7'b0010000;
		
	parameter [13:0]
		_00 = {ZERO,ZERO},
		_15 = {ONE ,FIVE},
		_30 = {THREE,ZERO},
		_40 = {FOUR,ZERO},
		_01 = {ZERO,ONE	},
		_02 = {ZERO,TWO	},
		_03 = {ZERO,THREE},
		_04 = {ZERO,FOUR},
		_05 = {ZERO,FIVE},
		_06 = {ZERO,SIX	},
		_07 = {ZERO,SEVEN},
		_08 = {ZERO,EIGHT},
		_09 = {ZERO,NINE},
		_10 = {ONE ,ZERO},
		_11 = {ONE ,ONE	},
		_12 = {ONE ,TWO	},
		_13 = {ONE ,THREE},
		_14 = {ONE ,FOUR},
		_16 = {ONE ,SIX	},
		_17 = {ONE ,SEVEN},
		_18 = {ONE ,EIGHT },
		_19 = {ONE ,NINE};
		
	// Set flags
	wire flag_250ns, flag_42us, flag_100us, flag_1640us, flag_4100us, flag_15000us, flag_2s, flag_250ms;
	reg flag_rst = 1;
	flag_controller flag(clk, flag_rst, flag_250ns, flag_42us, flag_100us, flag_1640us, flag_4100us, flag_15000us, flag_2s, flag_250ms);
		
		
	reg [3:0] p1_count, p2_count;
	reg [1:0] state;
	
	initial begin
		p1_count = 0;
		p2_count = 0;
		p1_win = 0;
		p2_win = 0;
		deuce_p1 = 0;
		deuce_p2 = 0;
	end
	
	always @(posedge clk) begin
		if(!rst) begin
			p1_count <= 0;
			p2_count  <= 0;
			p1_win <= 0;
			p2_win <= 0;
			state <= 0;
		end
		else if (!en) begin
		
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
						if(p2_count == 3) begin
							if (deuce_p1) begin
								p1_count <= 0;
								p2_count <= 0;
								p1_win <= 1;
								p2_win <= 0;
								deuce_p1 <= 0;
							end
							else if (deuce_p2) deuce_p2 <= 0;
							else deuce_p1 <= 1;
						end
						else begin
							p1_count <= 0;
							p2_count <= 0;
							p1_win <= 1;
							p2_win <= 0;
						end
					end
					else p1_count <= p1_count + 1;
					state <= 0;						
					end
				2: begin
					if (p2_count == 3) begin
						if (p1_count == 3) begin
							if (deuce_p2) begin
								p1_count <= 0;
								p2_count <= 0;
								p1_win <= 0;
								p2_win <= 1;
								deuce_p2 <= 0;
							end
							else if (deuce_p1) deuce_p1 <=0;
							else deuce_p2 <= 1;
						end
						else begin
							p1_count <= 0;
							p2_count <= 0;
							p1_win <= 0;
							p2_win <= 1;
						end
					end
					else p2_count <= p2_count + 1;
					state <= 0;
					end
				default: state <= state;
			endcase
		end
		else begin
			case (state)
				0: begin
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
					if ((p1_count >= 6) && (p1_count > p2_count) && (p1_count - p2_count == 1)) begin
							p1_count <= 0;
							p2_count <= 0;
							p1_win <= 1;
							p2_win <= 0;
					end
					else p1_count <= p1_count + 1;
					state <= 0;						
					end
				2: begin
					if ((p2_count >= 6) && (p2_count > p1_count) && (p2_count - p1_count == 1)) begin
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
			1 : {p1_point_1, p1_point_0} = en? _01 : _15;
			2 : {p1_point_1, p1_point_0} = en? _02 : _30;
			3 : {p1_point_1, p1_point_0} = en? _03 : _40;
			4 : {p1_point_1, p1_point_0} = _04;
			5 : {p1_point_1, p1_point_0} = _05;
			6 : {p1_point_1, p1_point_0} = _06;
			7 : {p1_point_1, p1_point_0} = _07;
			8 : {p1_point_1, p1_point_0} = _08;
			9 : {p1_point_1, p1_point_0} = _09;
			10 : {p1_point_1, p1_point_0} = _10;
			11 : {p1_point_1, p1_point_0} = _11;
			12 : {p1_point_1, p1_point_0} = _12;
			13 : {p1_point_1, p1_point_0} = _13;
			14 : {p1_point_1, p1_point_0} = _14;
			15 : {p1_point_1, p1_point_0} = _15;
			16 : {p1_point_1, p1_point_0} = _16;
			17 : {p1_point_1, p1_point_0} = _17;
			18 : {p1_point_1, p1_point_0} = _18;
			19 : {p1_point_1, p1_point_0} = _19;
			default: {p1_point_1, p1_point_0} = {p1_point_1, p1_point_0};
		endcase
	end
	
	always@(p2_count) begin
		case (p2_count)
			0 : {p2_point_1, p2_point_0} = _00;
			1 : {p2_point_1, p2_point_0} = en? _01 : _15;
			2 : {p2_point_1, p2_point_0} = en? _02 : _30;
			3 : {p2_point_1, p2_point_0} = en? _03 : _40;
			4 : {p2_point_1, p2_point_0} = _04;
			5 : {p2_point_1, p2_point_0} = _05;
			6 : {p2_point_1, p2_point_0} = _06;
			7 : {p2_point_1, p2_point_0} = _07;
			8 : {p2_point_1, p2_point_0} = _08;
			9 : {p2_point_1, p2_point_0} = _09;
			10 : {p2_point_1, p2_point_0} = _10;
			11 : {p2_point_1, p2_point_0} = _11;
			12 : {p2_point_1, p2_point_0} = _12;
			13 : {p2_point_1, p2_point_0} = _13;
			14 : {p2_point_1, p2_point_0} = _14;
			15 : {p2_point_1, p2_point_0} = _15;
			16 : {p2_point_1, p2_point_0} = _16;
			17 : {p2_point_1, p2_point_0} = _17;
			18 : {p2_point_1, p2_point_0} = _18;
			19 : {p2_point_1, p2_point_0} = _19;
			default: {p2_point_1, p2_point_0} = {p2_point_1, p2_point_0};
		endcase
	end
	
endmodule	
