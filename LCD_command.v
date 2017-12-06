module LCD_command(
	output reg [11:0] DATA, input [31:0] _i
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
		wait2 = 4'b0100;

	always@(_i) begin
		case(_i)
		0:		DATA 	= {setad, 8'd04};
		1: 	DATA 	= {write, _W};
		2: 	DATA 	= {write, e};
		3: 	DATA 	= {write, l};
		4: 	DATA 	= {write, c};
		5: 	DATA 	= {write, o};
		6: 	DATA 	= {write, m};
		7: 	DATA 	= {write, e};
		8: 	DATA 	= {write, cham_thang};
		9: 	DATA 	= {setad, 8'd43};
		10: 	DATA 	= {write, _L};
		11: 	DATA 	= {write, e};
		12: 	DATA 	= {write, t};
		13: 	DATA 	= {write, ngoac_don};
		14: 	DATA 	= {write, s};
		15: 	DATA 	= {write, khoang_trang};
		16: 	DATA 	= {write, p};
		17: 	DATA 	= {write, l};
		18: 	DATA 	= {write, a};
		19: 	DATA 	= {write, y};
		20: 	DATA 	= {wait2, 8'd00};
		21: 	DATA 	= {clear, 8'd00};
		default: DATA 	= {clear, 8'd00};
		endcase
	end
	
endmodule