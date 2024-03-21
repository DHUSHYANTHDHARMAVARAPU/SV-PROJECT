module memory #(parameter active='1,parameter LOWADDRESS = 20'h7FFFF, parameter HIGHADDRESS = 20'h80000,parameter text = 2'b00)( Intel8088Pins.Peripheral bus , input logic sel);

reg [7:0] RAM [LOWADDRESS: HIGHADDRESS];


logic OE;
logic WRITE;
logic load_address;

enum logic[4:0]{
T1=5'b00001,
T2=5'b00010,
T3_R=5'b00100,
T3_W=5'b01000,
T4=5'b10000
}ps,ns;



assign bus.Data = (OE && active && sel) ? RAM [bus.Address] : 'z;


always @(posedge bus.CLK)
begin

if (WRITE && sel)
RAM [bus.Address] <= bus.Data;

end

always_ff @(posedge bus.CLK)

begin
if(bus.RESET)
	ps <= T1;
else
	ps <= ns;
end

always_comb
begin
ns=ps;
unique0 case(ps)
	T1:	if(bus.ALE && sel)
			ns=T2;
			
	T2:   begin  
		if(!bus.RD)
			ns=T3_R;
		else if(!bus.WR)  
			ns=T3_W;
		end
		
	T3_R:	ns=T4;
	
	T3_W:	ns=T4;
	
	T4:	ns = T1;
endcase
end

always_comb
begin
{OE,WRITE,load_address}= '0;

unique0 case (ps)
	T2:	begin
		load_address='1;
		end
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
unique0 case (text)

2'b00 : $readmemh("test_mem00.txt", RAM);
2'b01 : $readmemh("test_mem800.txt", RAM);
2'b10 : $readmemh("test_1c00.txt", RAM);
2'b11 : $readmemh("test_ff00.txt", RAM);
endcase 
end
endmodule


