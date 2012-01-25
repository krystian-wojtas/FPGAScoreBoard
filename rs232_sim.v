`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:25:31 01/24/2012 
// Design Name: 
// Module Name:    rs232_sim 
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
module rs232_sim( 
				input CLK_50MHZ, // MAIN CLOCK
				input RST, // RESET
				input RX, // RS INPUT (READ)
				output TX // RS OUTPUT (WRITE)
    );

wire DONE;
reg TRG_READ;
reg TRG_WRITE;
reg [7:0] DATA_IN;
wire [7:0] DATA_OUT;
reg FLOW;
//reg [7:0] LAST_RECEIVED;

wire [2:0] state;
reg [7:0] rcv_addr, rcv_data;
reg [7:0] send_buff;


localparam [2:0]	IDLE 				 = 3'd0,
						WAITING_ADDRESS = 3'd1,
						WAITING_DATA 	 = 3'd2,
						DONE_STATE		 = 3'd3;
	
UART u( 
		.RST(RST),
		.TX(TX),
		.RX(RX),
		.CLK_50MHZ(CLK_50MHZ),
		.FLOW(FLOW),
		.DATA_IN(DATA_IN),
		.DATA_OUT(DATA_OUT),
		.TRG_READ(TRG_READ),
		.TRG_WRITE(TRG_WRITE),
		.DONE(DONE)
	);
	
	
rs232_sim_fsm fsm(
		.CLK_50MHZ(CLK_50MHZ),
		.RST(RST),
		.RX_DONE(DONE),
		.state(state)
	);


initial begin
	FLOW = 1;
	TRG_READ = 0;
	TRG_WRITE = 0;
	send_buff = 8'b00000011;
	
	$display("%t [RS232] Initialized.", $time);
	$display("%t [RS232] Waiting before write.", $time);
	@(negedge RST) #10000;
	
	write( 8'd0 ); #10;
	write( 8'b00001110 ); #10;
	write( send_buff ); #10;
	
	/*
	repeat(3) begin
		write( send_buff );
		send_buff = send_buff <<< 1;
		#10;
	end
	*/
	
end


always @* begin
	case(state)
		IDLE: begin
			rcv_addr = 8'dx;
			rcv_data = 8'dx;
		end
		WAITING_ADDRESS: begin
			rcv_addr = DATA_OUT;
		end
		WAITING_DATA: begin
			rcv_data = DATA_OUT;
		end		
	endcase
end

always @(posedge CLK_50MHZ) begin
	if( state == DONE_STATE ) begin
			$display("%t [RS232] Received data '%b' from address '%b'", $time, rcv_data, rcv_addr);
	end
end

task write ( input [7:0] data	);
	begin
		DATA_IN = data;
		$display("%t [RS232] Writing '%b' - START.", $time, DATA_IN);	
		TRG_WRITE = 1;
		@(posedge CLK_50MHZ) #1;
		TRG_WRITE = 0;
		$display("%t [RS232] Writing '%b' - DONE.", $time, DATA_IN);
	end
endtask

endmodule
