vcom ALUDec.vhd
vsim ALUDec

add wave *

force ALUOp "00"
force Funct "100000"
run 30ns
force ALUOp "00"
force Funct "100010"
run 30ns
force ALUOp "00"
force Funct "100100"
run 30ns
force ALUOp "00"
force Funct "100101"
run 30ns
force ALUOp "00"
force Funct "101010"
run 30ns

force ALUOp "01"
force Funct "100000"
run 30ns
force ALUOp "01"
force Funct "100010"
run 30ns
force ALUOp "01"
force Funct "100100"
run 30ns
force ALUOp "01"
force Funct "100101"
run 30ns
force ALUOp "01"
force Funct "101010"
run 30ns

force ALUOp "10"
force Funct "100000"
run 30ns
force ALUOp "10"
force Funct "100010"
run 30ns
force ALUOp "10"
force Funct "100100"
run 30ns
force ALUOp "10"
force Funct "100101"
run 30ns
force ALUOp "10"
force Funct "101010"
run 30ns

wave zoom full
