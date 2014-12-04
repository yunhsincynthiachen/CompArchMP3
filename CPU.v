module CPU(clk, instruction, state_out, v1, pc_output, stackpointer, a0, a1, v0, ALU_result, ALU_RES_out, operandA, operandB, output_DST, Dw, Rd_IR, Rt_IR, Rs_IR, sig_dst, sig_reg_in, sig_reg_we, output_pc_src, sig_pc_src, pc_handler_out, sig_ir_we, data_memory_out, data_mem_address, concat_out, at, ra, Da, Db); 
input clk;
output[31:0] instruction;
output[4:0] state_out;
output[31:0] pc_output;
output[31:0] v1, stackpointer, a0, a1, v0, ALU_result, ALU_RES_out,  operandA, operandB, Dw, output_pc_src, data_memory_out, data_mem_address, concat_out, at, ra, Da, Db;
output[4:0] Rd_IR, Rt_IR, Rs_IR, output_DST;
output[1:0] sig_dst, sig_pc_src;
output sig_reg_in, sig_reg_we, pc_handler_out, sig_ir_we;
wire sig_mem_we, sig_mem_in, sig_ALUsrcA, sig_ALUop; //single bit control sigs
wire[1:0]  sig_pc_we, sig_ALUsrcB; //two bit control sigs

wire [31:0] Dw, MDR_out, signextend_out;
wire [15:0] imm16;
wire [4:0]  value31_out;
wire [31:0]  value4_out;
wire ALUzero_out, carryout, overflow;

FSM myFSM(clk, instruction, sig_pc_we, sig_mem_we, sig_ir_we, sig_reg_we, sig_mem_in, sig_dst, sig_reg_in, sig_ALUsrcA, sig_ALUsrcB, sig_ALUop, sig_pc_src, state_out, state_out, data_memory_out);
// mux_pc_src(A_out, ALU_res, ALU, Concat_out, control_signal, output_pc_src);
mux_pc_src 		mymux_pc_src(Da, ALU_RES_out, ALU_result, concat_out, sig_pc_src, output_pc_src);
//PC_WE_handler(ALUzero_out, pc_we, handler_out);
PC_WE_handler 		myPC_WE_handler(ALUzero_out, sig_pc_we, pc_handler_out);
wordlatches_wren 	myprogam_counter(clk, output_pc_src, pc_output, pc_handler_out);//takes the handler_out, and gets input from PC_src

//InstructionRegister(clk,instr_in,instr_out, imm16, Rd, Rt, Rs, ir_we);
InstructionRegister 	myIR(clk, data_memory_out, instruction, imm16, Rd_IR, Rt_IR, Rs_IR, sig_ir_we);
Value31 		myValue31(value31_out);
//mux_DST(Rd_IR, Rt_IR, value31, control_signal, output_DST); //regfile destination address mux
mux_DST 		mymux_DST(Rd_IR, Rt_IR, value31_out, sig_dst, output_DST);
wordlatches_nowren	myMDR(clk, data_memory_out, MDR_out);
TwoInputMuxes		mux_reg_in(MDR_out, ALU_RES_out, sig_reg_in, Dw);
//RegisterFile(clk, Aw, Ab, Aa, Dw, Db, Da, WrEn);
RegisterFile  		myRegisterFile(clk, output_DST, Rt_IR, Rs_IR, Dw, Db, Da, sig_reg_we, v1, stackpointer, a0, a1, v0, at, ra); //v1 is the output, should be 58
TwoInputMuxes 		mux_data_mem_in(pc_output, ALU_RES_out, sig_mem_in, data_mem_address);//0=PC, 1=ALU_RES
//DataMemory(clk, dataOut, address, writeEnable, dataIn);
DataMemory    		myDataMemory(clk, data_memory_out, data_mem_address, sig_mem_we, Db);
wire [31:0] 		output_shiftby2;
//signextend(imm16_ir, signextend_out);
signextend 		mysignextend(imm16, signextend_out);
shiftby2 		myshiftby2(signextend_out,output_shiftby2);
//TwoInputMuxes(wordA, wordB, sig_TwoInput, output_twoinput);
TwoInputMuxes 		mux_ALUoperandA(pc_output, Da, sig_ALUsrcA, operandA);
Value4 			myValue4(value4_out);
//mux_ALUsrcB(signextend_out, B_out, value4, sig_ALUsrcB, output_ALUsrcB);
//mux_ALUsrcB 		mux_ALUoperandB(signextend_out, Db, value4_out, sig_ALUsrcB, operandB);
//mux_ALU_SrcB_shft(Value4, Db, SignExtend, Shiftby2, control_signal, output_operandB)
mux_ALU_SrcB_shft	mux_ALUoperandB(value4_out, Db, signextend_out, output_shiftby2, sig_ALUsrcB, operandB);
//ALU(result, carryout, zero, overflow, operandA, operandB, command);
ALU 			myALU(ALU_result, carryout, ALUzero_out, overflow, operandA, operandB, sig_ALUop);

wordlatches_nowren 	myALU_RES(clk, ALU_result, ALU_RES_out);
concat 			myconcat(pc_output, instruction, concat_out);
endmodule


module testCPU;
reg             clk;
wire[31:0]      instruction;
wire[4:0]       state_out;
wire[31:0] 	pc_output;
wire[31:0]	stackpointer, v0, v1, a0, a1, ALU_result, ALU_RES_out, operandA, operandB, Dw, output_pc_src, data_memory_out, data_mem_address, concat_out, at, ra, Da, Db;
wire[4:0]	output_DST,Rd_IR, Rt_IR, Rs_IR;
wire sig_reg_in, sig_reg_we, pc_handler_out, sig_ir_we;
wire[1:0] sig_dst, sig_pc_src;
CPU myCPUtest(clk, instruction, state_out, v1, pc_output, stackpointer, a0, a1, v0, ALU_result, ALU_RES_out, operandA, operandB, output_DST, Dw,Rd_IR, Rt_IR, Rs_IR,  sig_dst, sig_reg_in, sig_reg_we,  output_pc_src, sig_pc_src, pc_handler_out, sig_ir_we, data_memory_out, data_mem_address, concat_out, at, ra, Da, Db);
initial clk=0;
always #2000 clk=!clk;

initial begin
#270000
$display("270000");
#270000
$display("540000");
#100000
$display("640000");
end
endmodule 
