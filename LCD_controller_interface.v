module LCD_controller_interface(
	input CLOCK_50,
	input [3:0] KEY,
	input IRDA_RXD,
	output LCD_RS, LCD_RW, LCD_EN,
	output [7:0] LCD_DATA,
	output [17:0] LEDR,
	output [7:0] LEDG,
	output [6:0] HEX4, HEX5, HEX6, HEX7
);

	LCD_controller LCD_controller(
		CLOCK_50, KEY[0], KEY[3], KEY[2], LCD_RS, LCD_RW, LCD_EN, 
		HEX6, HEX7, HEX4, HEX5, LEDG[7], LEDG[6], LEDG[0],
		LCD_DATA, LEDR[5], LEDR[4], LEDR[3:0],
		LEDR[15:8],IRDA_RXD
);	
	
endmodule
