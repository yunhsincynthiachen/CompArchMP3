vlog -reportprogress 300 -work work IRConcatPCSrcPC.v InstructionRegister.v Concat.v FourInputMuxes.v WordLatches.v
vsim -voptargs="+acc" test_icpp

add wave -position insertpoint \
sim:/test_icpp/clk \
sim:/test_icpp/instr_in \
sim:/test_icpp/output_word \
sim:/test_icpp/ir_we \
sim:/test_icpp/pc_wren \
sim:/test_icpp/control_signal \
sim:/test_icpp/pc_in 
run 1000

wave zoom full