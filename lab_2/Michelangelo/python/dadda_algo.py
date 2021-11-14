'''
Created on 14 nov 2021

@author: Michelangelo

@description: implementation of the dadda tree algorithm
'''

import math
from encodings.idna import dots
from numpy.core._multiarray_umath import dot

#global variables
l = []
dots_per_col = []

############### touch only this #####################
N = 32
#####################################################

def dotsInitilize(N):
    global dots_per_col
    
    j=2
    for i in range(0,N,2):
        dots_per_col.append(j)
        dots_per_col.append(j-1)
        
        j+=1
    j-=1
    for i in range(0,4):
        dots_per_col.append(j)
    
    if N>4:
        dots_per_col.append(j-1)
        j -= 2
        for i in range(0,N-6,2):
            dots_per_col.append(j)
            dots_per_col.append(j)
            j-=1
        dots_per_col.append(2)
    

def maxInputPerLayer():
    global l
    l.append(2)
    while l[-1] < 40:
        l.append(math.floor(3.0/2*l[-1]))

        
def computeMaxInput(n):
    
    if (n <= 2):
        ret_value = 0
    else:
        for i in range(0,len(l)):
            if l[i] >= n :
                ret_value = l[i-1]
                break
        
    return ret_value

def reduction():
    global dots_per_col
    
    dots_per_col_new = dots_per_col.copy()
    dots_per_col_new.append(0)
    
    n_HA = []
    n_FA = []
    n_noProc = []
    
    max_input = computeMaxInput(max(dots_per_col_new))
    
    for i in range(0,len(dots_per_col)):
        
        n_HA.append(0)
        n_FA.append(0)
        n_noProc.append(0)
        
        while dots_per_col_new[i] > max_input:
            if (max_input - dots_per_col_new[i]) % 2 != 0 :
                n_HA[i] += 1
                dots_per_col_new[i] -= 1
                dots_per_col_new[i+1] += 1
            else:
                n_FA[i] += 1
                dots_per_col_new[i] -= 2
                dots_per_col_new[i+1] += 1
        
        n_noProc[i] = dots_per_col[i] - 2*n_HA[i] - 3*n_FA[i]
        
    
    
    dots_per_col = dots_per_col_new[0:-1].copy()
    
    return n_HA,n_FA,n_noProc
    

def daddaAlgorithm():
    global dots_per_col,N
    
    maxInputPerLayer()
    dotsInitilize(N)
    
    ret_value = []
    
    i=1
    
    while(computeMaxInput(max(dots_per_col)) >= 2):
        
        print("Step {}".format(i))
        print("Dots:     {}".format(dots_per_col))
        
        n_HA,n_FA,n_noProc = reduction()

        
        n_HA.reverse()
        n_FA.reverse()
        n_noProc.reverse()
        
        n_HA.append(0)
        n_FA.append(0)
        n_noProc.append(0)
        
        ret_value.append(n_HA)
        ret_value.append(n_FA)
        ret_value.append(n_noProc)
                
        
        print("n_HA=     {}".format(n_HA))
        print("n_FA=     {}".format(n_FA))
        print("n_noProc= {}".format(n_noProc))

        print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n")
        
        i += 1
        
    print("Final dots: {}".format(dots_per_col))
    
    return ret_value
  
def writeConstants(filename,constants_list):
    global N
    
    f_out = open(filename, 'w')

    #head of the file
    f_out.write("library IEEE;\n")
    f_out.write("use IEEE.std_logic_1164.all;\n")
    f_out.write("use IEEE.numeric_std.all;\n")
    
    f_out.write("\n\n")
    
    f_out.write("package constant_pack is\n")
    
    f_out.write("\n\n")
        
    
    #type declaration
    f_out.write("    type int_vect is array ({} downto 0) of integer range 0 to {};\n".format(2*N,2*N))
    
    #constants definition
    for i in range(0,len(constants_list),3):
        f_out.write("\n    --reduction step {}\n".format(math.floor(i/3)))
        f_out.write("    constant N_HA_{}       : int_vect := {};\n".format(math.floor(i/3),tuple(constants_list[i])))
        f_out.write("    constant N_FA_{}       : int_vect := {};\n".format(math.floor(i/3),tuple(constants_list[i+1])))
        f_out.write("    constant N_noproc_{}   : int_vect := {};\n".format(math.floor(i/3),tuple(constants_list[i+2])))
    
    f_out.write("\n\n")
    
    #tail of the file
    f_out.write("end package;\n")
    
      

if __name__ == '__main__':
       
    #print(daddaAlgorithm())
    filename = "../src/constant_pack.vhd"
    
    writeConstants(filename,daddaAlgorithm())
    
    print(l)
    
    
    

    
    
    
    
    
