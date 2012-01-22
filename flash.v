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
	inout [7:0] NF_A,
	output [7:0] NF_D,
	inout [7:0] addr, //do polaczenia z pozostalymi modulami
	input [7:0] data, //jak wyzej
	input direction_rw, //kierunek odczyt lub zapis
	input fb_start, //podnoszac linie z zew jest wyzwalaczem akcji zapisu lub odczytu; obnizajac z wew informuje ze akcja zostala wykonana
	output reg fb_done,
	output reg ft_start,
	input ft_done
	);
	
	assign NF_A[7:0] = addr[7:0]; //TODO czy dziala w obie strony ??
	assign NF_D[7:0] = data[7:0]; //TODO jak wyzej ??
	
//	reg NF_CE_;
//	reg NF_WE_;
//	reg NF_OE_;
//	assign NF_CE = NF_CE_;
//	assign NF_WE = NF_WE_;
//	assign NF_OE = NF_OE_;
		
	reg direction_rw_;
//	reg fb_action_;
//	reg ft_action_;
	assign direction_rw = direction_rw_;
//	assign fb_action = fb_action_;
//	assign ft_action = ft_action_;

	always @(posedge RST) // czy posedge
	begin
		//NF_RP = 1'b1; // czy 1
		NF_CE = 1'b1; //wylaczenie ukladu
		NF_WE = 1'b1; //wylaczenie zapisu
		NF_OE = 1'b1; //wylaczenie odczytu
		NF_BYTE=1'b0; //8bit data
		NF_WP=1'b0; //Protect two outermost Flash boot blocks against all program and erase operations.
	end


	localparam 	STATE_A = 3'd0,
			STATE_B = 3'd1,
			STATE_C = 3'd2,
			STATE_D = 3'd3;

	reg [2:0] state = STATE_A;
	reg [2:0] next_state = STATE_A;

	always @(posedge CLK_50MHZ)
	begin
		if(RST) begin
			state <= STATE_A;
		end
		state <= next_state;
	end

	always @(posedge CLK_50MHZ)
	begin
		if(fb_start == 1'b1) //uklad nadrzedny nakazal wykonanie akcji
		begin
			if(direction_rw == 1'b1) // kierunek: odczyt
			begin
				case(state)
				STATE_A: begin
						NF_CE <= 1'b0;
						NF_OE <= 1'b0;
						ft_start <= 1'b1;
						next_state <= STATE_B;
					end
				STATE_B: begin
						if(ft_done == 1) begin
							next_state <= STATE_C;
						end
						else begin //czy konieczne?
							next_state <= STATE_B;
						end
					end
				STATE_C: begin
						NF_CE <= 1'b1;
						NF_OE <= 1'b1;
						next_state <= STATE_A;
						ft_start <= 0; // odczyt ukonczony
						fb_done <= 0;
					end
				endcase
			end
			else
			begin
				case(state)
				STATE_A: begin
						NF_CE <= 1'b0;
						NF_OE <= 1'b1;
						NF_WE <= 1'b0;
						next_state <= STATE_B;
						ft_start <= 1'b1;
					end
				STATE_B: begin
						if(ft_done == 1) begin
							next_state <= STATE_C;
						end
					end
				STATE_C: begin
						NF_CE <= 1'b1;
						NF_WE <= 1'b1;
						next_state <= STATE_A;
						ft_start <= 0;
						fb_done <= 0;
					end
				endcase
			end
		end
	end

endmodule
