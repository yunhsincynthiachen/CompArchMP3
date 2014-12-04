module IrRegistersALU(clk, instr_in, ir_we, ALU_out, zero, Dw, WrEn,control_signal,control_signal2,control_signal3,command);
//Input goes into instruction register, each part of it goes into different places
//Things that need clk: ir, register file, wordlatches
input clk, ir_we, WrEn, command, control_signal2;
input[31:0] instr_in, Dw;
input[1:0] control_signal, control_signal3;
output[31:0] ALU_out;
output zero;

wire[15:0] imm16;
wire[4:0] Rd,Rt,Rs, value31, output_DST;
wire[31:0] Db, Da, v1output, output_wordA, output_wordB, output_ALUsrcA, four_out, output_ALUsrcB;
wire carryout, overflow;

InstructionRegister ir(clk,instr_in,instr_out, imm16, Rd, Rt, Rs, ir_we);
Value31 valuereg(value31);
mux_DST dst(Rd, Rt, value31, control_signal, output_DST);
RegisterFile regfile(clk,output_DST,Rt,Rs,Dw,Db,Da,WrEn,v1output);
wordlatches_nowren wordlatchA(clk, Da, output_wordA);
wordlatches_nowren wordlatchB(clk, Db, output_wordB)
TwoInputMuxes AlusrcA(pc_in, output_wordA, control_signal2, output_ALUsrcA);
Value4 valuefour(four_out);
mux_ALUsrcB AlusrcB(imm16, output_wordB, four_out, control_signal3, output_ALUsrcB);
ALU alustuff(ALU_out, carryout, zero, overflow, output_ALUsrcA, output_ALUsrcB, command);

endmodule 

module test_IrRegistersALU;
wire[31:0] ALU_out;
wire zero;
reg[31:0] instr_in, Dw;

endmodule 