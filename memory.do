vlog -reportprogress 300 -work work DataMemory.v
vsim -voptargs="+acc" test_memory

add wave -position insertpoint \
sim:/test_memory/clk \
sim:/test_memory/dataOut \
sim:/test_memory/address \
sim:/test_memory/writeEnable \
sim:/test_memory/dataIn
run 500

wave zoom full