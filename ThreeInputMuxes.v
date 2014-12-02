module mux_ALUsrcB(signextend_out, B_out, value4, control_signal, output_ALUsrcB);
input[31:0] B_out, value4;
input[15:0] signextend_out;
input[1:0] control_signal;
output[31:0] output_ALUsrcB;

endmodule 

module mux_DST(Rd_IR, Rt_IR, value31, control_signal, output_DST);
input[4:0] Rd_IR, Rt_IR, value31;
input[1:0] control_signal;
output[4:0] output_DST;

endmodule 