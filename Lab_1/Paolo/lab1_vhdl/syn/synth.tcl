#variables
variable top_entity "MYFIR"
variable top_entity_arch "STRUCTURAL"
variable report_folder "MYFIR_shifted_input"
variable periodstr "_2_9"

remove_design -designs

#analyze
analyze -library WORK -format vhdl {/home/isa03_2021_2022/Lab_ISA/Lab_1/Paolo/lab1_vhdl/src/SHIFT_REG_1bit.vhd /home/isa03_2021_2022/Lab_ISA/Lab_1/Paolo/lab1_vhdl/src/REGISTER_NBIT.vhd /home/isa03_2021_2022/Lab_ISA/Lab_1/Paolo/lab1_vhdl/src/MY_FIR.vhd /home/isa03_2021_2022/Lab_ISA/Lab_1/Paolo/lab1_vhdl/src/MULTIPLIER_NBIT.vhd /home/isa03_2021_2022/Lab_ISA/Lab_1/Paolo/lab1_vhdl/src/ADDER_NBIT.vhd}

set power_preserve_rtl_hier_names true
#elaborate
elaborate $top_entity -architecture $top_entity_arch  -library work

create_clock -name MYCLK -period 2.90 MYFIR_IN_CLK
#set dont touch and uncertaintly
set_dont_touch_network MY_CLK
set_dont_touch_network MYCLK
set_clock_uncertainty 0.07 [get_clocks MYCLK]
set_input_delay 0.5 -max -clock MYCLK [remove_from_collection [all_inputs] MYFIR_IN_CLK]
set_output_delay 0.5 -max -clock MYCLK [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]

#compile
compile -exact_map

#report
report_timing > ../report/MYFIR_shifted_input/timing_report_2_90ns.txt
report_area > ../report/$report_folder/area_report_2_90ns.txt

#backannotation
ungroup -all -flatten
change_names -hierarchy -rules verilog
write_sdf ../netlist/MYFIR.sdf
write -f verilog -hierarchy -output ../netlist/MYFIR.v
write_sdc ../netlist/MYFIR.sdc
