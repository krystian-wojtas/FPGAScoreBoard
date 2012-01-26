`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:11:42 01/24/2012 
// Design Name: 
// Module Name:    flash_sim 
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
module Flash_sim
	#(parameter DEPTH=8)
	(
	input [7:0] NF_A,
	inout [7:0] NF_D,
	input NF_CE, NF_BYTE, NF_OE, NF_WE, NF_RP, NF_WP,
	output reg NF_STS = 0
	);
	localparam N=2**DEPTH;	
	reg [7:0] flash_storage [N-1:0];
	
	reg czy_czytamy = 0;
	assign NF_D = (czy_czytamy) ? 8'bZ : flash_storage[NF_A];

	always @(negedge NF_WE) begin
		czy_czytamy = 1;
		#10;
		flash_storage[NF_A][7:0] = NF_D[7:0];
		#10;
		czy_czytamy = 0;
		$display("%t [FLASH] Zapis pod adres 0x%b bajtu 0x%b", $time, NF_A[7:0], flash_storage[NF_A][7:0]);
	end

	always @(negedge NF_OE) begin	
		czy_czytamy = 0;
		//NF_D[7:0] = flash_storage[NF_A][7:0];
		$display("%t [FLASH] Odczyt z adresu 0x%b bajtu 0x%b", $time, NF_A[7:0],  flash_storage[NF_A][7:0]);
	end

endmodule


