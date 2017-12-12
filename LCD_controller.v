module LCD_controller(
	clk, rst, p1, p2, LCD_RS, LCD_RW, LCD_EN, 
 	p1_point_0, p1_point_1, p2_point_0, p2_point_1,
	deuce_p1, deuce_p2, tie_break,
 	LCD_DATA, rdy_cmd, rdy_exe, state,
	data_hex,
	IRDA_RXD
);
	input clk, rst, p1, p2;
	input IRDA_RXD;
	output [6:0] p1_point_0, p1_point_1, p2_point_0, p2_point_1;
	output deuce_p1, deuce_p2; 
	output reg tie_break;
	output LCD_RS, LCD_RW, LCD_EN, rdy_cmd, rdy_exe;
	output [7:0] LCD_DATA;
	output [3:0] state;
	output [7:0]data_hex;
	
	assign data_hex = hex_data[23:16];

	wire rdy_cmd;					// ready signal for LCD_command
	reg [3:0] op_cmd;				// operation for LCD_command
	reg [31:0] data_cmd;			// data for LCD_command
	LCD_command command(op_cmd, data_cmd, rdy_exe, {op_exe, data_exe}, rdy_cmd, state);
	
	wire rdy_exe;					// ready signal for LCD_executor
	wire [3:0] op_exe;			// operation for LCD_executor
	wire [7:0] data_exe;			// data for LCD_executor
	reg enb_exe = 1'b1;
	reg rst_exe = 1'b1;
	LCD_executor executor(clk, enb_exe, rst_exe, op_exe, data_exe, LCD_RS, LCD_RW, LCD_EN, LCD_DATA, rdy_exe);
	
	// IR receive
	wire reset=1'b1;
	wire data_ready;
	wire [31:0] hex_data;
	IR_RECEIVE u1(
					///clk 50MHz////
					.iCLK(clk), 
					//reset          
					.iRST_n(reset),        
					//IRDA code input
					.iIRDA(IRDA_RXD), 
					//read command      
					//.iREAD(data_read),
					//data ready      					
					.oDATA_READY(data_ready),
					//decoded data 32bit
					.oDATA(hex_data)        
					);
	
	// Data of the tennis game
	reg [2:0] games[2:0][1:0];
	reg [1:0] sets[1:0];
	reg [1:0] currentSet;
	reg endGame;
	
	

	points_in_game(p1_point_0, p1_point_1, p2_point_0, p2_point_1, deuce_p1, deuce_p2, p1win, p2win, tie_break, p1_q, p2_q, rst, rdy_cmd);
	
	
	initial begin
		games[0][0] <= 3'b0;
		games[0][1] <= 3'b0;
		games[1][0] <= 3'b0;
		games[1][1] <= 3'b0;
		games[2][0] <= 3'b0;
		games[2][1] <= 3'b0;
		sets[0] <= 2'b0;
		sets[1] <= 2'b0;
		currentSet <= 2'b0;
		endGame <= 1'b0;
		op_cmd <= 4'd15;
		data_cmd <= 4'd0;
		tie_break <= 1'b0;
	end
	
	wire ivent = (hex_data[23:16] == 16'h12); 
	wire p1_q = (hex_data[23:16] == 16'h1A) || p1;
	wire p2_q = (hex_data[23:16] == 16'h1E) || p2;
	
	always@(posedge rdy_cmd) begin
		if(!rst || ivent) begin								// Reset the game
			op_cmd <= 4'd0;
			data_cmd <= data_cmd;
			games[0][0] <= 3'b0;
			games[0][1] <= 3'b0;
			games[1][0] <= 3'b0;
			games[1][1] <= 3'b0;
			games[2][0] <= 3'b0;
			games[2][1] <= 3'b0;
			sets[0] <= 2'b0;
			sets[1] <= 2'b0;
			currentSet <= 2'b0;
			endGame <= 1'b0;
			tie_break <= 1'b0;
		end

		else if(p1win && !endGame) begin	// If player1 win point
			// If current set end
			if(games[currentSet][0] == 3'd5 && games[currentSet][1] == 3'd6) begin
				tie_break <= 1;
				games[currentSet][0] <= games[currentSet][0] + 3'b1;
				data_cmd <= games[currentSet][0] + 3'b1;
				op_cmd <= 4'd1;
			end
			if(games[currentSet][0] == 3'd6 && games[currentSet][1] == 3'd6) begin
				tie_break <= 0;
				currentSet <= currentSet + 2'd1;
				games[currentSet][0] <= 3'd0;
				games[currentSet][1] <= 3'd0;
				sets[0] <= sets[0] + 2'b1;
				// If player1 win the tie_break
				if(sets[0] + 2'b1 != 2'd2) begin
					data_cmd <= {6'b0, currentSet, 6'b0, sets[0] + 2'b1, 5'b0, games[currentSet][1], 5'b0, games[currentSet][0] + 3'b1};
					op_cmd <= 4'd3;
				end
				else begin
					data_cmd <= {6'b0, currentSet, 6'b0, sets[1], 5'b0, games[currentSet][1], 5'b0, games[currentSet][0] + 3'b1};
					op_cmd <= 4'd5;
					endGame <= 1'b1;
				end
			end
			else if(games[currentSet][0] == 3'd6 || (games[currentSet][0] == 3'd5 && games[currentSet][1] <= 3'd4)) begin
				currentSet <= currentSet + 2'd1;
				games[currentSet][0] <= 3'd0;
				games[currentSet][1] <= 3'd0;
				sets[0] <= sets[0] + 2'b1;
				// If player1 win the game
				if(sets[0] + 2'b1 != 2'd2) begin
					data_cmd <= {6'b0, currentSet, 6'b0, sets[0] + 2'b1, 5'b0, games[currentSet][1], 5'b0, games[currentSet][0] + 3'b1};
					op_cmd <= 4'd3;
				end
				else begin
					data_cmd <= {6'b0, currentSet, 6'b0, sets[1], 5'b0, games[currentSet][1], 5'b0, games[currentSet][0] + 3'b1};
					op_cmd <= 4'd5;
					endGame <= 1'b1;
				end
			end
			else begin
				games[currentSet][0] <= games[currentSet][0] + 3'b1;
				data_cmd <= games[currentSet][0] + 3'b1;
				op_cmd <= 4'd1;
			end
		end

		else if(p2win && !endGame) begin	// If player2 win point
			// If current set end
			if(games[currentSet][1] == 3'd5 && games[currentSet][0] == 3'd6) begin
				tie_break <= 1;
				games[currentSet][1] <= games[currentSet][1] + 3'b1;
				data_cmd <= games[currentSet][1] + 3'b1;
				op_cmd <= 4'd2;
			end
			if(games[currentSet][0] == 3'd6 && games[currentSet][1] == 3'd6) begin
				tie_break <= 0;
				currentSet <= currentSet + 2'd1;
				games[currentSet][0] <= 3'd0;
				games[currentSet][1] <= 3'd0;
				sets[0] <= sets[0] + 2'b1;
				// If player2 win the tie_break
				if(sets[1] + 2'b1 != 2'd2) begin
					data_cmd <= {6'b0, currentSet, 6'b0, sets[1] + 2'b1, 5'b0, games[currentSet][1] + 3'b1, 5'b0, games[currentSet][0]};
					op_cmd <= 4'd4;
				end
				else begin
					data_cmd <= {6'b0, currentSet, 6'b0, sets[0], 5'b0, games[currentSet][1] + 3'b1, 5'b0, games[currentSet][0]};
					op_cmd <= 4'd6;
					endGame <= 1'b1;
				end
			end
			else if(games[currentSet][1] == 3'd6 || (games[currentSet][1] == 3'd5 && games[currentSet][0] <= 3'd4)) begin
				currentSet <= currentSet + 2'd1;
				games[currentSet][0] <= 3'd0;
				games[currentSet][1] <= 3'd0;
				sets[1] <= sets[1] + 2'b1;
				// If player2 win the game
				if(sets[1] + 2'b1 != 2'd2) begin
					data_cmd <= {6'b0, currentSet, 6'b0, sets[1] + 2'b1, 5'b0, games[currentSet][1] + 3'b1, 5'b0, games[currentSet][0]};
					op_cmd <= 4'd4;
				end
				else begin
					data_cmd <= {6'b0, currentSet, 6'b0, sets[0], 5'b0, games[currentSet][1] + 3'b1, 5'b0, games[currentSet][0]};
					op_cmd <= 4'd6;
					endGame <= 1'b1;
				end
			end
			else begin
				games[currentSet][1] <= games[currentSet][1] + 3'b1;
				data_cmd <= games[currentSet][1] + 3'b1;
				op_cmd <= 4'd2;
			end
		end
		
		else begin				// When the game end, fall to idle state, waiting for reset signal to restart the game
			op_cmd <= 4'd15;
			data_cmd <= data_cmd;
		end
		
	end
	
	
	

endmodule
