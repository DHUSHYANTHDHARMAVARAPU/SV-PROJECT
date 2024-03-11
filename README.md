module memory(CLK,ALE,IOM,RD,WR,Data,Address,RESET);
input logic CLK,ALE,IOM,RD,WR;
inout wire [7:0] Data;
input logic [19:0] Address;
input logic RESET;
parameter size=  1<<20;
reg [7:0]ram[0:size-1];
logic OE;
logic rr,WRITE;

enum logic[4:0]{
T1=5'b00001,
T2=5'b00010,
T3_R=5'b00100,
T3_W=5'b01000,
T4=5'b10000
}ps,ns;

assign Data = (OE && rr)?ram[Address]:8'bzzzzzzzz;

always @(posedge CLK)
begin
if(!WR)
ram[Address] <= Data;
end

always_ff @(posedge CLK)
begin
if(RESET)
	ps <= T1;
else
	ps <= ns;
end

always_comb
begin
ns=ps;
case(ps)
	T1:	if(ALE)
			ns=T2;
			
	T2:   begin  
		if(!RD)
			ns=T3_R;
		else if(!WR)  
			ns=T3_W;
		end
		
	T3_R:	ns=T4;
	
	T3_W:	ns=T4;
	
	T4:		ns = T1;
endcase
end

always_comb
begin
{OE,rr,WRITE}= '0;

case (ps)
	T3_R: begin
		OE='1;
		rr='1;
		//RD='1;
		end
T3_W: begin
		WRITE='1;
		//RD='1;
		end
endcase
end



initial
begin
 ram[20'h33333] = 8'b0011_1001;
//$display("ram[%0d] = %h"ram[address]);
$display("RAM[%0h] = %0h", ram[Address],Address);
end
endmoduleSYSTEM VERILOG PROJECT 
