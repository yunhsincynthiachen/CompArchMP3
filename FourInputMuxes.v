module mux_pc_src(A_out, ALU_res, ALU, Concat_out, control_signal, output_pc_src);
input[31:0] A_out, ALU_res, ALU, Concat_out;
input[1:0] control_signal;
output[31:0] output_pc_src;

wire[31:0] mux[3:0];
assign mux[2] = A_out;//arguments of the mux follow the control spec
assign mux[1] = ALU_res;
assign mux[0] = ALU;
assign mux[3] = Concat_out;


assign output_pc_src = mux[control_signal]; // Connects the output of the array
endmodule 

module mux_ALU_SrcB_shft(Value4, Db, SignExtend, Shiftby2, control_signal, output_operandB);
input[31:0] Value4, Db, SignExtend, Shiftby2;
input[1:0] control_signal;
output[31:0] output_operandB;

wire[31:0] mux[3:0];
assign mux[0] = Value4;//arguments of the mux follow the control spec
assign mux[1] = Db;
assign mux[2] = SignExtend;
assign mux[3] = Shiftby2;


assign output_operandB = mux[control_signal]; // Connects the output of the array
endmodule 

module test_pc_src;
wire[31:0] output_pc_src;
reg[31:0] A_out, ALU_res, ALU, Concat_out;
reg[1:0] control_signal;

mux_pc_src pcmux(A_out, ALU_res, ALU, Concat_out, control_signal, output_pc_src);

initial begin
$display("A_out  ALU_res  ALU Concat_out  control_signal| output");
A_out= {32'b11};
ALU_res = {32'b1};
ALU = {32'b0};
Concat_out = {31'b1,1'b0};
control_signal = {2'b1};

#1000 
$display("%b  %b  %b  %b %b| %b", A_out, ALU_res, ALU, Concat_out, control_signal, output_pc_src);  
end
endmodule