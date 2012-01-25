`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:46:27 01/22/2012 
// Design Name: 
// Module Name:    MANAGER 
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
module MANAGER( CLK_50MHZ, RST, RS_FLOW, RS_DATAIN, RS_DATAOUT, RS_TRG_READ, RS_TRG_WRITE,
						RS_DONE, FL_DATA, FL_ADDR, FL_TRG, FL_STATUS, FL_FLOW );
input CLK_50MHZ;
input RST;
output reg RS_FLOW; //TODO del
output [7:0] RS_DATAIN;
input [7:0] RS_DATAOUT;
input RS_TRG_READ;
output RS_TRG_WRITE;
input RS_DONE;

inout [7:0] FL_DATA;
output [7:0] FL_ADDR; 
output FL_TRG;
input FL_STATUS;
output FL_FLOW;

//reg [7:0] data;

wire [7:0] cmd_rx;
wire [7:0] addr_rx, addr_tx;
wire [7:0] data_rx, data_tx;
wire fl_trg, tx_trig;

Manager_RX_FSM m_rx_fsm(
	CLK_50MHZ,
	RST,
	RS_DATAOUT,
	RS_DONE,
	fl_trg,
	cmd_rx,
	addr_rx,
	data_rx
);

Manager_Flash_FSM m_flash_fsm(
	.CLK_50MHZ(CLK_50MHZ),
	.RST(RST),
	.cmd_rx(cmd_rx),
	.FL_FLOW(FL_FLOW),
	.FL_ADDR(FL_ADDR),
	.FL_DATA(FL_DATA),
	.addr_rx(addr_rx),
	.data_rx(data_rx),
	.addr_tx(addr_tx),
	.data_tx(data_tx),
	.fb_start(FL_TRG),
	.fb_done(FL_STATUS),
	.fl_trg(fl_trg),
	.tx_trig(tx_trig)
);

Manager_TX_FSM m_tx_fsm(
	CLK_50MHZ,
	RST,
	tx_trig,
	addr_tx,
	data_tx,
	RS_DATAIN,
	RS_TRG_WRITE
);






//always @(posedge CLK_50MHZ) begin
//	if( RST ) begin
//		state <= IDLE;
//	end else begin
//		state <= next;
//	end
//end
//
//	
//always @* begin
//	// XXXX ALL OUTPUTS
//	
//	case( state )
//		IDLE: begin
//				next = RX_WAITING_CMD;
//		end
//		
//		WAITING_RS: begin
//				if( RS_DONE ) begin
//					next = READING_RS;
//				end else begin
//					next = WAITING_RS;
//				end
//		end
//		
//		READING_RS: begin
//					next = WRITING_FL;
//		end
//		
//		WRITING_FL: begin
//					next = WAITING_FL;		
//		end
//		
//		WAITING_FL: begin
//			if( FL_STATUS ) next = STOP;
//			else	next = WAITING_FL;
//		end
//		
//		STOP: begin
//				next = IDLE;
//		end
//	endcase
//end
//
//
//always @* begin
//	if( RST ) FL_FLOW = 1;
//	
//	RS_DATAIN = 8'bx;
//	RS_TRG_READ = 1'bx;
//	RS_TRG_WRITE = 1'bx;
//	FL_TRG = 0;
//	
//	case( fsm_state )
//		WAITING_RS: begin
//			FL_DATA = RS_DATAOUT;
//		end
//		
//		WRITING_FL: begin
//			FL_FLOW = 0;
//			FL_TRG = 1;
//		end
//		
//		STOP: begin
//			FL_TRG = 0;
//		end
//	endcase
//end					

endmodule
