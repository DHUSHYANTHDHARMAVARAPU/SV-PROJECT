module top;
bit CLK;
bit RESET;
logic cs1,cs2,cs3,cs4;

parameter mem1=20'h7FFFE;
parameter mem2= 20'h80000;
parameter mem3=20'hFFFFF;
parameter io1= 16'h1C00;
parameter io2= 16'h1DFF;
parameter io3= 16'hFF00;
parameter io4= 16'hFF0F;

Intel8088 P(bus.Processor);
Intel8088Pins bus(.CLK(CLK), .RESET(RESET));

memory  #(.active(0),.AddressWidth(20)) m1 (.sel(cs1),.bus(bus.Peripheral));
memory  #(.active(0),.AddressWidth(20)) m2 (.sel(cs2),.bus(bus.Peripheral));
memory  #(.active(1),.AddressWidth(16)) i1 (.sel(cs3),.bus(bus.Peripheral));
memory  #(.active(1),.AddressWidth(16)) i2 (.sel(cs4),.bus(bus.Peripheral));
 
assign cs1 = bus.Address[19]== 0;
assign cs2 = bus.Address[19]== 1;
//assign cs3 = Address[15]== 0;
//assign cs4 = Address[15]== 1;
always_comb
begin
if (bus.Address[15:0] >= 16'h1C00 && bus.Address[15:0] <= 16'h1DFF)
begin
cs3=1;
cs4=0;
end
else if (bus.Address[15:0] >= 16'hFF00 && bus.Address[15:0] <= 16'hFF0F)
begin
cs4=1;
cs3=0;
end
end

always_latch
begin
if (bus.ALE)
	bus.Address <= {bus.A, bus.AD};
end

// 8286 transceiver
assign bus.Data =  (bus.DTR & ~bus.DEN) ? bus.AD   : 'z;
assign bus.AD   = (~bus.DTR & ~bus.DEN) ? bus.Data : 'z;


always #50 CLK = ~CLK;

initial
begin
$dumpfile("dump.vcd"); $dumpvars;

repeat (2) @(posedge CLK);
RESET = '1;
repeat (5) @(posedge CLK);
RESET = '0;

repeat(10000) @(posedge CLK);
$finish();
end

endmodule
