module IrRegistersALU(clk, instr_in, ir_we, ALU_out, zero, Dw, WrEn,control_signalDST,control_signalALUa,control_signalALUb,command,pc_in,Rd,Rt,Rs,output_wordA,output_wordB,Da,Db);
//Input goes into instruction register, each part of it goes into different places
//Things that need clk: ir, register file, wordlatches
input clk, ir_we, WrEn, command, control_signalALUa;
input[31:0] instr_in, Dw, pc_in, output_wordA,output_wordB,Da,Db;
input[1:0] control_signalDST, control_signalALUb;
output[4:0] Rd, Rt, Rs;
output[31:0] ALU_out;
output zero;

wire[15:0] imm16;
wire[4:0] value31, output_DST;
wire[31:0] v1output, output_ALUsrcA, four_out, output_ALUsrcB, signextend_out,instr_out;
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
wire[31:0] ALU_out, output_wordA,output_wordB,Da,Db;
wire zero;
wire[4:0] Rd,Rt,Rs;
reg[31:0] instr_in, Dw, pc_in;
reg[1:0] control_signalDST, control_signalALUb;
reg clk, ir_we, WrEn, command, control_signalALUa;

IrRegistersALU irregalutest(clk, instr_in, ir_we, ALU_out, zero, Dw, WrEn,control_signalDST,control_signalALUa,control_signalALUb,command,pc_in,Rd,Rt,Rs,output_wordA,output_wordB,Da,Db);

initial clk=0;
always #10 clk=!clk;    // 50MHz Clock

initial begin
instr_in={4'b1101,5'b00101,7'b0100111,8'b10101010,8'b0}; //instruction going into the instruction register
pc_in = {10'b0,5'b11111,17'b0}; //pc_in value
#40
Dw={4'b1101,5'b00001,7'b0100111,8'b10101010,8'b0}; //data that is written
ir_we = 'b1;
#20
control_signalDST = 2'b01; //pulls Rt
WrEn = 'b1;
#20
Dw={4'b1101,5'b00001,7'b0100111,8'b10101010,8'b0};
ir_we = 'b1;
control_signalDST = 2'b00; //pulls Rd
WrEn = 'b1;
#20
WrEn = 'b0;
#20
control_signalALUa = 'b1; //should pull A
control_signalALUb = 2'b01; //should pull B
#20
command = 1'b0; //adds A and B, expected 10100001010011110101010000000000
#60 //gives enough delay to view in the waveform
control_signalALUa = 'b0; //PC_in comes out of muxA; B still comes out of muxB; adds PC_in and B, expected 1010000111001011010101000000000
#60 //gives enough delay to view in the waveform
control_signalALUb = 2'b00; //4 comes out of muxB; A still comes out of PC_in; adds PC_in and 4, expected 00000000001111100000000000000100
#60 //gives enough delay to view in the waveform
control_signalALUb = 2'b10; //signextend comes out of muxB
control_signalALUa = 'b1; //should pull A; adds A with signextend, expected 111010000101001110101010000000000
end
endmodule 