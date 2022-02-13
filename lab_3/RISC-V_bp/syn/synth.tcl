#variables
variable top_entity "RISC_V"
variable period "3.3"
#3.3 works

remove_design -designs

#analyze
analyze -library WORK -format vhdl {/home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_bp/src/xor.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_bp/src/RISC_V.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_bp/src/RF.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_bp/src/REGISTER_PC.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_bp/src/REGISTER_NBIT.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_bp/src/mux8to1.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_bp/src/mux4to1.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_bp/src/mux2to1.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_bp/src/memory_stage.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_bp/src/instr_fetch_stage.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_bp/src/IMM_GEN.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_bp/src/forwardig_unit.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_bp/src/execution_stage.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_bp/src/DECODE_STAGE.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_bp/src/data_hazard_det_unit.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_bp/src/CU.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_bp/src/control_hazard_det_unit.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_bp/src/brach_prediction_table.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_bp/src/arith_right_shifter.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_bp/src/and.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_bp/src/ALUcontrol.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_bp/src/ALU.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_bp/src/adder_subtractor.vhd /home/isa03_2021_2022/Lab_ISA/Lab_3/RISC-V_bp/src/adder.vhd}

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



compile > compile_log.txt


#report
report_timing > ../report/compile_en_clk_gate/timing_report.txt
report_area   > ../report/compile_en_clk_gate/area_report.txt
report_power > ../report/compile_en_clk_gate/power_report.txt
report_power -hier > ../report/compile_en_clk_gate/power_hier_report.txt
report_resources > ../report/compile_en_clk_gate/resource_report.txt
report_timing


#source verilog_gen.tcl
