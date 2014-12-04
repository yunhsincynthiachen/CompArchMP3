module RegisterFile(clk,		// Contents of first register read
		Aw,		// Contents of second register read
		Ab,		// Contents to write to register
		Aa,	// Address of first register to read 
		Dw,	// Address of second register to read
		Db,	// Address of register to write
		Da,		// Enable writing of register when High
		WrEn,		// Clock (Positive Edge Triggered)
		v1output, //value of register v1, x03
		stackpointer,
		a0,
		a1,
		v0,
		at,
		ra);
			

output[31:0]	Da;
output[31:0]	Db;
input[31:0]	Dw;
input[4:0]	Aa;
input[4:0]	Ab;
input[4:0]	Aw;
input		WrEn;
input		clk;
output[31:0]	v1output;
output[31:0] 	stackpointer;
output[31:0]	a0;
output[31:0]	a1;
output[31:0]	v0;
output[31:0]	at;
output[31:0]	ra;
wire[31:0] decoder_out;
wire[31:0] q[31:0];
assign v1output = q[3];
assign stackpointer = q[29];
assign a0	= q[4];
assign a1	= q[5];
assign v0	= q[2];
assign at	= q[1];
assign ra	= q[31];
// The decoder is instantiated, as specified by the diagram
decoder1to32 decoder(decoder_out, WrEn, Aw);


register32zero registers0(q[0], Dw, decoder_out[0], clk);

//The decoder's output is the wrenable for the registers 
generate
genvar index;
for (index = 1; index<32; index=index+1) begin
register32 registers1to31(q[index], Dw, decoder_out[index], clk);
end
endgenerate

//Muxes are the same
mux32to1by32 mux1(Da, Aa, q[0], q[1], q[2], q[3], q[4], q[5], q[6], q[7], q[8], q[9], q[10], q[11], q[12], q[13], q[14], q[15], q[16], q[17], q[18], q[19], q[20], q[21], q[22], q[23], q[24], q[25], q[26], q[27], q[28], q[29], q[30], q[31]);
mux32to1by32 mux2(Db, Ab, q[0], q[1], q[2], q[3], q[4], q[5], q[6], q[7], q[8], q[9], q[10], q[11], q[12], q[13], q[14], q[15], q[16], q[17], q[18], q[19], q[20], q[21], q[22], q[23], q[24], q[25], q[26], q[27], q[28], q[29], q[30], q[31]);


endmodule

/*
// Validates your hw4testbench by connecting it to various functional 
// or broken register files and verifying that it correctly identifies 
module hw4testbenchharness;
wire[31:0]	Da;
wire[31:0]	Db;
wire[31:0]	Dw;
wire[4:0]	Aa;
wire[4:0]	Ab;
wire[4:0]	Aw;
wire		WrEn;
wire		clk;
reg		begintest;

// The register file being tested.  DUT = Device Under Test
RegisterFile DUT(clk, Aw, Ab, Aa, Dw, Db, Da, WrEn);

// The test harness to test the DUT
hw4testbench tester(begintest, endtest, dutpassed,Da,Db,Dw, Aa, Ab,Aw,WrEn, clk);


initial begin
begintest=0;
#10;
begintest=1;
#1000;
end

always @(posedge endtest) begin
$display(dutpassed);
end

endmodule

// This is your actual test bench.
// It generates the signals to drive a registerfile and passes it back up one layer to the harness
//	((This lets us plug in various working / broken registerfiles to test
// When begintest is asserted, begin testing the register file.
// When your test is conclusive, set dutpassed as appropriate and then raise endtest.
module hw4testbench(begintest, endtest, dutpassed,
		    Da,Db,Dw, Aa, Ab,Aw,WrEn, clk);
output reg endtest;
output reg dutpassed;
input	   begintest;

input[31:0]		Da;
input[31:0]		Db;
output reg[31:0]	Dw;
output reg[4:0]		Aa;
output reg[4:0]		Ab;
output reg[4:0]		Aw;
output reg		WrEn;
output reg		clk;

initial begin
Dw=0;
Aa=0;
Ab=0;
Aw=0;
WrEn=0;
clk=0;
end

always @(posedge begintest) begin
endtest = 0;
dutpassed = 1;
#10

// Test Case 1: Write to 42 register 2, verify with Read Ports 1 and 2
// This will pass because the example register file is hardwired to always return 42. It passes with mine!
Aw = 2;
Dw = 42;
WrEn = 1;
Aa = 2;
Ab = 2;

#5 clk=1; #5 clk=0;	// Generate Clock Edge
if(Da != 42 || Db!= 42) begin
	dutpassed = 0;
	$display("Test Case 1 Failed");
	end


// Test Case 2: Write to 15 register 2, verify with Read Ports 1 and 2
// This will fail with the example register file, but should pass with yours.
Aw = 2;
Dw = 15;
WrEn = 1;
Aa = 2;
Ab = 2;
#5 clk=1; #5 clk=0;
if(Da != 15 || Db!= 15) begin
	dutpassed = 0;	// On Failure, set to false.
	$display("Test Case 2 Failed");
	end


// Test Case 3: Write Enable is broken/ignored- Register is always written to 
//Test case should pass, unless it's being written to all the time. 
Aw = 2;
Dw = 10;
WrEn = 1;
Aa = 2;
Ab = 2;
#5 clk=1; #5 clk=0;

Aw = 2;
Dw = 36;
WrEn = 0;
Aa = 2;
Ab = 2;
#5 clk=1; #5 clk=0;
if(Da == 36 || Db== 36) begin
	dutpassed = 0;	// On Failure, set to false.
	$display("Test Case 3 Failed");
	end


// Test Case 4: Decoder is broken- All registers are written to
//If I write the value 45 to register three, the line commented "hey", reading from register 2 should still have the same value 36, and not get changed. Should 
//print failed if decoder is broken. This will pass, since the decoder is not broken now. 
Aw = 2;
Dw = 36;
WrEn = 1;
Aa = 2;
Ab = 2;


#5 clk=1; #5 clk=0;

Aw = 3;//hey
Dw = 45;
WrEn = 1;
Aa = 2;
Ab = 2;

#5 clk=1; #5 clk=0;


if(Da != 36 || Db!= 36) begin
	dutpassed = 0;	// On Failure, set to false.
	$display("Test Case 4 Failed");
	end


// Test Case 5: Register Zero is actually a register instead of the constant value zero
//Must pass with normal register, fails if you can change the value of Register zero. 
Aw = 0;
Dw = 12;
WrEn = 1;
Aa = 0;
Ab = 0;
#5 clk=1; #5 clk=0;

if(Da != 0 || Db!= 0) begin
	dutpassed = 0;	// On Failure, set to false.
	$display("Test Case 5 Failed");
	end


//Test Case 6: Port 2 is broken and always reads register 17.
//Should pass with a normal register, fails if port 2 doesn't read what's assigned to it.
Aw = 17;
Dw = 29;
WrEn = 1;
Aa = 17;
Ab = 17;
#5 clk=1; #5 clk=0;

Aw = 2;
Dw = 55;
WrEn = 1;
Aa = 2;
Ab = 2;
#5 clk=1; #5 clk=0;

if(Da !=55 || Db != 55) begin
	dutpassed = 0;	// On Failure, set to false.
	$display("Test Case 6 Failed");
	end

//We're done!  Wait a moment and signal completion.
#5
endtest = 1;
end

endmodule
*/


