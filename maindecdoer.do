vcom MainDec.vhd
vsim MainDec

add wave *
force OP "000000"
run 30ns
force OP "100011"
run 30ns
force OP "101011"
run 30ns
force OP "000100"
run 30ns
force OP "001000"
run 30ns
force OP "000010"
run 30ns

wave zoom full
