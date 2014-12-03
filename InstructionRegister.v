// Register Module Definition:
// Input: DataOut
// Output: Imm16, Rd, Rt, Rs
module InstructionRegister(clk,instr_in,instr_out, imm16, Rd, Rt, Rs, ir_we);
input clk, ir_we;
input[31:0] instr_in;
output[31:0] instr_out;
output[4:0] Rd, Rt, Rs;
output[15:0] imm16;

always @(posedge clk) begin
	if(ir_we) begin
	instr_out = instr_in;
	imm16 = instr_in[31:15]; // first 16 bits
	Rd = instr_in[14:10]; // next 5 bits
	Rt = instr_in[9:5]; // next 5 bits
	Rs = instr_in[4:0]; // next 5 bits
	end
end
endmodule

module test_ir;
wire[31:0] instr_out;
wire[4:0] Rd, Rt, Rs;
wire[15:0] imm16;
reg clk, ir_we;
reg[31:0] instr_in;

InstructionRegister ir(clk,instr_in,instr_out, imm16, Rd, Rt, Rs, ir_we);

initial begin
$display("instr_in | instr_out  Rd  Rt  Rs  imm16");
ir_we={};
instr_in={};
#1000
$display("%b | %b  %b  %b  %b  %b", instr_in, instr_out, Rd, Rt, Rs, imm16);
end
endmodule 