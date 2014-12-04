vlog -reportprogress 300 -work work CPU.v ALU.v FourInputMuxes.v PC_WE_handler.v WordLatches.v Concat.v DataMemory.v FSM.v InstructionRegister.v Register.v SignExtend.v ThreeInputMuxes.v TwoInputMuxes.v Value4.v Value31.v
vsim -voptargs="+acc" testCPU

add wave -position insertpoint  \
sim:/testCPU/clk \
sim:/testCPU/instruction \
sim:/testCPU/state_out \
sim:/testCPU/v1
run 30000

wave zoom full