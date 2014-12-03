module CPU(clk); //not yet sure about the definition, should probably include the program output
input clk;

wire sig_mem_we, sig_ir_we, sig_reg_we, sig_mem_in, sig_reg_in, sig_ALUsrcA, sig_ALUop; //single bit control sigs
wire[1:0]  sig_pc_we, sig_dst, sig_ALUsrcB, sig_pc_src; //two bit control sigs
wire[31:0] instruction;
wire[3:0] state_in, state_out;
FSM myFSM(clk, instruction, sig_pc_we, sig_mem_we, sig_ir_we, sig_reg_we, sig_mem_in, sig_dst, sig_reg_in, sig_ALUsrcA, sig_ALUsrcB, sig_ALUop, sig_pc_src, state_out, state_out);

wire [31:0] output_pc_src;
mux_pc_src 		mymux_pc_src(Da, ALU_RES_out, ALU_result, concat_out, sig_pc_src, output_pc_src);
wire pc_handler_out;
//PC_WE_handler(ALUzero_out, pc_we, handler_out);
PC_WE_handler 		myPC_WE_handler(ALUzero_out, sig_pc_we, pc_handler_out);

wire [31:0] pc_output; 
wordlatches_wren 	myprogam_counter(clk, output_pc_src, pc_output, pc_handler_out);//takes the handler_out, and gets input from PC_src

//InstructionRegister(clk,instr_in,instr_out, imm16, Rd, Rt, Rs, ir_we);
InstructionRegister 	myIR(clk, data_memory_out, instruction, imm16, Rd_IR, Rt_IR, Rs_IR, sig_ir_we);
value31(value31_out);
//mux_DST(Rd_IR, Rt_IR, value31, control_signal, output_DST); //regfile destination address mux
mux_DST 		mymux_DST(Rd_IR, Rt_IR, value31_out, sig_dst, output_DST);
wordlatches_nowren	myMDR(clk, data_memory_out, MDR_out);
TwoInputMuxes		mux_reg_in(MDR_out, ALU_RES_out, sig_reg_in, Dw);
//RegisterFile(clk, Aw, Ab, Aa, Dw, Db, Da, WrEn);
RegisterFile  		myRegisterFile(clk, output_DST, Rt_IR, Rs_IR, Dw, Db, Da, sig_reg_we);
TwoInputMuxes 		mux_data_mem_in(pc_output, ALU_RES_out, sig_mem_in, data_mem_address);//0=PC, 1=ALU_RES
//DataMemory(clk, dataOut, address, writeEnable, dataIn);
DataMemory    		myDataMemory(clk, data_memory_out, data_mem_address, sig_mem_we, Db);

//signextend(imm16_ir, signextend_out);
signextend 		mysignextend(imm16, signextend_out);
//TwoInputMuxes(wordA, wordB, sig_TwoInput, output_twoinput);
TwoInputMuxes 		mux_ALUoperandA(pc_output, Da, sig_ALUsrcA, operandA);
value4(value4_out);
//mux_ALUsrcB(signextend_out, B_out, value4, sig_ALUsrcB, output_ALUsrcB);
mux_ALUsrcB 		mux_ALUoperandB(signextend_out, Db, value4_out, sig_ALUsrcB, operandB);
//ALU(result, carryout, zero, overflow, operandA, operandB, command);
ALU 			myALU(ALU_result, carryout, ALUzero_out, overflow, operandA, operandB, sig_ALUop);

wordlatches_nowren 	myALU_RES(clk, ALU_result, ALU_RES_out);
concat 			myconcat(pc_output, instruction, concat_out);

TwoInputMuxes(wordA, wordB, sig_TwoInput, output_twoinput);
wordlatches_nowren(clk, input_word, output_word);
endmodule
