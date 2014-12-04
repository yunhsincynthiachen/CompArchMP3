vlog -reportprogress 300 -work work FSM.v
vsim -voptargs="+acc" testFSM

add wave -position insertpoint  \
sim:/testFSM/clk \
sim:/testFSM/instruction \
sim:/testFSM/pc_we\
sim:/testFSM/mem_we\
sim:/testFSM/ir_we\
sim:/testFSM/reg_we\
sim:/testFSM/mem_in\
sim:/testFSM/dst\
sim:/testFSM/reg_in\
sim:/testFSM/ALUsrcA\
sim:/testFSM/ALUsrcB\
sim:/testFSM/ALUop\
sim:/testFSM/pc_src\
sim:/testFSM/state_out
run 50

wave zoom full