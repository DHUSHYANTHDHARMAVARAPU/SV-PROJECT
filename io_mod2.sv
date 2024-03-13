module io_2(CLK,ALE,IOM,RD,WR,Data,Address,RESET);
input logic CLK,ALE,IOM,RD,WR;
inout wire [7:0] Data;
input logic [15:0] Address;
input logic RESET;
reg [7:0]io [16'hFF00:16'hFF0F];
logic OE;
logic WRITE;

enum logic[4:0]{
T1=5'b00001,
T2=5'b00010,
T3_R=5'b00100,
T3_W=5'b01000,
T4=5'b10000
}ps,ns;

assign Data = (OE && !RD)?io[Address]:8'bzzzzzzzz;
assign cs=Address[15];
always @(posedge CLK)
begin
if(!WR)
io[Address] <= Data;
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
	T1:	if(ALE && cs && IOM)
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
{OE,WRITE}= '0;

case (ps)
	T3_R: begin
		OE='1;
		end
T3_W: begin
		WRITE='1;
		
		end
endcase
end



initial
begin
 $readmemh("test.txt",io);
end
endmodule