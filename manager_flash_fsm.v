`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:15:09 01/25/2012 
// Design Name: 
// Module Name:    manager_flash_fsm 
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
module Manager_Flash_FSM(
	input CLK_50MHZ,
	input RST,
	input cmd_rx,
	output reg FL_FLOW,
	output reg [7:0] FL_ADDR,
	input [7:0] fl_data_in,
	output reg [7:0] fl_data_out,
	input [7:0] addr_rx,
	input [7:0] data_rx,
	output reg [7:0] data_tx,
	output reg fb_start,
	input fb_done,
	input fl_trg,
	output reg tx_trig
   );
	
	reg [7:0] data_tx_buf;
	reg [2:0] state_fl; //TODO 2bits
	localparam [2:0]	IDLE = 3'd0,
							FL_WAITING_TRIG = 3'd1,
							FL_RW = 3'd2,
							FL_WAITING_RW = 3'd3,
							TX_TRG = 3'd4,
							TX_TRG_DONE = 3'd5;							
	
	always @(posedge CLK_50MHZ) begin
		if(RST) state_fl <= IDLE;
		else begin
			case (state_fl)
				IDLE:
					state_fl <= FL_WAITING_TRIG;
				FL_WAITING_TRIG:
					if(fl_trg) state_fl <= FL_RW;
				FL_RW:
					state_fl <= FL_WAITING_RW;
				FL_WAITING_RW:
					if(fb_done) state_fl <= TX_TRG_DONE;
				TX_TRG_DONE:
					state_fl <= FL_WAITING_TRIG;
			endcase
		end
	end

	always @* begin	
		FL_FLOW = 1'bX;
		fb_start = 0;
		tx_trig = 0;
		FL_ADDR = 8'bZ;
		fl_data_out = data_rx;
		data_tx = data_tx_buf;
		case( state_fl )
			IDLE: begin
			end
			FL_RW: begin
				FL_FLOW = cmd_rx;
				FL_ADDR = addr_rx;
				fl_data_out = data_rx;
				fb_start = 1;
			end
			FL_WAITING_RW: begin
				FL_FLOW = cmd_rx;
				FL_ADDR = addr_rx;
				fl_data_out = data_rx;
			end
			TX_TRG_DONE: begin
				tx_trig = 1'b1;				
				//data_tx_buf = fl_data_in;
				data_tx = data_tx_buf;
			end
		endcase
	end
	
always @(posedge tx_trig) begin
	data_tx_buf <= fl_data_in;
end
	
endmodule

