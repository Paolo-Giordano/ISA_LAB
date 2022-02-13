variable top_entity "RISC_V"

#read back the netlist
read_verilog -netlist ../netlist/$top_entity.v

#read saif file
read_saif -input ../saif/${top_entity}_syn.saif -instance tb_${top_entity}/i_DUT -unit ns -scale 1

#create clock
create_clock -name CLK

report_power > ../report/compile_en_clk_gate/power_estimation.txt

