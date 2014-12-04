// Memory Module Definition: 
// Input: DataIn, Address
// Output: DataOut

module DataMemory(clk, dataOut, address, writeEnable, dataIn);
input clk, writeEnable;
input[31:0] dataIn, address;
output[31:0] dataOut;
wire[13:0] addr;
assign addr = address[13:0];

reg[31:0] mem[16384:0];

always @(posedge clk) begin
	if(writeEnable) begin
	mem[addr/4] <= dataIn;
	end
end

initial $readmemh("f2dump.dat", mem);
assign dataOut = mem[addr/4];
endmodule 

module test_data_memory;
reg clk, writeEnable;
reg[31:0] dataIn, address;
wire[31:0] dataOut;
DataMemory mydatamemory(clk, dataOut, address, writeEnable, dataIn);

initial clk = 0;
always #10 clk=!clk;
initial begin
writeEnable = 0;
dataIn = 'b00000000000000000000000000000000;
address = 'h00000000;
#20
$display("%h %h %b", address, dataOut, dataOut);

address = 'h00000004;
#20
$display("%h %h %b", address, dataOut, dataOut);

address = 'h00000008;
#20
$display("%h %h %b", address, dataOut, dataOut);

address = 'h0000000c;
#20
$display("%h %h %b", address, dataOut, dataOut);
end
endmodule
/*

DataMemory datamemory(clk, dataOut, address, writeEnable, dataIn);

initial begin
$display("dataIn | dataOut address");
dataIn={32'b0};
writeEnable=0;
#10
dataIn={5'b11111,5'b0,5'b11111,5'b0,5'b11111,5'b0,2'b11};
writeEnable=1;
#10
dataIn={9'b1,23'b0};
writeEnable=0;
$display("%b | %b  %b", dataIn, dataOut, address);
end
endmodule 
*/