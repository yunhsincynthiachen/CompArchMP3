// Memory Module Definition: 
// Input: DataIn, Address
// Output: DataOut

module DataMemory(clk, dataOut, address, writeEnable, dataIn);
input clk, writeEnable;
input[31:0] dataIn, address;
output[31:0] dataOut;
wire[9:0] addr;
assign addr = address[9:0];

reg[31:0] mem[1023:0];

always @(posedge clk) begin
	if(writeEnable) begin
	mem[addr] <= dataIn;
	end
end

initial $readmemh("file.dat", mem);
assign dataOut = mem[addr];
endmodule 

module test_memory;
reg clk, writeEnable;
reg[31:0] dataIn, address;
wire[31:0] dataOut;

DataMemory datamemory(clk, dataOut, address, writeEnable, dataIn);

initial clk=0;
always #10 clk=!clk;    // 50MHz Clock

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