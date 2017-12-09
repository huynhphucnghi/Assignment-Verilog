`timescale 1ns/1ns
module LCD_controller_tb;
	reg clk;
	reg rst, p1win, p2win;
	wire LCD_RS, LCD_RW, LCD_EN;
	wire [7:0] LCD_DATA;
	wire rdy, rdy_command;
	wire [3:0] state;
		
	LCD_controller controller(clk, rst, p1win, p2win, LCD_RS, LCD_RW, LCD_EN, LCD_DATA, rdy_command, rdy, state);
	
	initial begin
		clk = 0;
		rst = 1;
		p1win = 1;
		p2win = 1;
		#9000;
		p1win = 0;
		#500;
		p1win = 1;
		#2500 $stop;
	end
	
	always #5 clk = ~clk;
	
endmodule