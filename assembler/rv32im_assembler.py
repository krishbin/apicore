import sys
import ISAC as isac
import validator as val
import functions as fn

comment_string = "//"

output_file_location = "../bin/program.mem"

# validate input command
n = len(sys.argv)
if (n != 2):
    print("Command requires asm source file. \n\t\t$ python3 rv32im_assembler.py code.asm")
    sys.exit()

# open file
try:
    asm_source = open(sys.argv[1], 'r')
except FileNotFoundError:
    print("\nFile not found. Wrong file or filepath.\n")
    sys.exit(0)

# begin parsing
lines_raw = [line for line in asm_source]
line_number = [num+1 for num in range(len(lines_raw))]

lines = []
output = []
labels = []
#create dictionary
for i in range(len(lines_raw)):
    line_processed = lines_raw[i].split(comment_string)[0].strip()
    parts = line_processed.replace(","," ")
    parts = parts.replace(")"," ")
    parts = parts.replace("("," ")
    parts = parts.split(" ")

    label = ""
    if (":" in line_processed):
        label = parts[0]
        parts.remove(label)

    while("" in parts):
        parts.remove("")

    address = hex(len(lines)*4)
    new_inst = {"instruction":line_processed,"parts":parts,"lineNum":line_number[i],"type":"", "index":0, "address":address}
    new_label = {"label":label,"address":address}

    if line_processed != "":
        lines.append(new_inst)
        if label != "":
            labels.append(new_label)

# determine instruction type
for i in range(len(lines)):
    inst = lines[i]["parts"][0]
    inst_index = next((d['index'] for d in isac.isd if d.get("name") == inst.lower()), None)
    inst_type = isac.isd[inst_index]["type"]
    if inst_type == None:
        print("Illegal mnemonic at [line " + str(lines[i]["lineNum"]) + "] : " + lines[i]["instruction"])
        continue
    else:
        lines[i]["index"] = inst_index
        lines[i]["type"] = inst_type

def labelAddress(label):
    label = label + ":"
    address = next((d['address'] for d in labels if d.get("label") == label), None)
    return address

def decode_u(line):
    code = ""
    if val.rd(line["parts"][1]):
        immediate = line["parts"][2]
        sign = '1' if ('-' in immediate) else '0'
        bin_value = fn.convertTobin(immediate)

        inst_imm = val.ufvLength(bin_value, sign, 20)
        rd_address = fn.getAddress(line["parts"][1])
        opcode = isac.isd[line["index"]]["opcode"]

        code = fn.binary_to_hex(inst_imm + rd_address + opcode)
    else:
        val.error("rdzero", line);
    return code

def decode_j(line):
    code = ""
    if val.rd(line["parts"][1]):
        immediate = line["parts"][2]
        
        if (immediate[0].isalpha() or immediate[0] == '_'): # check if address is a label
            immediate = labelAddress(immediate)
            if (immediate == None):
                print("Undefined label at [line " + str(line["lineNum"]) + "] : " + line["instruction"])
                return code
            immediate = str( round( (int(immediate,16) - int(line["address"],16))/2) )   # calculate offset

        sign = '1' if ('-' in immediate) else '0'
        bin_value = fn.convertTobin(immediate)
        
        imm = val.ufvLength(bin_value, sign, 20)
        imm = imm[::-1]
        inst_imm = str(imm[19]) + str(imm[9::-1]) + str(imm[10]) + str(imm[18:10:-1])
        rd_address = fn.getAddress(line["parts"][1])
        opcode = isac.isd[line["index"]]["opcode"]

        code = fn.binary_to_hex(inst_imm + rd_address + opcode)
    else:
        val.error("rdzero", line);
    return code

def decode_b(line):
    code = ""
    immediate = line["parts"][3]
    
    if (immediate[0].isalpha() or immediate[0] == '_'): # check if address is a label
        immediate = labelAddress(immediate)
        if (immediate == None):
            print("Undefined label at [line " + str(line["lineNum"]) + "] : " + line["instruction"])
            return code
        immediate = str( round( (int(immediate,16) - int(line["address"],16))/2) )   # calculate offset

    sign = '1' if ('-' in immediate) else '0'
    bin_value = fn.convertTobin(immediate)

    imm = val.ufvLength(bin_value, sign, 12)
    imm = imm[::-1]
    rs1_address = fn.getAddress(line["parts"][1])
    rs2_address = fn.getAddress(line["parts"][2])
    opcode = isac.isd[line["index"]]["opcode"]
    func3 = isac.isd[line["index"]]["func3"]

    code = fn.binary_to_hex(imm[11] + imm[9:3:-1] + rs2_address + rs1_address + func3 + imm[3::-1] + imm[10] + opcode)
    return code

def decode_r(line):
    rd_address = fn.getAddress(line["parts"][1])
    rs1_address = fn.getAddress(line["parts"][2])
    rs2_address = fn.getAddress(line["parts"][3])
    opcode = isac.isd[line["index"]]["opcode"]
    func3 = isac.isd[line["index"]]["func3"]
    func7 = isac.isd[line["index"]]["func7"]

    code = fn.binary_to_hex(func7 + rs2_address + rs1_address + func3 + rd_address + opcode)
    return code

