
#remove old design
rm -f command.log default.svf
rm -r -f  work
rm ../saif/myfir_syn.saif

mkdir work

#source the initialization script
source /software/scripts/init_synopsys_64.18

#convert vcd file in saif one
vcd2saif -input ../vcd/myfir_syn.vcd -output ../saif/myfir_syn.saif

#start synopsys
dc_shell-xg-t

#echo "source compile_script.tlc" | dc_shell-xg-t

#compile design
#source compile_script.tlc


