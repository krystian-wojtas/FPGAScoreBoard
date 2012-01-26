`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:50:23 01/26/2012 
// Design Name: 
// Module Name:    fl_sim_test 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module fl_sim_test(
    );

	reg [7:0] NF_A = 8'b00001100;
	wire [7:0] NF_D;
	reg NF_CD = 1;
	reg NF_BYTE = 1;
	reg NF_OE = 1;
	reg NF_WE = 1;
	reg NF_RP = 1;
	reg NF_WP = 1;

	Flash_sim sim( 
		NF_A,
		NF_D,
		NF_CE, NF_BYTE, NF_OE, NF_WE, NF_RP, NF_WP,
		NF_STS
	);
	
	reg [7:0] data = 8'b01010101;
	
	reg czy_czytamy = 0;
	assign NF_D = (czy_czytamy) ? 8'bZ : data;
	
	initial begin
		#10;
		czy_czytamy = 0;
		NF_WE = 0;
		#10;
		$display("Zapisujemy: %b", NF_D);
		czy_czytamy = 1;
		NF_WE = 1;	
		
		#10;
		
		czy_czytamy = 1;
		NF_OE = 0;	
		#10;
		$display("Odczytujemy: %b", NF_D);		
		czy_czytamy = 0;
		NF_OE = 1;
	end

endmodule
