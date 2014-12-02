module mux_ALUsrcB(signextend_out, B_out, value4, control_signal, output_ALUsrcB);
input[31:0] B_out, value4, signextend_out;
input[1:0] control_signal;
output[31:0] output_ALUsrcB;

wire[31:0] mux[2:0]; // Creates a 2d Array of wires
assign mux[0] = B_out; // Connects the sources of the array
assign mux[1] = signextend_out;
assign mux[2] = value4;

assign output_ALUsrcB = mux[control_signal]; // Connects the output of the array
endmodule 

module test_ALUsrcB;
wire[31:0] output_ALUsrcB;
reg[31:0] signextend_out, B_out, value4;
reg[1:0] Control_Signal;

mux_ALUsrcB alusrcb(signextend_out, B_out, value4, Control_Signal, output_ALUsrcB);

initial begin
$display("B_out  signextend_out, value4  control_signal| output");
signextend_out={32'b1};
B_out={32'b0};
value4={1'b1,31'b0};
Control_Signal={2'b0};
#1000 
$display("%b  %b  %b  %b| %b", B_out, signextend_out, value4, Control_Signal, output_ALUsrcB);  
end
endmodule



module mux_DST(Rd_IR, Rt_IR, value31, control_signal, output_DST);
input[4:0] Rd_IR, Rt_IR, value31;
input[1:0] control_signal;
output[4:0] output_DST;

endmodule 