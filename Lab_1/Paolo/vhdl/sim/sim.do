vsim -t ns work.tb_fir
add wave tb_fir/UUT/*
config wave -signalnamewidth 1
run 1 us
