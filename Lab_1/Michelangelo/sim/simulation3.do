#sim and link
vsim -L /software/dk/nangate45/verilog/msim6.2g -sdftyp /tb_fir/UUT=../innovus/myfir.sdf work.tb_fir 

#open switch file where sw_activity will be written
vcd file ../vcd/design.vcd

#specify that we want to monitor all the signals inside our UUT
vcd add /tb_fir/UUT/*

#run
run 5 us

#quit
quit -sim
quit

