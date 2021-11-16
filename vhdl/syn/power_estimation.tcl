variable folder "filter_unfolding_v3_inputshifted/clock_5_28"
variable top_entity "filter_opt"

#read back the netlist
read_verilog -netlist ../netlist/$top_entity.v

#read saif file
read_saif -input ../saif/${top_entity}_syn.saif -instance tb_fir/UUT -unit ns -scale 1

#create clock
create_clock -name CLK

report_power > ../report/$folder/power_estimation.txt
