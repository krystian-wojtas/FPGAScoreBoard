   //////////////////////////////////////////////////////////////////////////////////
//
// Wirtualny komponent sterownika aflanumerycznego wyœwietlacza LCD
// Sterowanie z interfejsem 8-bitowym
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


module lcd_putchar_8(input CLK_1MHZ,CLK_WR,
                   input WR_EN,RST,BF,
                   input [8:0] DATA_IN,
                   output reg LCD_E,LCD_RS,LCD_RW,
		    output [7:0] LCD_DB);

reg [4:0] s;
reg go,done,busy;
wire [7:0] LCD_DATA;
reg [3:0] s2;
reg [3:0] adr;
reg pwr_init;
reg [12:0] cnt10;
reg init,norm;
reg [8:0] FIFO [0:31];
reg [4:0] rd_cnt, wr_cnt, buf_wr_cnt;
wire [8:0] DATA_OUT;

/************** FIFO ***************/
always @(posedge CLK_WR) //(1)
if(~RST) wr_cnt<=0;
else
 if(WR_EN) wr_cnt<=wr_cnt+1;

always @(posedge CLK_WR)
 if (WR_EN) FIFO[wr_cnt]<=DATA_IN;

assign DATA_OUT=FIFO[rd_cnt];
/**********************************/

always @(posedge CLK_1MHZ) buf_wr_cnt<=wr_cnt; //(2)
always @(posedge CLK_1MHZ) //(3)
 if(~RST) s2<=0;
 else
  begin
   case (s2)
	 0: begin adr<=0; go<=1'b0; init<=1'b0; 
	           norm<=0; s2<=1; rd_cnt<=0;  end
	 1: begin init<=1'b1; if(~done) s2<=2; end
	 2: begin init<=1'b0; if(done) s2<=3; end 
	 3: begin go<=1'b1; if(~done) s2<=4; end
	 4: begin go<=1'b0; if(done) s2<=5; end
	 5: begin adr<=adr+1; s2<=6; end
	 6: begin if(LCD_DATA==8'd0) s2<=7; else s2<=3; end
	 7: begin norm<=1;
	          if(buf_wr_cnt!=rd_cnt) s2<=8;
	          else s2<=7;
	    end
	 8: begin go<=1; if(~done) s2<=9; end
	 9: begin go<=0; if(done) s2<=10; end
	 10: begin rd_cnt<=rd_cnt+1; s2<=7; end
   endcase
  end
 
function [8:0] INIT_STRING (input [3:0] ADDR); //(4)
  case (ADDR)
   4'd0: INIT_STRING=9'h03c;
   4'd1: INIT_STRING=9'h006;
   4'd2: INIT_STRING=9'h00c;
   4'd3: INIT_STRING=9'h001;
   4'd4: INIT_STRING=9'h128; // (
   4'd5: INIT_STRING=9'h143; // C
   4'd6: INIT_STRING=9'h129; // )
   4'd7: INIT_STRING=9'h120; //
   4'd8: INIT_STRING=9'h132; // 2
   4'd9: INIT_STRING=9'h130; // 0
  4'd10: INIT_STRING=9'h130; // 0
  4'd11: INIT_STRING=9'h138; // 8
  4'd12: INIT_STRING=9'h120; //
  4'd13: INIT_STRING=9'h15a; // Z
  4'd14: INIT_STRING=9'h148; // H
  4'd15: INIT_STRING=9'd0;
  default: INIT_STRING=9'h1xx;
  endcase
endfunction
  
assign {rs_a,LCD_DATA}=norm?DATA_OUT:INIT_STRING(adr); 
assign LCD_DB=pwr_init?8'h3c:LCD_DATA;

always @(posedge CLK_1MHZ) //(5)
 if(~RST) s<=0;
 else
 begin
  case (s)
    0: begin
        LCD_RS<=1'b0; LCD_E<=1'b0; LCD_RW<=1'b0;
        done<=1'b1; pwr_init<=1'b0;
	if(init) s<=1;
	else if(go) s<=16; else s<=0;		  
      end
    1: begin 
        LCD_RW<=0; LCD_RS<=0; cnt10<=10; done<=1'b0;
        pwr_init<=1'b1; s<=2; 
       end
    2: begin
        cnt10<=cnt10+1;
        if(cnt10>13'd4500) s<=3;
       end			 
    3: begin LCD_E<=1'b1; s<=4; end
    4: begin LCD_E<=1'b0; cnt10<=0; s<=5; end
    5: begin  cnt10<=cnt10+1; 
	 if(cnt10>13'd4500) s<=6;
       end			 
    6: begin LCD_E<=1'b1; s<=7; end
    7: begin LCD_E<=1'b0; cnt10<=0; s<=8; end			 
    8: begin cnt10<=cnt10+1; 
	  if(cnt10>13'd150) s<=9; 
       end			 
    9: begin LCD_E<=1'b1; s<=10; end
   10: begin LCD_E<=1'b0; cnt10<=0; s<=11; end
   11: begin done<=1'b1; s<=0; pwr_init<=1'b0; end			          		 
   16: begin LCD_RS<=rs_a; LCD_RW<=1'b0; s<=17; done<=1'b0; end			 
   17: begin LCD_E<=1'b1; s<=18; end   
   18: begin LCD_E<=1'b0; s<=19; end
   19: begin LCD_RW<=1'b1; LCD_RS<=1'b0; s<=20; end
   20: begin LCD_E<=1'b1; s<=21; end
   21: begin busy<=BF; s<=22; end
   22: begin LCD_E<=1'b0; 
         if(busy) s<=20; else s<=23;
	end
   23: begin LCD_RW<=1'b1; done<=1'b1; s<=0; end	 		
  endcase
 end
endmodule
