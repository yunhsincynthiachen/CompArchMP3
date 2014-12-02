// Combines PC, IR and b00
module concat(pc_in, ir_in, concat_out);
input[31:0] pc_in;
input[31:0] ir_in;
output[31:0] concat_out; 

assign concat_out = {pc_in[31:28],ir_in[25:0],2'b0};

endmodule 

module test_concat;
wire[31:0] concat_out;
reg[31:0] pc_in, ir_in;

concat concat_stuff (pc_in, ir_in, concat_out);

initial begin
$display("pc  ir | cc");
pc_in={4'b1111,28'b0};
ir_in={6'b0,26'b11111111111111111111111111}; 
#1000 
$display("%b  %b | %b", pc_in, ir_in, concat_out);   
end
endmodule 
