vlog -reportprogress 300 -work work WordLatches.v
vsim -voptargs="+acc" test_wordlatches_wren

add wave -position insertpoint  \
sim:/test_wordlatches_wren/clk \
sim:/test_wordlatches_wren/input_word\
sim:/test_wordlatches_wren/output_word
run 500

wave zoom full