#backannotation
variable top_entity "filter_opt"

#ungrup the cell to flatten the hierarchy
ungroup -all -flatten

#impose verilog rules to intern signals, to export netlist in verilog
change_names -hierarchy -rules verilog

#write a standard delay format file to descibe the delay of the netlist
write_sdf ../netlist/$top_entity.sdf

#save netlist in verilog
write -f verilog -hierarchy -output ../netlist/$top_entity.v

#write constarint ofin/out in standard format
write_sdc ../netlist/$top_entity.sdc
