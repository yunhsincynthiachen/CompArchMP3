module IrRegistersALU(clk, instr_in, ir_we, ALU_out, zero, Dw, WrEn,control_signalDST,control_signalALUa,control_signalALUb,command,pc_in);
//Input goes into instruction register, each part of it goes into different places
//Things that need clk: ir, register file, wordlatches
input clk, ir_we, WrEn, command, control_signalALUa;
input[31:0] instr_in, Dw, pc_in;
input[1:0] control_signalDST, control_signalALUb;
output[31:0] ALU_out;
output zero;

wire[15:0] imm16;
wire[4:0] Rd,Rt,Rs, value31, output_DST;
wire[31:0] Db, Da, v1output, output_wordA, output_wordB, output_ALUsrcA, four_out, output_ALUsrcB, signextend_out,instr_out;
wire carryout, overflow;

InstructionRegister ir(clk,instr_in,instr_out, imm16, Rd, Rt, Rs, ir_we);
Value31 valuereg(value31);
mux_DST dst(Rd, Rt, value31, control_signalDST, output_DST);
RegisterFile regfile(clk,output_DST,Rt,Rs,Dw,Db,Da,WrEn,v1output);
wordlatches_nowren wordlatchA(clk, Da, output_wordA);
wordlatches_nowren wordlatchB(clk, Db, output_wordB);
TwoInputMuxes AlusrcA(pc_in, output_wordA, control_signalALUa, output_ALUsrcA);
Value4 valuefour(four_out);
signextend signex(imm16, signextend_out);
mux_ALUsrcB AlusrcB(signextend_out, output_wordB, four_out, control_signalALUb, output_ALUsrcB);
ALU alustuff(ALU_out, carryout, zero, overflow, output_ALUsrcA, output_ALUsrcB, command);

endmodule 

module test_IrRegistersALU;
wire[31:0] ALU_out;
wire zero;
reg[31:0] instr_in, Dw, pc_in;
reg[1:0] control_signalDST, control_signalALUb;
reg clk, ir_we, WrEn, command, control_signalALUa;

IrRegistersALU irregalutest(clk, instr_in, ir_we, ALU_out, zero, Dw, WrEn,control_signalDST,control_signalALUa,control_signalALUb,command,pc_in);

initial clk=0;
always #10 clk=!clk;    // 50MHz Clock

initial begin
instr_in={4'b1111,24'b0,4'b1111};
#10
Dw={5'b0,5'b11111,22'b0};
ir_we = 'b1;
#10
WrEn = 'b1;
#10
pc_in = {10'b0,5'b11111,17'b0};
control_signalDST = 'b00;
control_signalALUa = 'b1;
control_signalALUb = 'b01;
command = 'b0;
end
endmodule 