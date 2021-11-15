'''
Created on 15 nov 2021

@author: Michelangelo

@description: write input stimuli, check output result
'''

from random import getrandbits
import sys

#global variables
N = 32

#random input generator
def randomInputGen(filename):
    
    global N
    
    testfile = open(filename, 'w')
 
    
    for i in range(1000):
        a = format(getrandbits(N), 'b')
        b = format(getrandbits(N), 'b')
        testfile.write(a.zfill(N) + " " + b.zfill(N) + "\n")
        
    testfile.close()
    
def modelGen(input_filename,model_filename):
    
    global N
    
    f_input = open(input_filename,'r')
    f_model = open(model_filename,'w')
    
    for input_line in f_input:
        [a_str, b_str] = input_line.split()
    
        a_int = int(a_str,2)
        b_int = int(b_str,2)
    
            
        z_exp = a_int * b_int
        z_str = format(z_exp,'b').zfill(2*N)
        
        f_model.write(z_str + "\n")
    
    f_model.close()
    f_input.close()
        
        
    
#it reads output file from design line by line
#and verify its correctness
def checkOutput(model_filename,dut_filename):
    
    model_file = open(model_filename, 'r')
    dut_file = open(dut_filename, 'r')
    line_count = 1
    error_flag = 0
    
    total_err_cnt = 0
    
    dut_file.readline()
    for dut_line,model_line in zip(dut_file,model_file):
              

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
        print(f"Total errors: {(total_err_cnt/10)}%")
        
        
        
if __name__ == '__main__':
    
    input_filename = "input_vectors.txt"
    model_filename = "model_output.txt"
    dut_filename   = "dut_output.txt"
    
    print(sys.argv[1])
    
    if sys.argv[1] == "0":
            
        randomInputGen(input_filename)
        modelGen(input_filename, model_filename)
        
    elif sys.argv[1] == "1":
        checkOutput(model_filename, dut_filename)
    
    
    
