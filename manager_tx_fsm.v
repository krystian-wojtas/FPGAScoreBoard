`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:15:27 01/25/2012 
// Design Name: 
// Module Name:    manager_tx_fsm 
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
module Manager_TX_FSM(
	input CLK_50MHZ,
	input RST,
	input tx_trig,
	input [7:0] data_tx,
	output reg [7:0] RS_DATAIN,
	output reg RS_TRG_WRITE
   );
	
	reg [2:0] state_tx; //TODO 2bits
	localparam [2:0]	IDLE = 3'd0,
							TX_WAITING_TRIG = 3'd1,
							TX_WRITING_DATA = 3'd2;

	always @(posedge CLK_50MHZ) begin
		if(RST) state_tx <= IDLE; // przebieg jalowy dla ustalenia sie state_tx w procesie flasha stanu idle
		else begin
			case (state_tx)
				IDLE: begin
					state_tx <= TX_WAITING_TRIG;
				end
				TX_WAITING_TRIG:
					if( tx_trig )
						state_tx <= TX_WRITING_DATA;
				TX_WRITING_DATA:
					state_tx <= IDLE;
			endcase
		end
	end


	always @* begin
		RS_DATAIN = 8'dX;
		RS_TRG_WRITE = 1'bX;
		case( state_tx )
			IDLE:
				RS_TRG_WRITE = 1'b0;
			TX_WRITING_DATA: begin
				RS_DATAIN = data_tx;
				RS_TRG_WRITE = 1'b1;
			end
		endcase
	end

endmodule
