vlog -reportprogress 300 -work work Register.v
vsim -voptargs="+acc" hw4testbenchharness

add wave -position insertpoint  \
sim:/hw4testbenchharness/Da \
sim:/hw4testbenchharness/Db \
sim:/hw4testbenchharness/Dw \
sim:/hw4testbenchharness/Aa \
sim:/hw4testbenchharness/Ab \
sim:/hw4testbenchharness/Aw \
sim:/hw4testbenchharness/WrEn \
sim:/hw4testbenchharness/clk \
sim:/hw4testbenchharness/begintest \
sim:/hw4testbenchharness/endtest \
sim:/hw4testbenchharness/dutpassed
run -all

wave zoom full