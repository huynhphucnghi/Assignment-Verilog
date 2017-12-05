module LCD_controller_interface(
	input CLOCK_50,
	input [0:0] KEY,
	output LCD_RS, LCD_RW, LCD_EN,
	output [7:0] LCD_DATA,
	output [0:0] LEDR
);

	LCD_controller(CLOCK_50, KEY[0], LCD_RS, LCD_RW, LCD_EN, LCD_DATA, LEDR[0]);
	
endmodule