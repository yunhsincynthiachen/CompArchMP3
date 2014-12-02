module PC_WE_handler(ALUzero_out, pc_we, handler_out);
input[31:0] ALUzero_out;
input[1:0] pc_we;
output handler_out;

//behavior:
//pc_we = 1, handler_out = 1
//pc_we = 0, out = 0
//pc_we = 2 & ALUzero_out = 1; out = 1
//pc_we = 2 & ALUzero_out = 0; out = 0
wire res_bit;
assign res_bit = ALUzero_out[0];
assign handler_out = (pc_we||((pc_we==2)&&(res_bit)));

endmodule  


module test_handler;
wire handler_out;
reg[31:0] ALUZero;
reg[1:0] pc_we;

PC_WE_handler testmod(ALUZero, pc_we, handler_out);

initial begin
$display("ALUZero  pc_we | handler_out");
ALUZero = 'b00000000000000000000000000000000;
pc_we = 1;
#5
$display("%b  %b | %b", ALUZero, pc_we, handler_out);   
ALUZero = 'b00000000000000000000000000000000;
pc_we = 0;
#5
$display("%b  %b | %b", ALUZero, pc_we, handler_out);   
ALUZero = 'b00000000000000000000000000000001;
pc_we = 2;
#5
$display("%b  %b | %b", ALUZero, pc_we, handler_out);   
ALUZero = 'b00000000000000000000000000000000;
pc_we = 2;
#5
$display("%b  %b | %b", ALUZero, pc_we, handler_out);   
ALUZero = 'b00000000000000000000000000000001;
pc_we = 0;
#5
$display("%b  %b | %b", ALUZero, pc_we, handler_out);   
ALUZero = 'b00000000000000000000000000000001;
pc_we = 1;
#5
$display("%b  %b | %b", ALUZero, pc_we, handler_out);   

end
endmodule 