module memory #(parameter active='1,parameter AddressWidth=20)( Intel8088Pins.Peripheral bus , input logic sel);
//input logic sel;

reg [7:0] ram [0: 2* (1<<AddressWidth)-1];
reg [7:0] io [0: 2* (1<<AddressWidth)-1];
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


assign bus.Data = (OE && !bus.RD) ?(bus.IOM ? io [bus.Address]: ram [bus.Address]) :'z;
always @(posedge bus.CLK)
begin


if (!bus.WR && ~bus.IOM)
ram[bus.Address] <= bus.Data;
else if (!bus.WR && bus.IOM)
io[bus.Address] <= bus.Data;

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
case(ps)
	T1:	if(bus.ALE && sel && (bus.IOM==active))
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

case (ps)
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
if(ram[20'h00000]) $display("ram_2[0000]=%x",ram[20'h00000]);

$readmemh("test_mem1.txt", ram);


$readmemh("test_io.txt", io);


end
endmodule


