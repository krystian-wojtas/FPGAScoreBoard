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
reg TRG_WRITE;
reg [7:0] DATA_IN;
wire [7:0] DATA_OUT;
//reg [7:0] LAST_RECEIVED;

wire [2:0] state;
reg [7:0] rcv_data;
reg [7:0] send_buff;


localparam [2:0]	IDLE 				 = 3'd0,
						WAITING_ADDRESS = 3'd1,
						WAITING_DATA 	 = 3'd2,
						DONE_STATE		 = 3'd3;
						
reg [7:0] testdata [4:0];
reg [7:0] testaddr [4:0];
	
UART u( 
		.RST(RST),
		.TX(TX),
		.RX(RX),
		.CLK_50MHZ(CLK_50MHZ),
		.DATA_IN(DATA_IN),
		.DATA_OUT(DATA_OUT),
		.TRG_WRITE(TRG_WRITE),
		.DONE(DONE)
	);
	
	
rs232_sim_fsm fsm(
		.CLK_50MHZ(CLK_50MHZ),
		.RST(RST),
		.RX_DONE(DONE),
		.state(state)
	);

integer i;

initial begin
	// *** TEST DATA ***
	testdata[0][7:0] = 8'd2;
	testdata[1][7:0] = 8'd3;
	testdata[2][7:0] = 8'd5;
	testdata[3][7:0] = 8'd7;
	testdata[4][7:0] = 8'd11;


	// *** TEST ADDR ***
	testaddr[0][7:0] = 8'd123;
	testaddr[1][7:0] = 8'd234;
	testaddr[2][7:0] = 8'd345;
	testaddr[3][7:0] = 8'd456;
	testaddr[4][7:0] = 8'd567;
	
	TRG_WRITE = 0;
	send_buff = 8'b00000011;
	
	$display("%t [RS232] Initialized.", $time);
	$display("%t [RS232] Waiting before write.", $time);
	@(negedge RST) #10;
			
	for( i=0; i<1; i=i+1 ) begin
		#100000;
		//#500000;
		$display("---------------------------------");
	   write( 0, testaddr[i], testdata[i] ); 	
	end

	for( i=0; i<1; i=i+1 ) begin
		#500000;
		//#500000; 
		$display("---------------------------------");
		write( 1, testaddr[i], 8'b11111111 ); #100;	
	end

end


always @* begin
	case(state)
		IDLE: begin
			rcv_data = 8'dx;
		end
		WAITING_DATA: begin
			rcv_data = DATA_OUT;
		end		
	endcase
end

always @(posedge CLK_50MHZ) begin
	if( state == DONE_STATE ) begin
			$display("%t [RS232] Received data '%b' (%d)", $time, rcv_data, rcv_data);
	end
end

task write ( input [7:0] flow, input [7:0] addr, input [7:0] data	);
	begin
		/*
		write( 8'd0 ); #10;
		write( 8'b00001110 ); #10;
		write( send_buff ); #10;
		*/
	
		DATA_IN = flow;			
		TRG_WRITE = 1;
		@(posedge CLK_50MHZ) #1;
		TRG_WRITE = 0; #10;
		
		DATA_IN = addr;			
		TRG_WRITE = 1;
		@(posedge CLK_50MHZ) #1;
		TRG_WRITE = 0; #10;
		
		DATA_IN = data;			
		TRG_WRITE = 1;
		@(posedge CLK_50MHZ) #1;
		TRG_WRITE = 0; #10;
		
		if( flow[0] == 0 ) $display("%t [RS232] Writing '%b'(%d) to '%b'(%d).", $time, data, data, addr, addr);
		else 			       $display("%t [RS232] Reading from '%b'(%d).", $time, addr, addr);
	end
endtask

endmodule
