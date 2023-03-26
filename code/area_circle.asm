addi x1, x0, 3  // pi = 3(let) -> floating point not implemented
addi x2, x0, 5  // x0 = r

area:   mul x3, x2, x2    // x3 = rSquare = r * r
        mul x4, x1, x3    // x4 = area = pi * rSquare

store:  sw x4, 0x20(x0)