vlog -reportprogress 300 -work work SignExtend.v 
vsim -voptargs="+acc" test_signextend
run -all