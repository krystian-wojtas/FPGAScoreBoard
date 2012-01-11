   //////////////////////////////////////////////////////////////////////////////////
//
// Modu³ eliminacji drgañ zestyków klawiatury
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


module debouncer(input clk,
                input [3:0] PB,
                output reg [3:0] BUTTONS);

reg [3:0] pb_sync;
reg [16:0] cnt;

always @(posedge clk)
 pb_sync<=PB;
 
wire cnt_max=&cnt;

always @(posedge clk)
if(pb_sync==BUTTONS) cnt<=0;
else
begin
 cnt<=cnt+1;
 if(cnt_max) BUTTONS<=pb_sync;
end 

endmodule
