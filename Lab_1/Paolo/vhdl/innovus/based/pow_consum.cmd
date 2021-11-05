restoreDesign /home/isa03_2021_2022/Lab_ISA/Lab_1/Paolo/vhdl/innovus/based/filter.enc.dat filter
setDrawView fplan
encMessage warning 0
encMessage debug 0
encMessage info 0
reset_parasitics
extractRC
rcOut -setload filter.setload -rc_corner my_rc
rcOut -setres filter.setres -rc_corner my_rc
rcOut -spf filter.spf -rc_corner my_rc
rcOut -spef filter.spef -rc_corner my_rc
set_power_analysis_mode -reset
set_power_analysis_mode -method static -corner max -create_binary_db true -write_static_currents true -honor_negative_energy true -ignore_control_signals true
set_power_output_dir -reset
set_power_output_dir ./
set_default_switching_activity -reset
set_default_switching_activity -input_activity 0.2 -period 10.0
read_activity_file -reset
read_activity_file -format VCD -scope tb_fir/UUT -start {} -end {} -block {} ../../vcd/filter_innovus.vcd
set_power -reset
set_powerup_analysis -reset
set_dynamic_power_simulation -reset
report_power -rail_analysis_format VS -outfile .//filter.rpt
report_power -outfile power_post_p&r.txt -sort { total }
summaryReport
