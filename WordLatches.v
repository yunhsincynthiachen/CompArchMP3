module wordlatches_nowren(clk, input_word, output_word);
input clk;
input[31:0] input_word;
output reg[31:0] output_word;

always @(posedge clk) begin
	output_word = input_word;
end
endmodule 

module test_wordlatches_nowren;
wire[31:0] output_word;
reg[31:0] input_word;
reg clk;

wordlatches_nowren nowren(clk, input_word, output_word);

initial clk=0;
always #10 clk=!clk;    // 50MHz Clock

initial begin
input_word={4'b1111,28'b0};
#10
input_word={5'b11111,27'b0};
end
endmodule 

module wordlatches_wren(clk, input_word, output_word, pc_wren);
input clk;
input[31:0] input_word;
input pc_wren;
output reg[31:0] output_word = 'b00000000000000000000000000000000;

always @(posedge clk) begin
	if(pc_wren) begin 
		output_word = input_word;
	end
end
endmodule 

module test_wordlatches_wren;
wire[31:0] output_word;
reg[31:0] input_word;
reg clk, pc_wren;

wordlatches_wren wren(clk, input_word, output_word, pc_wren);

initial clk=0;
always #10 clk=!clk;    // 50MHz Clock

initial begin
input_word={32'b0};
pc_wren=0;
#10
input_word={5'b11111,27'b0};
pc_wren=1;
#10
input_word={9'b1,23'b0};
pc_wren=0;
end
endmodule 