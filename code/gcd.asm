addi x7, x0, 13
addi x8, x0, 17

// gcd calculation
gcd:    sub x6, x7, x8      // x7 - x8
        beq x6, x0, found   
        blt x6, x0, swap    // swap if x6 is less than or equal to zero
        proceed:    sub x6, x7, x8      //
                    add x7, x0, x6
        jal x1, gcd

swap:   add x9, x0, x8
        add x8, x0, x7
        add x7, x0, x9
        jal x1, proceed

found:  add x9, x0, x7
        addi x0, x0, 0x00