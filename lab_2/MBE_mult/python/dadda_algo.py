'''
Created on 14 nov 2021

@author: Michelangelo

@description: implementation of the dadda tree algorithm
'''

import math

'''global variables'''

#it contains, at each index 'i', the number of
#maximum input that con be combined in i layer
l = []

#at each index 'i', dots_per_col[i] is equal to the number
#of bits that have to be summed in the column i (from dx to sx)
dots_per_col = []

#input multiplier/multiplicand parallelism.
N = 32

'''auxiliary functions'''

def dotsInitilize(N):
    """
    dotsInitilize initialize the dots_per_col list
    depending on parallelism.

    :param N: input multiplier/multiplicand parallelism.
    :global dots_per_col: described above
    """
    global dots_per_col

    j=2

    #first set of incrementing number of dots (2 1 3 2 4 3 ...)
    for i in range(0,N-1,2):
        dots_per_col.append(j)
        dots_per_col.append(j-1)

        j+=1
    j-=1

    #second set of (4+N%2) equal number of dots
    for i in range(0,4+N%2):
        dots_per_col.append(j)

    #third set of decrementing dots (... 4 4 3 3 2 )
    if N>4:
        dots_per_col.append(j-1)
        j -= 2
        for i in range(0,N-6-N%2,2):
            dots_per_col.append(j)
            dots_per_col.append(j)
            j-=1
        dots_per_col.append(2)

        #adding a dot at the end if N is odd
        if (N%2 == 1) :
            dots_per_col.append(2)


def maxInputPerLayer():
    """
    maxInputPerLayer initialize 'l' list. l[j] = [3/2*l[j-1]] implementation

    :global l: described above

    """
    global l
    l.append(2)
    while l[-1] < 40:
        l.append(math.floor(3.0/2*l[-1]))


def computeMaxInput(n):
    """
    computeMaxInput compute what will be the maximum number of input of the
    next layer by taking the number of maximum input of the current layer.

    :param n: maximum number of input per column of the currrent layer
    :global l: described above.
    :return ret_value: maximum number if input per column of the next layer.
    """
    global l


    if (n <= 2):
        #if actual number of input is just lower or equal than 2
        #no more reduction is needed
        ret_value = 0
    else:
        #search the correct value visiting l list from 0 to length(l)
        for i in range(0,len(l)):
            if l[i] >= n :
                ret_value = l[i-1]
                break

    return ret_value


def reduction():
    """
    reduction computes the number of HAs,FAs and PP not
    processed for the current layer to obtain the optimal
    amount of maximum input for the next layer.

    :global dots_per_col: described above
    :return n_HA: number of HAs instantiated per each column
    :return n_FA: number of FAs instantiated per each column
    :return n_noProc: number of partial product not processed per each column
    """
    global dots_per_col

    #create a copy without reference, to recover the number of dots before reduction
    dots_per_col_new = dots_per_col.copy()
    dots_per_col_new.append(0)

    #inizialization of empty vector to save needed informations
    n_HA = []
    n_FA = []
    n_noProc = []

    #compute maximum number of input of the next layer
    max_input = computeMaxInput(max(dots_per_col_new))

    #cycle along column from the rihtmost
    for i in range(0,len(dots_per_col)):

        n_HA.append(0)
        n_FA.append(0)
        n_noProc.append(0)

        #instantiotion of HAs and FAs since there are to many dots
        while dots_per_col_new[i] > max_input:

            #instantiation of an HA only if the number of exceding dots is odd
            if (max_input - dots_per_col_new[i]) % 2 != 0 :
                n_HA[i] += 1
                dots_per_col_new[i] -= 1
                dots_per_col_new[i+1] += 1
            else:
                n_FA[i] += 1
                dots_per_col_new[i] -= 2
                dots_per_col_new[i+1] += 1
        #recover the number of unprocessed bits thanks to old "dots_per_col"
        n_noProc[i] = dots_per_col[i] - 2*n_HA[i] - 3*n_FA[i]



    dots_per_col = dots_per_col_new[0:-1].copy()

    return n_HA,n_FA,n_noProc


def daddaAlgorithm():
    """
    daddaAlgorithm saves inside a list the number of
    HAs,FAs,PP not processed for each column and for each layer.

    :global dots_per_col: described above
    :global N: described above
    :return ret_value: the list with all usefull info.
    """
    global dots_per_col,N

    #inizialitation of "dots_per_col" and "l" vectors
    maxInputPerLayer()
    dotsInitilize(N)

    ret_value = []

    i=1

    #loop since we have only 2 dots per column
    while(computeMaxInput(max(dots_per_col)) >= 2):

        print("Step {}".format(i))
        print("Dots:     {}".format(dots_per_col))

        #reduction of current layer
        n_HA,n_FA,n_noProc = reduction()

        #reverse vector to have the information about the
        #rightmost column at the end of the vector, to simplify package writing
        n_HA.reverse()
        n_FA.reverse()
        n_noProc.reverse()

        n_HA.append(0)
        n_FA.append(0)
        n_noProc.append(0)

        ret_value.append(n_HA)
        ret_value.append(n_FA)
        ret_value.append(n_noProc)

        #printing informations on screen (usefull during debugging)
        print("n_HA=     {}".format(n_HA))
        print("n_FA=     {}".format(n_FA))
        print("n_noProc= {}".format(n_noProc))

        print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n")

        i += 1

    print("Final dots: {}".format(dots_per_col))

    return ret_value


def writeConstants(filename,constants_list):
    """
    writeConstants writes a vhdl package with a list of
    interesting informations for the HW description of
    the Dadda Multiplier.


    :param filename: filename of the vhdl package
    :param constants_list: list of HAs,FAs,PP not processed,
    per each layer and per each column
    :global N: described above
    :return: describe what it returns
    """
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

    #name of the package
    filename = "../src/constant_pack.vhd"

    writeConstants(filename,daddaAlgorithm())

    print(l)
