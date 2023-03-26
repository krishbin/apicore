// load data to ROM
// RAM 0x20[10] = {f4,16,78,b1,16,e7,53,1f,c5,15}
addi x1, x0, 0x20   // start address
lui  x4,     0xb1781
addi x4, x4, 0x6f4
sw   x4,     0x00(x1)
lui  x4,     0x1f53e
addi x4, x4, 0x716
sw   x4,     0x04(x1)
addi x2, x0, 12 // bit shift required
lui  x4,     0x15c5
srl  x4, x4, x2
sh   x4,     0x08(x1)

addi x8, x0, 9 // x8 = i = 9

main_loop:  add x2, x0, x8 // x2 = j = i
        addi x3, x0, 0x20

        i_loop:  addi x4, x3, 0x01
                lbu x5, 0x00(x3)
                lbu x6, 0x00(x4)
                bltu x5, x6, next // if x5 < x6, next
                sb x5, 0x00(x4)
                sb x6, 0x00(x3)
        next:   addi x2, x2, -0x01
                beq x2, x0, o_loop
                addi x3, x3, 0x01
                jal x1, i_loop

    o_loop: addi x8, x8, -0x01
            beq x8, x0, end
            jal x1, main_loop

end:    addi x0, x0, 0x00