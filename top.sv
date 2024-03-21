module top;
bit CLK;
bit RESET;
logic cs1,cs2,cs3,cs4;


Intel8088 P(bus.Processor);
Intel8088Pins bus(.CLK(CLK), .RESET(RESET));

memory  #(.ENABLE(1),.LOWADDRESS(20'h00000),.HIGHADDRESS(20'h7FFFF),.text(2'b00)) m1 (.sel(cs1),.bus(bus.Peripheral));
memory  #(.ENABLE(1),.LOWADDRESS(20'h80000),.HIGHADDRESS(20'hFFFFF),.text(2'b01)) m2 (.sel(cs2),.bus(bus.Peripheral));
memory  #(.ENABLE(1),.LOWADDRESS(16'h1C00),.HIGHADDRESS(16'h1DFF),.text(2'b10)) i1 (.sel(cs3),.bus(bus.Peripheral));
memory  #(.ENABLE(1),.LOWADDRESS(16'hFF00),.HIGHADDRESS(16'hFF0F),.text(2'b11))  i2 (.sel(cs4),.bus(bus.Peripheral));
 
assign cs1 = bus.Address[19]=== 1'b0 && ~bus.IOM;
assign cs2 = bus.Address[19]=== 1'b1 && ~bus.IOM;
assign cs3 = bus.Address[15]=== 1'b0 && bus.IOM;
assign cs4 = bus.Address[15]=== 1'b1 && bus.IOM;

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
