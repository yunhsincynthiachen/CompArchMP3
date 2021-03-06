module FSM(clk, instruction, pc_we, mem_we, ir_we, reg_we, mem_in, dst, reg_in, ALUsrcA, ALUsrcB, ALUop, pc_src, state_in, state_out, data_memory_out);
input clk;
input[31:0] instruction, data_memory_out;//proposal: FSM has access to data_memory_out to decide during ID_undiff
input[4:0] state_in; //feedback from the FSM itself for progression
output reg[4:0] state_out = 'b10000; //the next state (phase), which will be read in on the next cycle
//output reg mem_we, ir_we, reg_we, mem_in, reg_in, ALUsrcA, ALUop;
//there are 11 control signals out
//How many bits in the ALUopcode? Should only be 1 for ADD/SUB, but not extensible
//output reg[1:0]  pc_we, dst, ALUsrcB, pc_src;

wire[5:0] opcode;
wire[5:0] opcode_secondary;
assign opcode = instruction[31:26]; //the leading 6 bits compose the opcode
assign opcode_secondary = data_memory_out[31:26];
wire[4:0] funct4;
wire[4:0] funct4_secondary;
assign funct4 = instruction[3:0]; //the final four bits differentiate between ADD and JR
assign funct4_secondary = data_memory_out[3:0];
reg[4:0] state   = 'b10000;//start in the BOOT_STATE
//assign state_out = state;

//initialize to instrfetch signals
output reg mem_we = 0;
output reg ir_we = 0;
output reg reg_we = 0;
output reg mem_in = 0;
output reg reg_in = 0;
output reg ALUsrcA = 0;
output reg ALUop = 0;
output reg[1:0] pc_we = 0;
output reg[1:0] dst = 0;
output reg[1:0] ALUsrcB = 0;
output reg[1:0] pc_src = 0;

parameter state_IF			= 0;
parameter state_ID_JAL			= 1;
parameter state_ID_JR			= 2;
parameter state_ID_BEQ			= 3;
parameter state_ID_SW_LW_ADD_ADDI	= 4;
parameter state_ID_undifferentiated 	= 17;
parameter state_EX_JAL			= 5;
parameter state_EX_BEQ			= 6;
parameter state_EX_SW_LW		= 7;
parameter state_EX_ADD			= 8;
parameter state_EX_ADDI			= 9;
parameter state_MEM_SW			= 10;
parameter state_MEM_LW			= 11;
parameter state_WB_JAL			= 12;
parameter state_WB_ADD			= 13;
parameter state_WB_ADDI			= 14;
parameter state_WB_LW			= 15;
parameter BOOT_STATE			= 16;

//opcodes and funct4s
parameter opcode_ADD			= 'b000000; //also for ADDU
parameter opcode_ADDI			= 'b001000;
parameter opcode_ADDIU			= 'b001001; 
parameter opcode_JR 			= 'b000000;
parameter opcode_JAL			= 'b000011;
parameter opcode_BEQ 			= 'b000100;
parameter opcode_SW 			= 'b101011;
parameter opcode_LW 			= 'b100011;

parameter funct4_ADD			= 'b0000;
parameter funct4_JR 			= 'b1000;

always @(posedge clk) begin
// pc_we, mem_we, ir_we, reg_we, mem_in, dst, reg_in, ALUsrcA, ALUsrcB, ALUop, pc_src
	pc_we <=0;
	mem_we <=0;
	ir_we <=0;
	reg_we <=0;
	mem_in <=0;
	dst <=0;
	reg_in <= 0;
	ALUsrcA <= 0;
	ALUsrcB <= 0;
	ALUop <=0;
	pc_src <=0;
	state = state_in;// needs to be a blocking assignment so that the case statement uses the new state
	
	case(state)
//		state_IF: begin 
		0: begin
		$display("state IF");
		pc_we <= 1;
		ir_we <= 1;
		state_out <= state_ID_undifferentiated;
/*
		if (((opcode == opcode_ADD) && (funct4 == funct4_ADD))||(opcode == opcode_SW)||(opcode == opcode_LW)||(opcode == opcode_ADDI)||(opcode == opcode_ADDIU)) begin
			state_out <= state_ID_SW_LW_ADD_ADDI;
		end
		if (opcode == opcode_BEQ) begin
			state_out <= state_ID_BEQ;		
		end
		if (opcode == opcode_JAL) begin
			state_out <= state_ID_JAL;
		end
		if ((opcode == opcode_JR)&&(funct4 == funct4_JR)) begin
			state_out <= state_ID_JR;
		end*/
		end


		state_ID_undifferentiated: begin
		$display("data_memory_out %h", data_memory_out);
		$display("opcode_secondary %b", opcode_secondary);
		$display("funct4_secondary %b", funct4_secondary);
		if ((opcode_secondary == opcode_ADD) && (funct4_secondary == funct4_ADD)) begin //emits no control signals
			$display("state_ID_SW_LW_ADD_ADDI");
			state_out <= state_EX_ADD;
		end
		if ((opcode_secondary == opcode_ADDI)||(opcode_secondary == opcode_ADDIU)) begin
			$display("state_ID_SW_LW_ADD_ADDI");
			state_out <= state_EX_ADDI;
		end
		if ((opcode_secondary == opcode_SW)||(opcode_secondary == opcode_LW)) begin
			$display("state_ID_SW_LW_ADD_ADDI");
			state_out <= state_EX_SW_LW;
		end
		if (opcode_secondary == opcode_JAL) begin
			$display("state_ID_JAL");
			pc_we <= 1;
			reg_we <=1;
			dst <= 2;
			reg_in <= 1;
			pc_src <= 3;
