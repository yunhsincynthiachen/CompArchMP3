module wordlatches_nowren(clk, input_word, output_word);
input clk;
input[31:0] input_word;
output[31:0] output_word;

endmodule 

module wordlatches_wren(clk, input_word, output_word, pc_wren);
input clk;
input[31:0] input_word;
input pc_wren;
output[31:0] output_word;

endmodule 