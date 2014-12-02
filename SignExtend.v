module signextend(imm16_ir, signextend_out);
input[15:0] imm16_ir; 
output[31:0] signextend_out;

assign signextend_out = $signed({imm16_ir});

endmodule 

module test_signextend;
wire[31:0] signextend_out;
reg[15:0] imm16_ir;

signextend sigex(imm16_ir, signextend_out);

initial begin
$display("im | se");
imm16_ir={3'b101,13'b0}; 
#1000 
$display("%b | %b", imm16_ir, signextend_out);   
end
endmodule 