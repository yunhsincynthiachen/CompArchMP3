module irconcatPCSrcPC(clk, ir_we, pc_wren, control_signal, pc_in, instr_in, output_word);
input clk, ir_we, pc_wren;
input[1:0] control_signal;
input[31:0] instr_in, pc_in;
output[31:0] output_word;

wire[31:0] instr_out, concat_out, A_out, ALU_res, ALU, output_pc_src;
wire[15:0] imm16;
wire[4:0] Rd, Rt, Rs;

InstructionRegister ir(clk, instr_in, instr_out, imm16, Rd, Rt, Rs, ir_we);
concat conkitty(pc_in, instr_out, concat_out);
mux_pc_src pcsrc(A_out, ALU_res, ALU, concat_out, control_signal, output_pc_src);
wordlatches_wren pc(clk, output_pc_src, output_word, pc_wren);

endmodule

module test_icpp;
reg clk, ir_we, pc_wren;
reg[1:0] control_signal;
reg[31:0] instr_in, pc_in;
wire[31:0] output_word;

irconcatPCSrcPC icpp(clk, ir_we, pc_wren, control_signal, pc_in, instr_in, output_word);

initial clk=0;
always #100 clk=!clk;

initial begin
instr_in = {5'b0,5'b11111,5'b0,5'b11111,5'b0,5'b11111,2'b0};
#10
ir_we = 1'b1;
pc_wren = 1'b1;
control_signal = 2'b11;
pc_in = 32'b0;
end
endmodule 