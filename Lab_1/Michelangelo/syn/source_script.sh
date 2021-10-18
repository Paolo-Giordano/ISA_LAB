
#remove old design
rm -f command.log default.svf
rm -r -f  work
rm ../netlist/*

mkdir work

#source the initialization script
source /software/scripts/init_synopsys_64.18

#start synopsys
dc_shell-xg-t

#echo "source compile_script.tlc" | dc_shell-xg-t

#compile design
#source compile_script.tlc


