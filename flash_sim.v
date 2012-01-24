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
module Flash_sim(
	input [7:0] NF_A,
	input [7:0] NF_D,  //TODO inout
	input NF_CE, NF_BYTE, NF_OE, NF_WE, NF_RP, NF_WP,
	output reg NF_STS
	);

	always @(negedge NF_WE) begin
		$display("%t [FLASH] Zapis pod adres 0x%b bajtu 0x%b", $time, NF_A[7:0], NF_D[7:0]);
	end

	always @(negedge NF_OE) begin
		$display("%t [FLASH] Odczyt z adresu 0x%b bajtu 0x%b", $time, NF_A[7:0], NF_D[7:0]);
	end

endmodule
