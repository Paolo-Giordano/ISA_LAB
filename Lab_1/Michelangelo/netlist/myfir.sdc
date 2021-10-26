###################################################################

# Created by write_sdc on Thu Oct 21 11:47:00 2021

###################################################################
set sdc_version 2.1

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current mA
set_load -pin_load 3.40189 [get_ports MYFIR_OUT_VOUT]
set_load -pin_load 3.40189 [get_ports {MYFIR_OUT_DOUT[8]}]
set_load -pin_load 3.40189 [get_ports {MYFIR_OUT_DOUT[7]}]
set_load -pin_load 3.40189 [get_ports {MYFIR_OUT_DOUT[6]}]
set_load -pin_load 3.40189 [get_ports {MYFIR_OUT_DOUT[5]}]
set_load -pin_load 3.40189 [get_ports {MYFIR_OUT_DOUT[4]}]
set_load -pin_load 3.40189 [get_ports {MYFIR_OUT_DOUT[3]}]
set_load -pin_load 3.40189 [get_ports {MYFIR_OUT_DOUT[2]}]
set_load -pin_load 3.40189 [get_ports {MYFIR_OUT_DOUT[1]}]
set_load -pin_load 3.40189 [get_ports {MYFIR_OUT_DOUT[0]}]
create_clock [get_ports MYFIR_IN_CLK]  -name MY_CLK  -period 12.68  -waveform {0 6.34}
set_clock_uncertainty 0.07  [get_clocks MY_CLK]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports MYFIR_IN_RST_n]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b0[8]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b0[7]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b0[6]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b0[5]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b0[4]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b0[3]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b0[2]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b0[1]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b0[0]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b1[8]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b1[7]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b1[6]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b1[5]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b1[4]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b1[3]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b1[2]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b1[1]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b1[0]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b2[8]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b2[7]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b2[6]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b2[5]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b2[4]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b2[3]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b2[2]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b2[1]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b2[0]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b3[8]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b3[7]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b3[6]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b3[5]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b3[4]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b3[3]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b3[2]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b3[1]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b3[0]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b4[8]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b4[7]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b4[6]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b4[5]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b4[4]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b4[3]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b4[2]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b4[1]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b4[0]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b5[8]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b5[7]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b5[6]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b5[5]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b5[4]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b5[3]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b5[2]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b5[1]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b5[0]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b6[8]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b6[7]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b6[6]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b6[5]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b6[4]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b6[3]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b6[2]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b6[1]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b6[0]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b7[8]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b7[7]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b7[6]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b7[5]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b7[4]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b7[3]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b7[2]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b7[1]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b7[0]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b8[8]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b8[7]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b8[6]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b8[5]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b8[4]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b8[3]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b8[2]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b8[1]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b8[0]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b9[8]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b9[7]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b9[6]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b9[5]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b9[4]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b9[3]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b9[2]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b9[1]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b9[0]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b10[8]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b10[7]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b10[6]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b10[5]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b10[4]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b10[3]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b10[2]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b10[1]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_b10[0]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports MYFIR_IN_VIN]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_DIN[8]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_DIN[7]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_DIN[6]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_DIN[5]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_DIN[4]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_DIN[3]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_DIN[2]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_DIN[1]}]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_IN_DIN[0]}]
set_output_delay -clock MY_CLK  -max 0.5  [get_ports MYFIR_OUT_VOUT]
set_output_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_OUT_DOUT[8]}]
set_output_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_OUT_DOUT[7]}]
set_output_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_OUT_DOUT[6]}]
set_output_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_OUT_DOUT[5]}]
set_output_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_OUT_DOUT[4]}]
set_output_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_OUT_DOUT[3]}]
set_output_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_OUT_DOUT[2]}]
set_output_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_OUT_DOUT[1]}]
set_output_delay -clock MY_CLK  -max 0.5  [get_ports {MYFIR_OUT_DOUT[0]}]
