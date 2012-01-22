   //////////////////////////////////////////////////////////////////////////////////
//
// Wirtualny komponent odbiornika portu UART
//
// (C) 2009 Zbigniew Hajduk
// http://zh.prz-rzeszow.pl
// e-mail: zhajduk@prz-rzeszow.pl
//
// Ten kod Ÿród³owy mo¿e podlegaæ wolnej redystrybucji i/lub modyfikacjom 
// na ogólnych zasadach okreœlonych licencj¹ GNU General Public License.
//
// Autor wyra¿a nadziejê, ¿e kod wirtualnego komponentu bêdzie u¿yteczny
// jednak nie udziela ¯ADNEJ GWARANCJI dotycz¹cej jego sprawnoœci
// oraz przydatnoœci dla partykularnych zastosowañ.
//
////////////////////////////////////////////////////////////////////////////////// 


module SERIAL_RX(input CLK_RX,RST,RX,RD_ACK,
                 output [7:0] DATA,
		  output RDY);


reg [7:0] rxdata;
reg [3:0] cnt;
reg r1,r2,r3,start,rxbit,rxdone;
reg rx_sync1,rx_sync2,rx_m,rd_ack_sync1,rd_ack_sync2;
reg [3:0] bcnt;

assign DATA=rxdata;
assign RDY=rxdone;

always @(*) //(1)
 case ({r1,r2,r3})
  3'b000: rxbit=0;
  3'b001: rxbit=0;
  3'b010: rxbit=0;
  3'b011: rxbit=1;
  3'b100: rxbit=0;
  3'b101: rxbit=1;
  3'b110: rxbit=1;
  3'b111: rxbit=1;
 endcase 

always @(posedge CLK_RX) //(2)
begin 
 rx_sync1<=RX;
 rx_sync2<=rx_sync1;
 rx_m<=rx_sync2;
 rd_ack_sync1<=RD_ACK;
 rd_ack_sync2<=rd_ack_sync1;
end

always @(posedge CLK_RX)
begin
  if(~RST)
  begin
   start<=1'b0; rxdone<=1'b0; rxdata<=8'd0;
  end
  else
  begin
    if(rxdone)
     if (rd_ack_sync2) rxdone<=1'b0;

     if(rx_m&~rx_sync2&~start) //(3)
     begin start<=1'b1; cnt<=4'd15; bcnt<=4'd0; end
     if(start)
     begin
      if(cnt==5'd11)  r3<=rx_sync2; //(4)
      if(cnt==5'd8)   r2<=rx_sync2; //(5)
      if(cnt==5'd4)   r1<=rx_sync2; //(6)
      if(cnt) cnt<=cnt-1; else
	 begin
	   cnt<=4'd15;
	   rxdata<={rxbit,rxdata[7:1]}; //(7)
	   if (bcnt<8) bcnt<=bcnt+1;
	   else begin start<=1'b0; rxdone<=1'b1; end
	 end
     end
  end
end
endmodule



