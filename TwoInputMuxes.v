module TwoInputMuxes(wordA, wordB, control_signal, output_twoinput);
input[31:0] wordA, wordB;
input control_signal;
output[31:0] output_twoinput;

wire[31:0] mux[1:0]; // Creates a 2d Array of wires
assign mux[0] = wordA; // Connects the sources of the array
assign mux[1] = wordB;

assign output_twoinput = mux[control_signal]; // Connects the output of the array

endmodule 

module test_twoinputmuxes;
wire[31:0] Output_TwoInput;
reg[31:0] word_A, word_B;
reg Control_Signal;

TwoInputMuxes twoinput(word_A, word_B, Control_Signal, Output_TwoInput);

initial begin
$display("wordA  wordB  control_signal| output");
word_A={32'b1};
word_B={32'b0};
Control_Signal={1'b0};
#1000 
$display("%b  %b  %b| %b", word_A, word_B, Control_Signal, Output_TwoInput);  
end

endmodule 