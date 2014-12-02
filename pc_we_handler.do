vlog -reportprogress 300 -work work PC_WE_handler.v 
vsim -voptargs="+acc" test_handler
run -all