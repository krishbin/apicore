def getAddress(reg):
    if (reg == "x0" or reg == "zero"):
        return "00000"
    elif (reg == "x1" or reg == "ra"):
        return "00001"
    elif (reg == "x2" or reg == "sp"):
        return "00010"
    elif (reg == "x3" or reg == "gp"):
        return "00011"
    elif (reg == "x4" or reg == "tp"):
        return "00100"
    elif (reg == "x5" or reg == "t0"):
        return "00101"
    elif (reg == "x6" or reg == "t1"):
        return "00110"
    elif (reg == "x7" or reg == "t2"):
        return "00111"
    elif (reg == "x8" or reg == "s0" or reg == "fp"):
        return "01000"
    elif (reg == "x9" or reg == "s1"):
        return "01001"
    elif (reg == "x10" or reg == "a0"):
        return "01010"
    elif (reg == "x11" or reg == "a1"):
        return "01011"
    elif (reg == "x12" or reg == "a2"):
        return "01100"
    elif (reg == "x13" or reg == "a3"):
        return "01101"
    elif (reg == "x14" or reg == "a4"):
        return "01110"
    elif (reg == "x15" or reg == "a5"):
        return "01111"
    elif (reg == "x16" or reg == "a6"):
        return "10000"
    elif (reg == "x17" or reg == "a7"):
        return "10001"
    elif (reg == "x18" or reg == "s2"):
        return "10010"
    elif (reg == "x19" or reg == "s3"):
        return "10011"
    elif (reg == "x20" or reg == "s4"):
        return "10100"
    elif (reg == "x21" or reg == "s5"):
        return "10101"
    elif (reg == "x22" or reg == "s6"):
        return "10110"
    elif (reg == "x23" or reg == "s7"):
        return "10111"
    elif (reg == "x24" or reg == "s8"):
        return "11000"
    elif (reg == "x25" or reg == "s9"):
        return "11001"
    elif (reg == "x26" or reg == "s10"):
        return "11010"
    elif (reg == "x27" or reg == "s11"):
        return "11011"
    elif (reg == "x28" or reg == "t3"):
        return "11100"
    elif (reg == "x29" or reg == "t4"):
        return "11101"
    elif (reg == "x30" or reg == "t5"):
        return "11110"
    elif (reg == "x31" or reg == "t6"):
        return "11111"

def toHex(value):
    if value == "0000":
        return '0'
    elif value == "0001":
        return '1'
    elif value == "0010":
        return '2'
    elif value == "0011":
        return '3'
    elif value == "0100":
        return '4'
    elif value == "0101":
        return '5'
    elif value == "0110":
        return '6'
    elif value == "0111":
        return '7'
    elif value == "1000":
        return '8'
    elif value == "1001":
        return '9'
    elif value == "1010":
        return 'a'
    elif value == "1011":
        return 'b'
    elif value == "1100":
        return 'c'
    elif value == "1101":
        return 'd'
    elif value == "1110":
        return 'e'
    elif value == "1111":
        return 'f'

def toBin(value):
    if value == '0':
        return"0000"
    elif value == '1':
        return "0001"
    elif value == '2':
        return "0010"
    elif value == '3':
        return "0011"
    elif value == '4':
        return "0100"
    elif value == '5':
        return "0101"
    elif value == '6':
        return "0110"
    elif value == '7':
        return "0111"
    elif value == '8':
        return "1000"
    elif value == '9':
        return "1001"
    elif value == 'a':
        return "1010"
    elif value == 'b':
        return "1011"
    elif value == 'c':
        return "1100"
    elif value == 'd':
        return "1101"
    elif value == 'e':
        return "1110"
    elif value == 'f':
        return "1111"

def hex2bin(value):
    result = ""
    for i in range(len(value)):
        result = result + toBin(value[i])
    return result

def binary_to_hex(value):
    result = toHex(value[0:4]) + toHex(value[4:8]) + toHex(value[8:12]) + toHex(value[12:16]) + toHex(value[16:20]) + toHex(value[20:24]) + toHex(value[24:28]) + toHex(value[28:])
    return result

def twosComp(value):
    max_bin = bin(2**(len(value)))
    two_com = bin(int(max_bin, 2) - int(value, 2))
    two_com = two_com[2:]
    while (len(two_com) != len(value)):
        two_com = '0' + two_com
    return two_com

def convertTobin(immediate):
    sign = '0'
    if ('-' in immediate):
        sign = '1'
        immediate = immediate.replace('-','')

    bin_value = 0;
    if immediate[0:2] == "0x":  # hex immediate
        bin_value = hex2bin(immediate[2:])
    else: # decimal immediate
        bin_value = bin(int(immediate,10)).replace("0b",'')

    if(sign == '1'):
        bin_value = twosComp(bin_value)
    
    return bin_value