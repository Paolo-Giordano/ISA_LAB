rm -rf ./work
source /software/scripts/init_synopsys_64.18

vcd2saif -input ../vcd/filter_syn.vcd -output ../saif/filter_syn.saif

design_vision &
