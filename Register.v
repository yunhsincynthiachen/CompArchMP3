module RegisterFile(clk, Aw, Ab, Aa, Dw, Db, Da, WrEn);
input clk, WrEn;
input[4:0] Aw, Ab, Aa;
input[31:0] Dw;
output[31:0] Da, Db;


endmodule 