def decode_s(line):
    immediate = line["parts"][2]

    sign = '1' if ('-' in immediate) else '0'
    bin_value = fn.convertTobin(immediate)

    imm = val.ufvLength(bin_value, sign, 12)
    imm = imm[::-1]
    rs1_address = fn.getAddress(line["parts"][3])
    rs2_address = fn.getAddress(line["parts"][1])
    opcode = isac.isd[line["index"]]["opcode"]
    func3 = isac.isd[line["index"]]["func3"]

    code = fn.binary_to_hex(imm[11:4:-1] + rs2_address + rs1_address + func3 + imm[4::-1] + opcode)
    return code

def decode_i(line):
    code = ""
    inst_name = line["parts"][0]    

    group0 = ['jalr']
    group1 = ["lb", "lh", "lw", "lbu", "lhu", "csrrw", "csrrs", "csrrc"]
    group2 = ["addi", "slti", "sltiu", "xori", "ori", "andi"]
    group3 = ["slli", "srli", "srai"]
    group4 = ["ecall", "ebreak"]
    group5 = ["csrrwi", "csrrsi", "csrrci"]

    if (inst_name in group1):
        immediate = line["parts"][2]

        if (inst_name == 'jalr'):
            if (immediate[0].isalpha() or immediate[0] == '_'): # check if address is a label
                immediate = labelAddress(immediate)
                if (immediate == None):
                    print("Undefined label at [line " + str(line["lineNum"]) + "] : " + line["instruction"])
                    return code

        sign = '1' if ('-' in immediate) else '0'
        bin_value = fn.convertTobin(immediate)

        imm = val.ufvLength(bin_value, sign, 12)
        rd_address = fn.getAddress(line["parts"][1])
        rs1_address = fn.getAddress(line["parts"][3])
        func3 = isac.isd[line["index"]]["func3"]
        opcode = isac.isd[line["index"]]["opcode"]

        code = fn.binary_to_hex(imm + rs1_address + func3 + rd_address + opcode)
    
    elif (inst_name in group2):
        immediate = line["parts"][3]
        sign = '1' if ('-' in immediate) else '0'
        bin_value = fn.convertTobin(immediate)

        imm = val.ufvLength(bin_value, sign, 12)
        rd_address = fn.getAddress(line["parts"][1])
        rs1_address = fn.getAddress(line["parts"][2])
        func3 = isac.isd[line["index"]]["func3"]
        opcode = isac.isd[line["index"]]["opcode"]

        code = fn.binary_to_hex(imm + rs1_address + func3 + rd_address + opcode)
    
    elif (inst_name in group3):
        immediate = line["parts"][3]
        sign = '1' if ('-' in immediate) else '0'
        bin_value = fn.convertTobin(immediate)

        shamt = val.ufvLength(bin_value, sign, 5)
        rd_address = fn.getAddress(line["parts"][1])
        rs1_address = fn.getAddress(line["parts"][2])
        opcode = isac.isd[line["index"]]["opcode"]
        func3 = isac.isd[line["index"]]["func3"]
        func7 = isac.isd[line["index"]]["func7"]

        code = fn.binary_to_hex(func7 + shamt + rs1_address + func3 + rd_address + opcode)
    
    elif (inst_name in group4):
        code = isac.isd[line["index"]]["instruction"]

    elif (inst_name in group5):
        # csr address
        immediate = line["parts"][2]
        sign = '1' if ('-' in immediate) else '0'
        bin_value = fn.convertTobin(immediate)
        csr = val.ufvLength(bin_value, sign, 12)

        # zimm
        immediate = line["parts"][3]
        sign = '1' if ('-' in immediate) else '0'
        bin_value = fn.convertTobin(immediate)
        zimm = val.ufvLength(bin_value, sign, 5)

        rd_address = fn.getAddress(line["parts"][1])
        opcode = isac.isd[line["index"]]["opcode"]
        func3 = isac.isd[line["index"]]["func3"]

        code = fn.binary_to_hex(csr + zimm + func3 + rd_address + opcode)

    else:
        print("Error. No such mnemonic");
    
    return code

for line in lines:
    # print(line['instruction'])
    inst_type = line['type']
    code = ""

    if inst_type == 'r':
        code = decode_r(line)
    elif inst_type == 'i':
        code = decode_i(line)
    elif inst_type == 's':
        code = decode_s(line)
    elif inst_type == 'u':
        code = decode_u(line)
    elif inst_type == 'j':
        code = decode_j(line)
    elif inst_type == 'b':
        code = decode_b(line)

    if code == "":
        print("Instruction not assembled.")
        continue
    # print(line["instruction"] + " ----> \t\t " + code)
    output.append(code)

# output contains all the assembled code
# print(output)

# write to file
ROM_size = 2048 # 8KB: 2048 location each of 4byte(32-bit)
asm = open(output_file_location, "w")
for mem in range(ROM_size):
    if (mem < len(output)):
        asm.writelines(output[mem])
    else:
        asm.writelines("00000000")
    
    if (mem != ROM_size-1):
        asm.write("\n")

asm.close()
print("Output written to bin/program.mem.")