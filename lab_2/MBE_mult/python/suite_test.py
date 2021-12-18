'''
Created on 15 nov 2021

@author: Michelangelo

@description: it writes input stimuli (if argv[1] == 0),
              computes expected result (if argv[1] == 0),
              and check output result (if argv[1] == 1).
'''

from random import getrandbits
import sys

'''global variables'''
N = 32

'''auxiliary functions'''

def randomInputGen(filename):

    """
    randomInputGen writes a file with 1000 lines, two binary
    32 bits numbers per line. It will be read by the design testbench.

    :param filename: name of the file to be written.
    """

    global N

    testfile = open(filename, 'w')


    for i in range(1000):
        a = format(getrandbits(N), 'b')
        b = format(getrandbits(N), 'b')
        testfile.write(a.zfill(N) + " " + b.zfill(N) + "\n")

    testfile.close()

def modelGen(input_filename,model_filename):

    """
    modelGen read an input file with two binary
    32 bits per line and write the result inside another
    file. It computes the result by a simple "*" operation.

    :param input_filename: name of the file to be read.
    :param model_filename: name of the file where saving results.
    """

    global N

    f_input = open(input_filename,'r')
    f_model = open(model_filename,'w')

    #for each line of input file, compute output
    for input_line in f_input:
        [a_str, b_str] = input_line.split()

        a_int = int(a_str,2)
        b_int = int(b_str,2)


        z_exp = a_int * b_int
        z_str = format(z_exp,'b').zfill(2*N)

        f_model.write(z_str + "\n")

    f_model.close()
    f_input.close()


def checkOutput(model_filename,dut_filename):

    """
    checkOutput reads output file from design line by line
    and verify its correctness by writing on std_out if there
    are errors or not.

    :param model_filename: name of the file with the expected results.
    :param dut_filename: name of the file with the dut results.
    """

    model_file = open(model_filename, 'r')
    dut_file = open(dut_filename, 'r')
    line_count = 1
    error_flag = 0

    total_err_cnt = 0

    dut_file.readline()

    #compare each corresponding line of model and design
    for dut_line,model_line in zip(dut_file,model_file):

        #if different, arise a flag, print error and increment error counter
        if dut_line != model_line:
            error_flag = 1
            total_err_cnt += 1


            print(f"Error in line: {line_count}")
            print(f"dut result: {dut_line}")
            print(f"exp result: {model_line}")


        line_count += 1

    if error_flag == 0:
        print("Result check successful!")
    else:
        print("Result check failed!")
        print(f"Total errors: {(total_err_cnt/line_count)*100}%")



if __name__ == '__main__':

    input_filename = "input_vectors.txt"
    model_filename = "model_output.txt"
    dut_filename   = "dut_output.txt"

    print(sys.argv[1])

    #generation of input and model
    if sys.argv[1] == "0":

        randomInputGen(input_filename)
        modelGen(input_filename, model_filename)

    #check design correctness
    elif sys.argv[1] == "1":
        checkOutput(model_filename, dut_filename)
