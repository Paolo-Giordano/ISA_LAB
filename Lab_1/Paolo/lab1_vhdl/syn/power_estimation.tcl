variable period "11.56"

#read back the netlist
read_verilog -netlist ../netlist/filter.v

#read saif file
read_saif -input ../saif/filter_syn.saif -instance tb_fir/UUT -unit ns -scale 1

#create clock
create_clock -name CLK

report_power > ../report/clock_${period}/power_estimation.txt
