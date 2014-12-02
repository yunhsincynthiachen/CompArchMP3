module CPU(clk); //not yet sure about the definition

FSM(clk, instruction, pc_we, mem_we, ir_we, reg_we, mem_in, dst, reg_in, ALUsrcA, ALUsrcB, ALUop, pc_src, state_in, state_out);
InstructionRegister(clk,instr_in,instr_out, imm16, Rd, Rt, Rs, ir_we);
RegisterFile(clk, Aw, Ab, Aa, Dw, Db, Da, WrEn);
DataMemory(clk, dataOut, address, writeEnable, dataIn);
ALU(result, carryout, zero, overflow, operandA, operandB, command);
mux_pc_src(A_out, ALU_res, ALU, Concat_out, control_signal, output_pc_src);
PC_WE_handler(ALUzero_out, pc_we, handler_out);
signextend(imm16_ir, signextend_out);
concat(pc_in, ir_in, concat_out);
value4(four_out);
value31(register_out);
mux_ALUsrcB(signextend_out, B_out, value4, control_signal, output_ALUsrcB);
TwoInputMuxes(wordA, wordB, control_signal, output_twoinput);
wordlatches_nowren(clk, input_word, output_word);







endmodule
