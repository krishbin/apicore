def rd(value):
    if value == "x0" or value == "zero":
        return 0
    else:
        return 1

def error(errorCode, line):
    if (errorCode == "rdzero"):
        print("ERROR: x0 cannot be destination. line[" + str(line["lineNum"]) + "] : " + line["instruction"])

# def twosComp(value):
#     ones_comp = ""
#     print(value)
#     for i in range(len(value)):
#         print(value[i])
#         if value[i] == '1':
#             ones_comp = ones_comp + '0'
#         else:
#             ones_comp = ones_comp + '1'

#     print("comp :" + bin(int(ones_comp)))
#     return ones_comp

def ufvLength(value, sign, bitCount):  #unsigned format and validate
    # validate
    if (bitCount < len(value)):
        print("Value too large to be represented in " + str(bitCount) + " bits.")
        return None

    add = ""
    for i in range(bitCount-len(str(value))):
        add = add + sign
    result = add + str(value)
    return result