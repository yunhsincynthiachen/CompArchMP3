vlog -reportprogress 300 -work work shiftby2.v 
vsim -voptargs="+acc" test_shiftby2
run -all