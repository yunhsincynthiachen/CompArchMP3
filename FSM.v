// 
module FSM(clk, op_code, pc_we, mem_we, ir_we, reg_we, mem_in, dst, reg_in, ALUsrcA, ALUsrcB, ALUop, pc_src );
input clk;
input [31:0]op_code;
output pc_we, mem_we, ir_we, reg_we, mem_in, reg_in, ALUsrcA, ALUop;
//how many bits dat ALUop- decode in ALU!!!!!!!!!!!!!!
output[1:0] dst, ALUsrcB, pc_src;

reg[2:0] state   = 'b000;
reg[3:0] counter = 'b0000;

parameter state_GETTING_ADDRESS		= 0;
parameter state_GOT_ADDRESS		= 1;
parameter state_READ			= 2;
parameter state_READ_2			= 3;
parameter state_READ_3			= 4;
parameter state_WRITE			= 5;
parameter state_WRITE_2			= 6;
parameter state_DONE			= 7;

always @(posedge clk) begin
	Address_LatchEnable <= 0;
	writeEnableData <= 0;
	MISO_buffer_EN <= 0;
	parallelLoad <= 0; //shift reg WRENable
	if (cs_conditioned == 1) begin //takes care of the reset case 
	state <= state_GETTING_ADDRESS;
	counter <= 0;
	end

	case(state)
//		state_GETTING_ADDRESS: begin 
		0: begin 
		if (counter == 8) begin
		$display("state GET: @7, continue");
			state <= state_GOT_ADDRESS;
		end
		else begin
			state <= state_GETTING_ADDRESS;
			if (peripheralClkEdge == 1) begin 
			$display("state GET: Increment Counter");
			counter <= counter +1;
			end
		end
		end

		state_GOT_ADDRESS: begin 
		$display("state GOT");
		counter <= 0;
		Address_LatchEnable <= 1;
		if (parallelDataOut[0] == 1) begin //the LSB of the parallelDataOut is the Read/Write flag
			state <= state_READ;
		end
		if (parallelDataOut[0] == 0) begin
			state <= state_WRITE;
		end
		end

		state_READ: begin 
		$display("state READ");
		state <= state_READ_2;
		end

		state_READ_2: begin 
		$display("state READ_2");
		state <= state_READ_3;
		parallelLoad <= 1;
		end

		state_READ_3: begin 
		MISO_buffer_EN <= 1;
		if (counter == 8) begin
			$display("state READ_3: Got to 7");
			state <= state_DONE;
		end
		else begin
			state <= state_READ_3;
			if (peripheralClkEdge == 1) begin 
			$display("state READ_3: Increment Counter");
			counter <= counter +1;
			end
		end
		end

		state_WRITE: begin 
		if (counter == 8) begin

		$display("state WRITE: Got to 7");
			state <= state_WRITE_2;
		end
		else begin
			state <= state_WRITE;
			if (peripheralClkEdge == 1) begin 
			$display("state WRITE: Increment Counter");
			counter <= counter +1;
			end
		end
		end

		state_WRITE_2: begin 
		$display("state WRITE_2");
		state <= state_DONE;
		writeEnableData <= 1;
		$display(parallelDataOut);
		end

		state_DONE: begin 
		$display("state DONE");
		state <= state_GETTING_ADDRESS;
		counter <= 0;
		end

		default: begin 
		$display("Error: default case within FSM");
		end
	endcase
end

 

endmodule