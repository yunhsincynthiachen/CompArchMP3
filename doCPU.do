vlog -reportprogress 300 -work work CPU.v ALU.v FourInputMuxes.v PC_WE_handler.v WordLatches.v Concat.v DataMemory.v FSM.v InstructionRegister.v Register.v SignExtend.v ThreeInputMuxes.v TwoInputMuxes.v Value4.v Value31.v
vsim -voptargs="+acc" testCPU

add wave -position insertpoint  \
sim:/testCPU/clk \
sim:/testCPU/instruction \
sim:/testCPU/state_out \
sim:/testCPU/pc_output\
sim:/testCPU/sig_pc_src\
sim:/testCPU/output_pc_src\
sim:/testCPU/concat_out\
sim:/testCPU/pc_handler_out\
sim:/testCPU/data_memory_out\
sim:/testCPU/data_mem_address\
sim:/testCPU/sig_ir_we\
sim:/testCPU/stackpointer\
sim:/testCPU/at\
sim:/testCPU/a0\
sim:/testCPU/a1\
sim:/testCPU/v0\
sim:/testCPU/v1\
sim:/testCPU/ALU_result\
sim:/testCPU/ALU_RES_out\
sim:/testCPU/operandA\
sim:/testCPU/operandB\
sim:/testCPU/Dw\
sim:/testCPU/output_DST\
sim:/testCPU/Rd_IR\
sim:/testCPU/Rs_IR\
sim:/testCPU/Rt_IR\
sim:/testCPU/sig_dst\
sim:/testCPU/sig_reg_in\
sim:/testCPU/sig_reg_we

run 4000000

wave zoom full