#variables
variable top_entity "FPmul"
variable top_entity_arch "pipeline"
variable period "1.49"
variable report_folder "mult_ultra/clock_1_49"

remove_design -designs

#analyze
analyze -f vhdl -lib WORK ../src/array_interface_pack.vhd
analyze -f vhdl -lib WORK ../src/constant_pack.vhd
analyze -f vhdl -lib WORK ../src/mux8to1.vhd
analyze -f vhdl -lib WORK ../src/RecodingLogic.vhd
analyze -f vhdl -lib WORK ../src/PPunit.vhd
analyze -f vhdl -lib WORK ../src/HA.vhd
analyze -f vhdl -lib WORK ../src/FA.vhd
analyze -f vhdl -lib WORK ../src/dadda_tree_32.vhd
analyze -f vhdl -lib WORK ../src/ADDER_NBIT.vhd
analyze -f vhdl -lib WORK ../src/MBEmult.vhd

analyze -f vhdl -lib WORK ../src/fpmul_stage1_struct.vhd
analyze -f vhdl -lib WORK ../src/fpmul_stage2_struct.vhd
analyze -f vhdl -lib WORK ../src/fpmul_stage3_struct.vhd
analyze -f vhdl -lib WORK ../src/fpmul_stage4_struct.vhd
analyze -f vhdl -lib WORK ../src/fpnormalize_fpnormalize.vhd
analyze -f vhdl -lib WORK ../src/fpround_fpround.vhd
analyze -f vhdl -lib WORK ../src/packfp_packfp.vhd
analyze -f vhdl -lib WORK ../src/unpackfp_unpackfp.vhd
analyze -f vhdl -lib WORK ../src/fpmul_pipeline.vhd

#set power_preserve_rtl_hier_names true

#elaborate
elaborate $top_entity -architecture $top_entity_arch  -library work

#uniquify
#link

create_clock -name clk -period $period clk

set_dont_touch_network clk
set_clock_uncertainty 0.07 [get_clocks clk]
set_input_delay 0.5 -max -clock clk [remove_from_collection [all_inputs] clk]
set_output_delay 0.5 -max -clock clk [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]

#flat the hyerarchy
ungroup -all -flatten
#set_implementation DW01_add/pparch [find cell *i_adder*]

#compile
compile_ultra 
#optimize_register

report_timing
#report_resources > ../report/$report_folder/report_resources.txt
#report
#report_timing > ../report/$report_folder/timing_report_${period}ns.txt
#report_area > ../report/$report_folder/area_report_${period}ns.txt
#report_power > ../report/$report_folder/power_report_${period}ns.txt