//			state_out <= state_EX_JAL;
			state_out <= state_IF;
		end
		if ((opcode_secondary == opcode_JR)&&(funct4_secondary == funct4_JR)) begin
			$display("state_ID_JR");
			pc_we <= 1;
			pc_src <= 2;
			state_out <= state_IF;
		end
		if (opcode_secondary == opcode_BEQ) begin
			$display("state_ID_BEQ");
			ALUsrcB <= 3;
			state_out <= state_EX_BEQ;
		end
		end

		state_ID_SW_LW_ADD_ADDI: begin
		$display("state_ID_SW_LW_ADD_ADDI");
		$display("instruction %h %b", instruction, instruction);
		//no control signals emitted 
		if (opcode == opcode_ADD) begin
			state_out <= state_EX_ADD;
		end
		if ((opcode == opcode_ADDI)||(opcode == opcode_ADDIU)) begin
			state_out <= state_EX_ADDI;
		end
		if ((opcode == opcode_SW)||(opcode == opcode_LW)) begin
			state_out <= state_EX_SW_LW;
		end
		end

		state_ID_JAL: begin
		$display("state_ID_JAL");
		pc_we <= 1;
		pc_src <= 3;
		state_out <= state_EX_JAL;
		end
		
		state_ID_JR: begin
		$display("state_ID_JR");
		pc_we <= 1;
		pc_src <= 2;
		state_out <= state_IF;
		end
		
		state_ID_BEQ: begin
		$display("state_ID_BEQ");
		ALUsrcB <= 2;
		state_out <= state_EX_BEQ;
		end

		state_EX_JAL: begin
		$display("state_EX_JAL");
		//no control signals emitted (all of value zero)
		state_out <= state_WB_JAL;
		end
		
		state_EX_BEQ: begin
		$display("state_EX_BEQ");
		pc_we <= 2;
		ALUsrcA <= 1;
		ALUsrcB <= 1;
		ALUop <= 1;
		pc_src <= 1;
		state_out <= state_IF;
		end

		state_EX_SW_LW: begin
		$display("state_EX_SW_LW");
		ALUsrcA <= 1;
		ALUsrcB <= 2;
		if (opcode == opcode_SW) begin
			state_out <= state_MEM_SW;
		end
		if (opcode == opcode_LW) begin
			state_out <= state_MEM_LW;
		end
		end

		state_EX_ADD: begin
		$display("state_EX_ADD");
		ALUsrcA <= 1;
		ALUsrcB <= 1;
		state_out <= state_WB_ADD;
		end
		
		state_EX_ADDI: begin	
		$display("state_EX_ADDI");
		ALUsrcA <= 1;
		ALUsrcB <= 2;
		state_out <= state_WB_ADDI;
		end
		
		state_MEM_SW: begin
		$display("state_MEM_SW");
		mem_we <= 1;
		mem_in <= 1;
		state_out <= state_IF;
		end

		state_MEM_LW: begin
		$display("state_MEM_LW");
		mem_in <= 1;
		state_out <= state_WB_LW;
		end

		state_WB_JAL: begin
		$display("state_WB_JAL");
		reg_we <= 1;
		dst <= 2;
		reg_in <= 1;
		state_out <= state_IF;
		end

		state_WB_ADD: begin
		$display("state_WB_ADD");
		reg_we <= 1;
		reg_in <= 1;
		state_out <= state_IF;
		end

		state_WB_ADDI: begin
		$display("state_WB_ADDI"); //could have been simplified with previous
		reg_we <= 1;
		reg_in <= 1;
		dst <= 1;
		state_out <= state_IF;
		end

		state_WB_LW: begin
		$display("state_WB_LW");
		reg_we <= 1;
		dst <= 1;
		state_out <= state_IF;
		end

		BOOT_STATE: begin
		$display("BOOT_STATE");
		ir_we <= 1;
		if (instruction == 'b00100100000111010011111111111100) begin //start when the instruction is an ADDI for the initial setting of the stack pointer
			state_out <= state_IF;
		end
		end

		default: begin 
		$display("Error: default case within FSM");
		end
	endcase
end

endmodule

module testFSM;
reg clk;
reg[31:0] instruction;
wire mem_we, ir_we, reg_we, mem_in, reg_in, ALUsrcA, ALUop;
wire[1:0] ALUsrcB, pc_src, dst, pc_we;
wire[3:0] state_in, state_out;
//reg state_in;
//initial state_in = 'b0000;
initial clk=0;
always #2 clk=!clk;

FSM myFSMtest(clk, instruction, pc_we, mem_we, ir_we, reg_we, mem_in, dst, reg_in, ALUsrcA, ALUsrcB, ALUop, pc_src, state_out, state_out);
initial clk=0;
initial instruction = 'b00100100000001010000000000000000;
initial begin
#100
clk = 1;

end
endmodule 