#option to use pattern list
shopt -s extglob
rm -rfv !("design.globals"|"innovus.cmd"|"pow_consum.cmd"|"script.sh"|"mmm_design.tcl")

source /software/scripts/init_innovus17.11 
innovus
innovus 1>source design.globals
innovus 1>source innovus.cmd
