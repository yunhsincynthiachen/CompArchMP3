vlog -reportprogress 300 -work work IrRegistersALU.v Register.v InstructionRegister.v ThreeInputMuxes.v Value4.v Value31.v WordLatches.v SignExtend.v ALU.v TwoInputMuxes.v
vsim -voptargs="+acc" test_IrRegistersALU

add wave -position insertpoint \
sim:/test_IrRegistersALU/clk \
sim:/test_IrRegistersALU/instr_in \
sim:/test_IrRegistersALU/ir_we \
sim:/test_IrRegistersALU/ALU_out \
sim:/test_IrRegistersALU/zero \
sim:/test_IrRegistersALU/Dw \
sim:/test_IrRegistersALU/pc_in 
run 1000

wave zoom full