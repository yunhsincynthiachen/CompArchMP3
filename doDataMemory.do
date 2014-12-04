vlog -reportprogress 300 -work work DataMemory.v
vsim -voptargs="+acc" test_data_memory

add wave -position insertpoint  \
sim:/test_data_memory/clk \
sim:/test_data_memory/address \
sim:/test_data_memory/dataOut \
sim:/test_data_memory/dataIn\
sim:/test_data_memory/writeEnable
run 200

wave zoom full