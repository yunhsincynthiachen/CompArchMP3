// 
module FSM(clk, op_code, pc_we, mem_we, ir_we, reg_we, mem_in, dst, reg_in, ALUsrcA, ALUsrcB, ALUop, pc_src );
input clk;
input [31:0]op_code;
output pc_we, mem_we, ir_we, reg_we, mem_in, reg_in, ALUsrcA, ALUop;
//how many bits dat ALUop- decode in ALU!!!!!!!!!!!!!!
output[1:0] dst, ALUsrcB, pc_src;

 

endmodule