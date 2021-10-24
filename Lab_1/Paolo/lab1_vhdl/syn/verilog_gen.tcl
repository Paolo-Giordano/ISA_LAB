#backannotation

#ungrup the cell to flatten the hierarchy
ungroup -all -flatten

#impose verilog rules to intern signals, to export netlist in verilog
change_names -hierarchy -rules verilog

#write a standard delay format file to descibe the delay of the netlist
write_sdf ../netlist/filter.sdf

#save netlist in verilog
write -f verilog -hierarchy -output ../netlist/filter.v

#write constarint ofin/out in standard format
write_sdc ../netlist/filter.sdc
