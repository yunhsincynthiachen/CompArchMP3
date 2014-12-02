// Memory Module Definition: 
// Input: DataIn, Address
// Output: DataOut

module DataMemory(clk, dataOut, address, writeEnable, dataIn);
input clk;
input[31:0] dataIn, address;
input writeEnable;
output [31:0] dataOut;

endmodule 