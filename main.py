import os
import sys

ROOT_DIR = os.path.dirname(os.path.abspath(__file__))

def sanitycheck():
    # check if the script is running in the correct directory
    if os.path.basename(os.getcwd()) != 'apicore':
        print('Please run this script from the apicore directory')
        sys.exit(1)

    # check if iverilog is installed
    if os.system('iverilog -V') != 0:
        print('Please install iverilog')
        sys.exit(1)

def listfiles():
    # list all files in the directory 
    files = os.listdir("tb")
    if len(files) == 0 or os.path.exists(f'{ROOT_DIR}/tb') == False:
        print('No testbench files found')
        sys.exit(1)
    # filter out all files that are not .v files
    files = [f for f in files if f.endswith('.v')]
    # filter out all files that are not testbench files
    files = [f for f in files if f.startswith('tb_')]
    # sort the files
    files.sort()
    # return the list of files
    return files

def runtestbench(file):
    # check if the bin directory exists
    if not os.path.exists(f'{ROOT_DIR}/bin'):
        os.makedirs(f'{ROOT_DIR}/bin')
    # check if the waveform directory exists
    if not os.path.exists(f'{ROOT_DIR}/waveform'):
        os.makedirs(f'{ROOT_DIR}/waveform')
    # run the testbench
    os.system(f'iverilog -grelative-include -o {ROOT_DIR}/bin/{file[:-2]} {ROOT_DIR}/tb/{file}')
    os.system(f'cd {ROOT_DIR}/waveform && vvp {ROOT_DIR}/bin/{file[:-2]}')

def main():
    if len(sys.argv) > 1:
        abs_path = os.path.abspath(os.path.dirname(__file__))
        filepath = os.path.join(abs_path, sys.argv[1])
        runtestbench(sys.argv[1])
        sys.exit(0)
    print('Running sanity check...')
    sanitycheck()
    print('Sanity check passed')
    print('Listing files...')
    files = listfiles()
    print('Files listed')
    print('Running testbenches...')
    for file in files:
        print(f'Running testbench {file}')
        runtestbench(file)
    print('Testbenches ran')

if __name__ == '__main__':
    main()