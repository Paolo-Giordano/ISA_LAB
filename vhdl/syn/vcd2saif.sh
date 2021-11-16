rm -rf ./work
source /software/scripts/init_synopsys_64.18

vcd2saif -input ../vcd/filter_opt_syn.vcd -output ../saif/filter_opt_syn.saif

design_vision &
