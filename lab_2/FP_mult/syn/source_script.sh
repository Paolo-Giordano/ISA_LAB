#!/bin/bash

#remove old design
rm -f command.log default.svf filenames.log
rm -r -f  work/*

#source the initialization script
source /software/scripts/init_synopsys_64.18

#start synopsys
design_vision 




