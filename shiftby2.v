module shiftby2(input_shiftby2,output_shiftby2);
input[31:0] input_shiftby2;
output[31:0] output_shiftby2;

assign output_shiftby2 = {input_shiftby2[29:0],2'b00};

endmodule 

module test_shiftby2;
reg[31:0] input_shiftby2;
wire[31:0] output_shiftby2;

shiftby2 shift2(input_shiftby2,output_shiftby2);

initial begin
$display("in | out");
input_shiftby2 = {5'b11111,10'b0,6'b110101,11'b0};
#1000
$display("%b | %b",input_shiftby2,output_shiftby2);
end
endmodule 