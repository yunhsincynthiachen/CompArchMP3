vlog -reportprogress 300 -work work ALU.v 
vsim -voptargs="+acc" testALU
run -all