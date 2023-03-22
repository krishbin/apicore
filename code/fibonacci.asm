addi x4, x0, 0x0                // count = 0 
addi x5, x0, 0x0d               // n = 10
addi x2, x0, 0x00               // a = 0
addi x3, x0, 0x01               // b = 1

start:  sb x2, 0(x4)            // store a 
        add x1, x2, x3          // temp = a + b 
        add x2, x0, x3          // a = b
        add x3, x0, x1          // b = temp   
        addi x4, x4, 0x1        // count++
        bne x5, x4, start 

addi x0, x0, 0x0        // nop 
addi x0, x0, 0x0        // nop 
addi x0, x0, 0x0        // nop 
addi x0, x0, 0x0        // nop 

addi x4, x0, 0x0        // count = 0
print:  lbu x3, 0(x4)
        addi x4, x4, 0x1
        bne x5, x4, print
        beq x5, x4, end

addi x0, x0, 0x0 // nop

end: addi x0, x0, 0x0 // nop