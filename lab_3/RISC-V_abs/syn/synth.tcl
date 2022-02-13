#variables
variable top_entity "RISC_V"
variable period "3.35"

remove_design -designs

#analyze
analyze -library WORK -format vhdl {/home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_abs/src/xor.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_abs/src/RISC_V.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_abs/src/RF.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_abs/src/REGISTER_PC.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_abs/src/REGISTER_NBIT.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_abs/src/mux8to1.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_abs/src/mux4to1.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_abs/src/mux2to1.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_abs/src/memory_stage.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_abs/src/instr_fetch_stage.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_abs/src/IMM_GEN.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_abs/src/forwardig_unit.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_abs/src/execution_stage.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_abs/src/DECODE_STAGE.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_abs/src/data_hazard_det_unit.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_abs/src/CU.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_abs/src/control_hazard_det_unit.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_abs/src/brach_prediction_table.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_abs/src/arith_right_shifter.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_abs/src/and.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_abs/src/ALUcontrol.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_abs/src/ALU.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_abs/src/adder_subtractor.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_abs/src/adder.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_abs/src/abs_unit.vhd}

set power_preserve_rtl_hier_names true

#elaborate
elaborate $top_entity -architecture structural -library work > elaborate_log.txt

create_clock -name MYCLK -period $period RISC_V_IN_CLK

#set dont touch and uncertaintly
set_dont_touch_network MYCLK
set_clock_uncertainty 0.07 [get_clocks MYCLK]
set_input_delay 0.5 -max -clock MYCLK [remove_from_collection [all_inputs] RISC_V_IN_CLK]
set_output_delay 0.5 -max -clock MYCLK [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]

#compile
compile > compile_log.txt

#report
report_timing > ../report/compile_en_clk_gate/timing_report.txt
report_area   > ../report/compile_en_clk_gate/area_report.txt
report_power > ../report/compile_en_clk_gate/power_report.txt
report_power -hier > ../report/compile_en_clk_gate/power_hier_report.txt
report_resource > ../report/compile_en_clk_gate/resource_report.txt
report_timing

#source verilog_gen.tcl
