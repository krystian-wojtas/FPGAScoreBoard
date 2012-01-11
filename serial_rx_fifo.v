   //////////////////////////////////////////////////////////////////////////////////
//
// Wirtualny komponent odbiornika portu UART z buforem FIFO
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


module SERIAL_RX_FIFO
       #(parameter DEPTH=5)
       (input CLK_RX,RST,RX,CLK_RD,RD_EN,
        output reg DATA_RDY,
        output  [7:0] DATA);
                    
localparam N=2**DEPTH;
reg [7:0] FIFO [0:N-1];
reg [DEPTH-1:0] rd_cnt, wr_cnt,wr_cnt_sync,wr_cnt_sync1;						  
wire [7:0] rx_data;
reg rd_ack;
wire rx_rdy;
reg [1:0] st;
reg WR_EN;


SERIAL_RX uart_rx
         (.CLK_RX(CLK_RX),.RX(RX),.RD_ACK(rd_ack),
          .RST(RST),.DATA(rx_data),.RDY(rx_rdy));

always @(posedge CLK_RX)
if(~RST) wr_cnt<=0;
else
 if(WR_EN) wr_cnt<=wr_cnt+1;

always @(posedge CLK_RX)
 if (WR_EN) FIFO[wr_cnt]<=rx_data;

assign DATA=FIFO[rd_cnt];

always @(posedge CLK_RD) //(1)
if(~RST) begin rd_cnt<=0;DATA_RDY<=0; end
else
if (RD_EN) 
begin
  rd_cnt<=rd_cnt+1; DATA_RDY<=0;
end
else
begin
 if(wr_cnt_sync!=rd_cnt) DATA_RDY<=1;
  else DATA_RDY<=0;
end

always @(posedge CLK_RD) 
begin
 wr_cnt_sync1<=wr_cnt;
 wr_cnt_sync<=wr_cnt_sync1;
end
				  
always @(posedge CLK_RX) //(2)
 if(~RST) st<=0;
 else
   case (st)
    0: begin WR_EN<=0; rd_ack<=0; if(rx_rdy) st<=1; end
    1: begin WR_EN<=1; rd_ack<=1; st<=2; end
    2: begin WR_EN<=0; if(~rx_rdy) st<=0; end
   endcase
 
endmodule




