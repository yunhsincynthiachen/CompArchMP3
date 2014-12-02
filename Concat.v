// Combines PC, IR and b00
module concat(pc_in, ir_in, concat_out);
input[31:0] pc_in;
input[31:0] ir_in;
output[31:0] concat_out; 

//concat_out = {pc_in,ir_in,'b00};

endmodule 