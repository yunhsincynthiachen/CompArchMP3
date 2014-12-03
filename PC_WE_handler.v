module PC_WE_handler(ALUzero_out, pc_we, handler_out);
input ALUzero_out;
input[1:0] pc_we;
output handler_out;

//behavior:
//pc_we = 1, handler_out = 1
//pc_we = 0, out = 0
//pc_we = 2 & ALUzero_out = 1; out = 1
//pc_we = 2 & ALUzero_out = 0; out = 0
wire res_bit;
assign res_bit = ALUzero_out;
assign handler_out = ((pc_we==1)||((pc_we==2)&&(res_bit)));

endmodule  


module test_handler;
wire handler_out;
reg ALUZero;
reg[1:0] pc_we;

PC_WE_handler testmod(ALUZero, pc_we, handler_out);

initial begin
$display("ALUZero  pc_we | handler_out");
ALUZero = 'b0;
pc_we = 1;
#5
$display("%b  %b | %b", ALUZero, pc_we, handler_out);   
ALUZero = 'b0;
pc_we = 0;
#5
$display("%b  %b | %b", ALUZero, pc_we, handler_out);   
ALUZero = 'b1;
pc_we = 2;
#5
$display("%b  %b | %b", ALUZero, pc_we, handler_out);   
ALUZero = 'b0;
pc_we = 2;
#5
$display("%b  %b | %b", ALUZero, pc_we, handler_out);   
ALUZero = 'b1;
pc_we = 0;
#5
$display("%b  %b | %b", ALUZero, pc_we, handler_out);   
ALUZero = 'b1;
pc_we = 1;
#5
$display("%b  %b | %b", ALUZero, pc_we, handler_out);   

end
endmodule 