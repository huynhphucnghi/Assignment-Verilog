module LCD_command(
	input [3:0] op, input [31:0] data, input rdy, output reg [11:0] DATA, output reg rdy_command, output reg [3:0] state = 4'b0
);
	parameter [7:0]
		khoang_trang = 8'b00100000,		
		cham_thang = 8'b00100001,		
		ngoac_kep = 8'b00100010,		
		hashtag = 8'b00100011,		
		dola = 8'b00100100,		
		phan_tram = 8'b00100101,		
		va = 8'b00100110,		
		ngoac_don = 8'b00100111,		
		ngoac_tron_1 = 8'b00101000,		
		ngoac_tron_2 = 8'b00101001,		
		sao = 8'b00101010,		
		cong = 8'b00101011,		
		phay = 8'b00101100,		
		tru = 8'b00101101,		
		cham = 8'b00101110,		
		chia = 8'b00101111,		
		_0 = 8'b00110000,		
		_1 = 8'b00110001,		
		_2 = 8'b00110010,		
		_3 = 8'b00110011,		
		_4 = 8'b00110100,		
		_5 = 8'b00110101,		
		_6 = 8'b00110110,		
		_7 = 8'b00110111,		
		_8 = 8'b00111000,		
		_9 = 8'b00111001,		
		hai_cham = 8'b00111010,		
		cham_phay = 8'b00111011,		
		be_hon = 8'b00111100,		
		bang = 8'b00111101,		
		lon_hon = 8'b00111110,		
		cham_hoi = 8'b00111111,		
		a_cong = 8'b01000000,		
		_A = 8'b01000001,		
		_B = 8'b01000010,		
		_C = 8'b01000011,		
		_D = 8'b01000100,		
		_E = 8'b01000101,		
		_F = 8'b01000110,		
		_G = 8'b01000111,		
		_H = 8'b01001000,		
		_I = 8'b01001001,		
		_J = 8'b01001010,		
		_K = 8'b01001011,		
		_L = 8'b01001100,		
		_M = 8'b01001101,		
		_N = 8'b01001110,		
		_O = 8'b01001111,		
		_P = 8'b01010000,		
		_Q = 8'b01010001,		
		_R = 8'b01010010,		
		_S = 8'b01010011,		
		_T = 8'b01010100,		
		_U = 8'b01010101,		
		_V = 8'b01010110,		
		_W = 8'b01010111,		
		_X = 8'b01011000,		
		_Y = 8'b01011001,		
		_Z = 8'b01011010,		
		ngoac_vuong_1 = 8'b01011011,		
		slash = 8'b01011100,		
		ngoac_vuong_2 = 8'b01011101,		
		mu = 8'b01011110,		
		gach_chan = 8'b01011111,		
		huyen = 8'b01100000,		
		a = 8'b01100001,
		b = 8'b01100010,
		c = 8'b01100011,
		d = 8'b01100100,
		e = 8'b01100101,
		f = 8'b01100110,
		g = 8'b01100111,
		h = 8'b01101000,
		i = 8'b01101001,
		j = 8'b01101010,
		k = 8'b01101011,
		l = 8'b01101100,
		m = 8'b01101101,
		n = 8'b01101110,
		o = 8'b01101111,
		p = 8'b01110000,
		q = 8'b01110001,
		r = 8'b01110010,
		s = 8'b01110011,
		t = 8'b01110100,
		u = 8'b01110101,
		v = 8'b01110110,
		w = 8'b01110111,
		x = 8'b01111000,
		y = 8'b01111001,
		z = 8'b01111010;
	
	parameter [3:0] 
		clear = 4'b0000,
		write = 4'b0001,
		setad = 4'b0011,
		wait1 = 4'b1111,
		wait2 = 4'b0100;
		

	reg [5:0] ss = 6'b0;			// substate
	wire [7:0] encodedData[3:0];
	
	assign encodedData[0] = data[7:0] + 8'h30;
	assign encodedData[1] = data[15:8] + 8'h30;
	assign encodedData[2] = data[23:16] + 8'h30;
	assign encodedData[3] = data[31:24];

	always@(posedge rdy) begin
		case(state)
		// Reset the Game
		0: begin
			rdy_command <= 1'b0;
			case(ss)
			0:		begin ss <= ss + 6'b1; DATA 	<= {clear, 8'd00};			end	
			1:		begin ss <= ss + 6'b1; DATA 	<= {setad, 8'd04};			end	
			2: 	begin ss <= ss + 6'b1; DATA 	<= {write, _W};				end
			3: 	begin ss <= ss + 6'b1; DATA 	<= {write, e};					end		
			4: 	begin ss <= ss + 6'b1; DATA 	<= {write, l};					end
			5: 	begin ss <= ss + 6'b1; DATA 	<= {write, c};					end
			6: 	begin ss <= ss + 6'b1; DATA 	<= {write, o};					end
			7: 	begin ss <= ss + 6'b1; DATA 	<= {write, m};					end
			8: 	begin ss <= ss + 6'b1; DATA 	<= {write, e};					end
			9: 	begin ss <= ss + 6'b1; DATA 	<= {write, cham_thang};		end
			10: 	begin ss <= ss + 6'b1; DATA 	<= {setad, 8'd43};			end
			11: 	begin ss <= ss + 6'b1; DATA 	<= {write, _L};				end
			12: 	begin ss <= ss + 6'b1; DATA 	<= {write, e};					end
			13: 	begin ss <= ss + 6'b1; DATA 	<= {write, t};					end
			14: 	begin ss <= ss + 6'b1; DATA 	<= {write, ngoac_don};		end
			15: 	begin ss <= ss + 6'b1; DATA 	<= {write, s};					end
			16: 	begin ss <= ss + 6'b1; DATA 	<= {write, khoang_trang};	end
			17: 	begin ss <= ss + 6'b1; DATA 	<= {write, p};					end
			18: 	begin ss <= ss + 6'b1; DATA 	<= {write, l};					end
			19: 	begin ss <= ss + 6'b1; DATA 	<= {write, a};					end
			20: 	begin ss <= ss + 6'b1; DATA 	<= {write, y};					end
			21: 	begin ss <= ss + 6'b1; DATA 	<= {wait2, 8'd00};			end
			22: 	begin ss <= ss + 6'b1; DATA 	<= {clear, 8'd00};			end
			23: 	begin ss <= ss + 6'b1; DATA 	<= {write, _0};				end
			24: 	begin ss <= ss + 6'b1; DATA 	<= {setad, 8'd6};				end
			25: 	begin ss <= ss + 6'b1; DATA 	<= {write, _P};				end
			26: 	begin ss <= ss + 6'b1; DATA 	<= {write, _1};				end
			27: 	begin ss <= ss + 6'b1; DATA 	<= {setad, 8'd12};			end
			28: 	begin ss <= ss + 6'b1; DATA 	<= {write, _0};				end
			29: 	begin ss <= ss + 6'b1; DATA 	<= {setad, 8'd14};			end
			30: 	begin ss <= ss + 6'b1; DATA 	<= {write, _0};				end
			31: 	begin ss <= ss + 6'b1; DATA 	<= {setad, 8'd40};			end
			32: 	begin ss <= ss + 6'b1; DATA 	<= {write, _0};				end
			33: 	begin ss <= ss + 6'b1; DATA 	<= {setad, 8'd46};			end
			34: 	begin ss <= ss + 6'b1; DATA 	<= {write, _P};				end
			35: 	begin ss <= ss + 6'b1; DATA 	<= {write, _2};				end
			36: 	begin ss <= ss + 6'b1; DATA 	<= {setad, 8'd52};			end
			37: 	begin ss <= ss + 6'b1; DATA 	<= {write, _0};				end
			38: 	begin ss <= ss + 6'b1; DATA 	<= {setad, 8'd54};			end
			39: 	begin ss <= ss + 6'b1; DATA 	<= {write, _0};				end
			default: 	begin ss <= 6'b0; state <= 4'd15; DATA 	<= {wait1, 8'd00};	end
			endcase
		end
		
		// 1 game for player1
		1: begin
			rdy_command <= 1'b0;
			case(ss)
			0:		begin ss <= ss + 6'b1; DATA 	<= {setad, 8'd14};			end	
			1: 	begin ss <= ss + 6'b1; DATA 	<= {write, encodedData[0]};end
			2:		begin ss <= ss + 6'b1; DATA 	<= {wait2, 8'd00};			end
			default:		begin ss <= 6'b0; state <= 4'd15; DATA 	<= {wait1, 8'd00};	end
			endcase
		end
		// 1 game for player2
		2: begin
			rdy_command <= 1'b0;
			case(ss)
			0:		begin ss <= ss + 6'b1; DATA 	<= {setad, 8'd54};			end	
			1: 	begin ss <= ss + 6'b1; DATA 	<= {write, encodedData[0]};end
			2:		begin ss <= ss + 6'b1; DATA 	<= {wait2, 8'd00};			end
			default:		begin ss <= 6'b0; state <= 4'd15; DATA 	<= {wait1, 8'd00};	end
			endcase
		end
		
		// 1 set for player1
		3: begin
			rdy_command <= 1'b0;
			case(ss)
			0:		begin ss <= ss + 6'b1; DATA 	<= {setad, 8'd14};			end	
			1: 	begin ss <= ss + 6'b1; DATA 	<= {write, _0};				end
			2:		begin ss <= ss + 6'b1; DATA 	<= {setad, 8'd54};			end
			3: 	begin ss <= ss + 6'b1; DATA 	<= {write, _0};				end
			4:		begin ss <= ss + 6'b1; DATA 	<= {setad, encodedData[3]};end
			5: 	begin ss <= ss + 6'b1; DATA 	<= {write, encodedData[0]};end
			6:		begin ss <= ss + 6'b1; DATA 	<= {setad, encodedData[3] + 8'd40};	end
			7: 	begin ss <= ss + 6'b1; DATA 	<= {write, encodedData[1]};end
			8:		begin ss <= ss + 6'b1; DATA 	<= {setad, 8'd12};			end
			9: 	begin ss <= ss + 6'b1; DATA 	<= {write, encodedData[2]};end
			10:		begin ss <= ss + 6'b1; DATA 	<= {wait2, 8'd00};		end
			default:		begin ss <= 6'b0; state <= 4'd15; DATA 	<= {wait1, 8'd00};	end
			endcase
		end
		// 1 set for player2
		4: begin
			rdy_command <= 1'b0;
			case(ss)
			0:		begin ss <= ss + 6'b1; DATA 	<= {setad, 8'd14};			end	
			1: 	begin ss <= ss + 6'b1; DATA 	<= {write, _0};				end
			2:		begin ss <= ss + 6'b1; DATA 	<= {setad, 8'd54};			end
			3: 	begin ss <= ss + 6'b1; DATA 	<= {write, _0};				end
			4:		begin ss <= ss + 6'b1; DATA 	<= {setad, encodedData[3]};end
			5: 	begin ss <= ss + 6'b1; DATA 	<= {write, encodedData[0]};end
			6:		begin ss <= ss + 6'b1; DATA 	<= {setad, encodedData[3] + 8'd40};	end
			7: 	begin ss <= ss + 6'b1; DATA 	<= {write, encodedData[1]};end
			8:		begin ss <= ss + 6'b1; DATA 	<= {setad, 8'd52};			end
			9: 	begin ss <= ss + 6'b1; DATA 	<= {write, encodedData[2]};end
			10:		begin ss <= ss + 6'b1; DATA 	<= {wait2, 8'd00};		end
			default:		begin ss <= 6'b0; state <= 4'd15; DATA 	<= {wait1, 8'd00};	end
			endcase
		end
		
		// End game, player1 win
		5: begin
			rdy_command <= 1'b0;
			case(ss)
			0:		begin ss <= ss + 6'b1; DATA 	<= {setad, 8'd14};			end	
			1: 	begin ss <= ss + 6'b1; DATA 	<= {write, _0};				end
			2:		begin ss <= ss + 6'b1; DATA 	<= {setad, 8'd54};			end
			3: 	begin ss <= ss + 6'b1; DATA 	<= {write, _0};				end
			4:		begin ss <= ss + 6'b1; DATA 	<= {setad, encodedData[3]};end
			5: 	begin ss <= ss + 6'b1; DATA 	<= {write, encodedData[0]};end
			6:		begin ss <= ss + 6'b1; DATA 	<= {setad, encodedData[3] + 8'd40};	end
			7: 	begin ss <= ss + 6'b1; DATA 	<= {write, encodedData[1]};end
			8:		begin ss <= ss + 6'b1; DATA 	<= {setad, 8'd4};				end
			9: 	begin ss <= ss + 6'b1; DATA 	<= {write, _P};				end
			10: 	begin ss <= ss + 6'b1; DATA 	<= {write, l};					end
			11: 	begin ss <= ss + 6'b1; DATA 	<= {write, a};					end
			12: 	begin ss <= ss + 6'b1; DATA 	<= {write, y};					end
			13: 	begin ss <= ss + 6'b1; DATA 	<= {write, e};					end
			14: 	begin ss <= ss + 6'b1; DATA 	<= {write, r};					end
			15: 	begin ss <= ss + 6'b1; DATA 	<= {write, _1};				end
			16: 	begin ss <= ss + 6'b1; DATA 	<= {write, khoang_trang};	end
			17: 	begin ss <= ss + 6'b1; DATA 	<= {write, w};					end
			18: 	begin ss <= ss + 6'b1; DATA 	<= {write, i};					end
			19: 	begin ss <= ss + 6'b1; DATA 	<= {write, n};					end
			20: 	begin ss <= ss + 6'b1; DATA 	<= {write, cham_thang};		end
			21:	begin ss <= ss + 6'b1; DATA 	<= {setad, 8'd46};			end
			22: 	begin ss <= ss + 6'b1; DATA 	<= {write, khoang_trang};	end
			23: 	begin ss <= ss + 6'b1; DATA 	<= {write, khoang_trang};	end
			24: 	begin ss <= ss + 6'b1; DATA 	<= {write, _2};				end
			25: 	begin ss <= ss + 6'b1; DATA 	<= {write, tru};				end
			26: 	begin ss <= ss + 6'b1; DATA 	<= {write, encodedData[2]};end
			27:	begin ss <= ss + 6'b1; DATA 	<= {setad, 8'd52};			end
			28: 	begin ss <= ss + 6'b1; DATA 	<= {write, khoang_trang};	end
			29: 	begin ss <= ss + 6'b1; DATA 	<= {write, khoang_trang};	end
			30: 	begin ss <= ss + 6'b1; DATA 	<= {write, khoang_trang};	end
			31:	begin ss <= ss + 6'b1; DATA 	<= {wait2, 8'd00};			end
			default:		begin ss <= 6'b0; state <= 4'd15; DATA 	<= {wait1, 8'd00};	end
			endcase
		end

		// End game, player2 win
		6: begin
			rdy_command <= 1'b0;
			case(ss)
			0:		begin ss <= ss + 6'b1; DATA 	<= {setad, 8'd14};			end	
			1: 	begin ss <= ss + 6'b1; DATA 	<= {write, _0};				end
			2:		begin ss <= ss + 6'b1; DATA 	<= {setad, 8'd54};			end
			3: 	begin ss <= ss + 6'b1; DATA 	<= {write, _0};				end
			4:		begin ss <= ss + 6'b1; DATA 	<= {setad, encodedData[3]};end
			5: 	begin ss <= ss + 6'b1; DATA 	<= {write, encodedData[0]};end
			6:		begin ss <= ss + 6'b1; DATA 	<= {setad, encodedData[3] + 8'd40};	end
			7: 	begin ss <= ss + 6'b1; DATA 	<= {write, encodedData[1]};end
			8:		begin ss <= ss + 6'b1; DATA 	<= {setad, 8'd4};				end
			9: 	begin ss <= ss + 6'b1; DATA 	<= {write, _P};				end
			10: 	begin ss <= ss + 6'b1; DATA 	<= {write, l};					end
			11: 	begin ss <= ss + 6'b1; DATA 	<= {write, a};					end
			12: 	begin ss <= ss + 6'b1; DATA 	<= {write, y};					end
			13: 	begin ss <= ss + 6'b1; DATA 	<= {write, e};					end
			14: 	begin ss <= ss + 6'b1; DATA 	<= {write, r};					end
			15: 	begin ss <= ss + 6'b1; DATA 	<= {write, _2};				end
			16: 	begin ss <= ss + 6'b1; DATA 	<= {write, khoang_trang};	end
			17: 	begin ss <= ss + 6'b1; DATA 	<= {write, w};					end
			18: 	begin ss <= ss + 6'b1; DATA 	<= {write, i};					end
			19: 	begin ss <= ss + 6'b1; DATA 	<= {write, n};					end
			20: 	begin ss <= ss + 6'b1; DATA 	<= {write, cham_thang};		end
			21:	begin ss <= ss + 6'b1; DATA 	<= {setad, 8'd46};			end
			22: 	begin ss <= ss + 6'b1; DATA 	<= {write, khoang_trang};	end
			23: 	begin ss <= ss + 6'b1; DATA 	<= {write, khoang_trang};	end
			24: 	begin ss <= ss + 6'b1; DATA 	<= {write, _2};				end
			25: 	begin ss <= ss + 6'b1; DATA 	<= {write, tru};				end
			26: 	begin ss <= ss + 6'b1; DATA 	<= {write, encodedData[2]};end
			27:	begin ss <= ss + 6'b1; DATA 	<= {setad, 8'd52};			end
			28: 	begin ss <= ss + 6'b1; DATA 	<= {write, khoang_trang};	end
			29: 	begin ss <= ss + 6'b1; DATA 	<= {write, khoang_trang};	end
			30: 	begin ss <= ss + 6'b1; DATA 	<= {write, khoang_trang};	end
			31:	begin ss <= ss + 6'b1; DATA 	<= {wait2, 8'd00};			end
			default:		begin ss <= 6'b0; state <= 4'd15; DATA 	<= {wait1, 8'd00};	end
			endcase
		end
		
		// waiting for new operation
		14: begin
			rdy_command <= 1'b0;
			DATA 	<= {wait1, 8'd00};
			ss <= ss;
			case(op)
				0: state <= 4'd0;
				1: state <= 4'd1;
				2: state <= 4'd2;
				3: state <= 4'd3;
				4: state <= 4'd4;
				5: state <= 4'd5;
				6: state <= 4'd6;
				default: state <= 4'd15;
			endcase
		end
		// idle
		default: begin
			rdy_command <= 1'b1;
			DATA 	<= {wait1, 8'd00};
			ss <= ss;
			state <= 4'd14;
		end
		
		endcase
	end
	
endmodule