`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:31:42 01/12/2012 
// Design Name: 
// Module Name:    flash_test 
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
module flash_test(
	input CLK,
	output NF_CE, NF_BYTE, NF_OE, NF_RP, NF_WE, NF_WP,
	input NF_STS,
	inout NF_A[7:0],
	inout NF_D[7:0],
    );
	 
	  NF_CE, NF_BYTE, NF_OE, NF_RP, NF_WE, NF_WP,
	input NF_STS,
	inout NF_A[7:0],
	inout NF_D[7:0],
	inout addr[7:0], //do polaczenia z pozostalymi modulami
	inout data[7:0], //jak wyzej
	input direction_rw, //kierunek odczyt lub zapis
	input do_rw, //wyzwalacz akcji zapisu lub odczytu
	output done, //czy juz wartosc zostala zapisana lub odczytana
	input rst, //linia musi dotrzec rowniez do flash_clocka
	input clk_f,
	output czasomierz_start,
	input czasomierz_done
	
	reg addr[7:0];
	reg data[7:0];
	reg direction_rw;
	reg do_rw;
	wire done;
	reg rst = 1'b0;
	wire clk_f;
	flash_clock fl_c(CLK, clk_f);
	//TODO czasomierz

	flash fl(NF_CE, NF_BYTE, NF_OE, NF_RP, NF_WE, NF_WP, NF_STS, NF_A[7:0], NF_D[7:0], addr[7:0], data[7:0], direction_rw, do_rw, done, rst, clk_f)
	
	#20
	addr[7:0] = 8'b00110101;
	data[7:0] = 8'b11001001;
	direction_rw = 1'b0; //write
	do_rw = 1'b1;
	#100
endmodule
