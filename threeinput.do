vlog -reportprogress 300 -work work ThreeInputMuxes.v 
vsim -voptargs="+acc" test_ALUsrcB
run -all