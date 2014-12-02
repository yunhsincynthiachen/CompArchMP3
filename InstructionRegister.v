// Register Module Definition:
// Input: DataOut
// Output: Imm16, Rd, Rt, Rs
module InstructionRegister(clk,instr_in,instr_out, imm16, Rd, Rt, Rs, ir_we);
input clk, ir_we;
input[31:0] instr_in;
output[31:0] instr_out;
output[4:0] Rd, Rt, Rs;
output[15:0] imm16;


endmodule