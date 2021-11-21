in this folder there are the intermediate versions on the optimized FIR
the one with only unfolding and some attempts of pipelining to get the maximum
throughput
at the beginning of each file there is a small description to recognize the version
in all cases the constant shift_input_c has to be set to decide between the version
with shifts only after the multiplications (in this case shift_input_c=0) or the version
with shited inputs (shift_input_c=4)

In src folder there are filter.vhd and filter_opt.vhd. keep the names to work with the script. 
If you want to use other versions, just copy-paste in src and change name (eliminate the previous before).

