#variables
variable top_entity "filter"
variable top_entity_arch "STRUCTURAL"
variable period "11.56"
variable report_folder "clock_11.56"

remove_design -designs

#analyze
analyze -f vhdl -lib WORK ../src/ADDER_NBIT.vhd
analyze -f vhdl -lib WORK ../src/MULTIPLIER_NBIT.vhd
analyze -f vhdl -lib WORK ../src/REGISTER_NBIT.vhd
analyze -f vhdl -lib WORK ../src/SHIFT_REG_1bit.vhd
analyze -f vhdl -lib WORK ../src/filter.vhd

set power_preserve_rtl_hier_names true

#elaborate
elaborate $top_entity -architecture $top_entity_arch  -library work

create_clock -name MYCLK -period $period CLK

#set dont touch and uncertaintly
set_dont_touch_network MYCLK
set_clock_uncertainty 0.07 [get_clocks MYCLK]
set_input_delay 0.5 -max -clock MYCLK [remove_from_collection [all_inputs] MYFIR_IN_CLK]
set_output_delay 0.5 -max -clock MYCLK [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]

#compile
compile 

#report
report_timing > ../report/$report_folder/timing_report_${period}ns.txt
report_area > ../report/$report_folder/area_report_${period}ns.txt
report_power > ../report/$report_folder/power_report_${period}ns.txt

source verilog_gen.tcl
