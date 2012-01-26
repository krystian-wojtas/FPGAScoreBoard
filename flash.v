`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:29:21 01/11/2012 
// Design Name: 
// Module Name:    flash 
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
module Flash( //rename FlashBridge?
	input RST, //linia musi dotrzec rowniez do flash_clocka
	input CLK_50MHZ,
	output reg NF_CE, NF_BYTE, NF_OE, NF_RP, NF_WE, NF_WP,
	input NF_STS,
	output [7:0] NF_A,
	inout [7:0] NF_D,
	input [7:0] addr, //do polaczenia z pozostalymi modulami
	inout [7:0] data, //jak wyzej
	input direction_rw, //kierunek odczyt lub zapis
	input fb_start, //podnoszac linie z zew jest wyzwalaczem akcji zapisu lub odczytu; obnizajac z wew informuje ze akcja zostala wykonana
	output reg fb_done
	);
	
		assign NF_A[7:0] = addr[7:0]; //TODO czy dziala w obie strony ??
		
		reg [7:0] flash_data_buf;
		reg czy_czytamy_flash;
		reg czy_czytamy_data;
		assign NF_D = (czy_czytamy_flash) ? 8'bZ : flash_data_buf;
		assign data = (czy_czytamy_data) ? 8'bZ : flash_data_buf;
	
	reg ft_start;
	wire ft_done;
	FlashTimer fl_timer(.CLK_50MHZ(CLK_50MHZ), .RST(RST), .start(ft_start), .done(ft_done));

	localparam 	IDLE = 3'd0,
			RW = 3'd1,
			WAITING = 3'd2,
			DONE = 3'd3;

	reg [2:0] state;
	reg [2:0] next_state;

	always @(posedge CLK_50MHZ)
	begin
		if(RST) begin
			NF_BYTE=1'b0; //8bit data
			NF_WP=1'b0; //Protect two outermost Flash boot blocks against all program and erase operations.
			NF_RP=1;
		end
		else
			NF_RP=0;
	end
	
	always @(posedge CLK_50MHZ)
		if(RST) 
			state <= IDLE;
		else
			state <= next_state;

	always @*
	begin
		next_state = 3'dx;
		case(state)
			IDLE:
				if(fb_start == 1'b1) //uklad nadrzedny nakazal wykonanie akcji
					next_state = RW;
				else
					next_state = IDLE;
			RW: 			
				next_state = WAITING;
			WAITING:
				if(ft_done)
					next_state = DONE;
				else
					next_state = WAITING;
			DONE:
				next_state = IDLE;
		endcase
	end
	
	
	always @*
	begin
		case(state)
			IDLE: begin
				NF_CE = 1'b1; //wylaczenie ukladu
				NF_WE = 1'b1; //wylaczenie zapisu
				NF_OE = 1'b1; //wylaczenie odczytu
				ft_start = 1'b0;
				fb_done = 1'b0;
				czy_czytamy_flash = 0;
				czy_czytamy_data = 0;
			end
			RW: begin
				NF_CE = 1'b0;
				if(direction_rw) begin
					NF_OE = 1'b0;
					czy_czytamy_flash = 1;
					czy_czytamy_data = 0;
				end else begin
					NF_WE = 1'b0;
					czy_czytamy_flash = 0;
					czy_czytamy_data = 1;
					flash_data_buf = data;
				end
				ft_start = 1'b1;
			end
			WAITING:
				ft_start = 0;
			DONE: begin
				if(direction_rw) 
					flash_data_buf = NF_D;
				fb_done = 1;
			end
		endcase
	end
	

endmodule
