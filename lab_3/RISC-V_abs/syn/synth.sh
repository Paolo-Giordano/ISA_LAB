
source /software/scripts/init_synopsys_64.18

rm command.log default.svf -r work


mkdir work

vcd2saif -input ../vcd/RISC_V_syn.vcd -output ../saif/RISC_V_syn.saif

dc_shell-xg-t
