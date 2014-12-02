vlog -reportprogress 300 -work work Concat.v 
vsim -voptargs="+acc" test_concat
run -all