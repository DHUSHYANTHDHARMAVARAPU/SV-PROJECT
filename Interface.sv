interface Intel8088Pins(input bit CLK, input bit  RESET);
logic [19:0] Address;
wire [7:0]  Data;

logic  MNMX = 1'b1 ;
logic  TEST = 1'b1;
logic  READY = 1'b1;
logic  NMI =1'b0;
logic  INTR =1'b0;
logic  HOLD = 1'b0;

wire logic [7:0] AD;
logic [19:8] A;
logic HLDA;  
logic IOM;
logic WR;
logic RD;
logic SSO; 
logic INTA; 
logic ALE;
logic DTR;
logic DEN; 


modport Processor(output DEN,DTR,ALE,RD,IOM,SSO,INTA,WR,A, 
		  input MNMX, TEST, CLK, RESET, READY, NMI, INTR, HOLD,HLDA,
		  inout AD );

modport Peripheral(input Address,WR, RD,ALE,CLK,RESET,IOM,
		   inout Data);


endinterface
