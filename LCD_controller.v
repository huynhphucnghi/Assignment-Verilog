module LCD_controller(
	clk, rst, p1win, p2win, LCD_RS, LCD_RW, LCD_EN, LCD_DATA, rdy_command, rdy, state
);
	input clk, rst, p1win, p2win;
	output LCD_RS, LCD_RW, LCD_EN, rdy_command, rdy;
	output [7:0] LCD_DATA;
	output [3:0] state;
	
	wire rdy;
	wire [3:0] op;
	wire [7:0] data;
	reg enb = 1;
	LCD_executor lcd(clk, enb, 1'b1, op, data, LCD_RS, LCD_RW, LCD_EN, LCD_DATA, rdy);
	
	wire [11:0] DATA;
	wire rdy_command;
	reg [3:0] op_command;
	reg [23:0] data_command;
	LCD_command command(DATA, rdy_command, op_command, data_command, rdy, state);
	
	assign data 		= DATA[7:0];
	assign op 			= DATA[11:8];
	
	reg [2:0] games[2:0][1:0];
	reg [1:0] sets[1:0];
	reg [1:0] currentSet = 0;
	
	
	initial begin
		games[0][0] <= 3'b0;
		games[0][1] <= 3'b0;
		games[1][0] <= 3'b0;
		games[1][1] <= 3'b0;
		games[2][0] <= 3'b0;
		games[2][1] <= 3'b0;
		sets[0] <= 2'b0;
		sets[1] <= 2'b0;
		op_command <= 4'd15;
		data_command <= 4'd0;
	end
	
	always@(posedge rdy_command) begin
		if(!rst) begin
			op_command <= 4'd0;
			data_command <= data_command;
			games[0][0] <= 3'b0;
			games[0][1] <= 3'b0;
			games[1][0] <= 3'b0;
			games[1][1] <= 3'b0;
			games[2][0] <= 3'b0;
			games[2][1] <= 3'b0;
			sets[0] <= 2'b0;
			sets[1] <= 2'b0;
		end
		else if(!p1win) begin
			if(games[currentSet][0] == 3'd6 || (games[currentSet][0] == 3'd5 && games[currentSet][1] <= 3'd4)) begin
				currentSet <= currentSet + 2'd1;
				games[currentSet][0] <= 3'd0;
				games[currentSet][1] <= 3'd0;
				sets[0] <= sets[0] + 2'b1;
				data_command <= {6'b0, sets[0] + 2'd1, 5'b0, games[currentSet][1], 5'b0, games[currentSet][0] + 3'b1};
				op_command <= 4'd3;
			end
			else begin
				games[currentSet][0] <= games[currentSet][0] + 3'b1;
				data_command <= games[currentSet][0] + 3'b1;
				op_command <= 4'd1;
			end
		end
		else if(!p2win) begin
			if(games[currentSet][1] == 3'd6 || (games[currentSet][1] == 3'd5 && games[currentSet][0] <= 3'd4)) begin
				currentSet <= currentSet + 2'd1;
				games[currentSet][0] <= 3'd0;
				games[currentSet][1] <= 3'd0;
				sets[1] <= sets[1] + 2'b1;
				data_command <= {6'b0, sets[1] + 2'b1, 5'b0, games[currentSet][1] + 3'b1, 5'b0, games[currentSet][0]};
				op_command <= 4'd4;
			end
			else begin
				games[currentSet][1] <= games[currentSet][1] + 3'b1;
				data_command <= games[currentSet][1] + 3'b1;
				op_command <= 4'd2;
			end
		end
		else begin
			op_command <= 4'd15;
			data_command <= data_command;
		end
	end
	

endmodule