vlog -reportprogress 300 -work work FourInputMuxes.v 
vsim -voptargs="+acc" test_pc_src
run -all