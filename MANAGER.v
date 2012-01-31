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
module MANAGER( CLK_50MHZ, RST, RS_DATAIN, RS_DATAOUT, RS_TRG_WRITE,
						RS_DONE, fl_data_in, fl_data_out, FL_ADDR, FL_TRG, FL_STATUS, FL_FLOW );
input CLK_50MHZ;
input RST;
output [7:0] RS_DATAIN;
input [7:0] RS_DATAOUT;
output RS_TRG_WRITE;
input RS_DONE;

input [7:0] fl_data_in;
output [7:0] fl_data_out;

output [7:0] FL_ADDR; 
output FL_TRG;
input FL_STATUS;
output FL_FLOW;

wire cmd_rx;
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
	.fl_data_in(fl_data_in),
	.fl_data_out(fl_data_out),
	.addr_rx(addr_rx),
	.data_rx(data_rx),
	.data_tx(data_tx),
	.fb_start(FL_TRG),
	.fb_done(FL_STATUS),
	.fl_trg(fl_trg),
	.tx_trig(tx_trig)
);

Manager_TX_FSM m_tx_fsm(
	.CLK_50MHZ(CLK_50MHZ),
	.RST(RST),
	.tx_trig(tx_trig),
	.data_tx(data_tx),
	.RS_DATAIN(RS_DATAIN),
	.RS_TRG_WRITE(RS_TRG_WRITE)
);
			

endmodule
