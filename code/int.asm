// integration test

// load_store test
lui x4, 0xbaadc
addi x4, x4, 0xeef
sb x4, 0x0(x0)
addi x3, x0, 0x8
srl x4, x4, x3
sb x4, 0x1(x0)
addi x3, x0, 0x8
srl x4, x4, x3
sb x4, 0x2(x0)
addi x3, x0, 0x8
srl x4, x4, x3
sb x4, 0x3(x0)
addi x3, x0, 0x8
srl x4, x4, x3
lw x5, 0x0(x0)