module decoder1to32(out, enable, address);
output[31:0]	out;
input		enable;
input[4:0]	address;

assign out = enable<<address; 
endmodule

module register(q, d, wrenable, clk);
input	d;
input	wrenable;
input	clk;
output reg q;

always @(posedge clk) begin
    if(wrenable) begin
	q = d;
    end
end
endmodule

module register32(q, d, wrenable, clk);
input[31:0] d;
input wrenable;
input clk;
output reg [31:0] q;

always @(posedge clk) begin
    if(wrenable) begin
	q = d;
    end
end
endmodule


module register32zero(q, d, wrenable, clk);
input[31:0] d;
input wrenable;
input clk;
output[31:0] q;
assign q = 'b00000000000000000000000000000000;
/*
always @(posedge clk) begin
    if(wrenable) begin
	assign q = 'b00000000000000000000000000000000;
    end
end*/
endmodule


module mux32to1by1(out, address, inputs);
input[31:0] inputs;
input[4:0] address;
output out;
assign out=inputs[address];
endmodule

module mux32to1by32(out, address, input0, input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14, input15, input16, input17, input18, input19, input20, input21, input22, input23, input24, input25, input26, input27, input28, input29, input30, input31);
input[31:0] input0, input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14, input15, input16, input17, input18, input19, input20, input21, input22, input23, input24, input25, input26, input27, input28, input29, input30, input31;
input[4:0] address;
output[31:0] out;
wire[31:0] mux[31:0]; // Creates a 2d Array of wires
assign mux[0] = input0; // Connects the sources of the array
// repeat 31 times...
assign mux[1] = input1;
assign mux[2] = input2;
assign mux[3] = input3;
assign mux[4] = input4;
assign mux[5] = input5;
assign mux[6] = input6;
assign mux[7] = input7;
assign mux[8] = input8;
assign mux[9] = input9;
assign mux[10] = input10;
assign mux[11] = input11;
assign mux[12] = input12;
assign mux[13] = input13;
assign mux[14] = input14;
assign mux[15] = input15;
assign mux[16] = input16;
assign mux[17] = input17;
assign mux[18] = input18;
assign mux[19] = input19;
assign mux[20] = input20;
assign mux[21] = input21;
assign mux[22] = input22;
assign mux[23] = input23;
assign mux[24] = input24;
assign mux[25] = input25;
assign mux[26] = input26;
assign mux[27] = input27;
assign mux[28] = input28;
assign mux[29] = input29;
assign mux[30] = input30;
assign mux[31] = input31;

assign out=mux[address]; // Connects the output of the array
endmodule

