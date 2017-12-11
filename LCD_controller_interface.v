module LCD_controller_interface(
	input CLOCK_50,
	input [3:0] KEY,
	output LCD_RS, LCD_RW, LCD_EN,
	output [7:0] LCD_DATA,
	output [17:0] LEDR,
	output [6:0] HEX4, HEX5, HEX6, HEX7
);
		

	LCD_controller controller(CLOCK_50, KEY[3], KEY[0], KEY[1], LCD_RS, LCD_RW, LCD_EN, 
				  HEX6, HEX7, HEX4, HEX5,
				  LCD_DATA, LEDR[0], LEDR[1], LEDR[5:2]);
	
endmodule