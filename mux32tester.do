vcom mux32.vhd
vsim mux32

add wave *
force Selecter "0"
force InputOne "10101010101010101010101010101010"
force InputTwo "11111111111111110000000000000000"

run 30ns

force Selecter "1"
force InputOne "10101010101010101010101010101010"
force InputTwo "11111111111111110000000000000000"
run 30ns

wave zoom full
