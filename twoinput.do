vlog -reportprogress 300 -work work TwoInputMuxes.v 
vsim -voptargs="+acc" test_twoinputmuxes
run -all