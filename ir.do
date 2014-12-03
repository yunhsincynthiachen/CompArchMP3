vlog -reportprogress 300 -work work InstructionRegister.v
vsim -voptargs="+acc" test_ir

add wave -position insertpoint \
sim:/test_ir/clk \
sim:/test_ir/instr_in \
sim:/test_ir/instr_out \
sim:/test_ir/imm16 \
sim:/test_ir/Rd \
sim:/test_ir/Rt \
sim:/test_ir/Rs
run 500

wave zoom full