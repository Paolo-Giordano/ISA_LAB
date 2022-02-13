onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_risc_v/clk
add wave -noupdate /tb_risc_v/rst_n
add wave -noupdate -divider -height 30 {instr mem}
add wave -noupdate -radix decimal /tb_risc_v/i_instr_mem/im_in_addr
add wave -noupdate /tb_risc_v/i_instr_mem/rom
add wave -noupdate /tb_risc_v/i_instr_mem/instr_label
add wave -noupdate /tb_risc_v/i_instr_mem/out_data
add wave -noupdate -divider -height 25 DECODE
add wave -noupdate /tb_risc_v/i_dut/i_decode_stage/dec_stage_in_instr
add wave -noupdate -divider immediate
add wave -noupdate -radix decimal /tb_risc_v/i_dut/i_decode_stage/i_imm_gen_id/ig_imm
add wave -noupdate /tb_risc_v/i_dut/i_decode_stage/i_imm_gen_id/ig_instr
add wave -noupdate /tb_risc_v/i_dut/i_decode_stage/i_imm_gen_id/instropcode
add wave -noupdate -divider {Reg File}
add wave -noupdate -radix decimal /tb_risc_v/i_dut/i_decode_stage/i_rf_id/rf_readadd1
add wave -noupdate -radix decimal /tb_risc_v/i_dut/i_decode_stage/i_rf_id/rf_readadd2
add wave -noupdate -radix decimal /tb_risc_v/i_dut/i_decode_stage/dec_stage_out_readdata1
add wave -noupdate -radix decimal /tb_risc_v/i_dut/i_decode_stage/dec_stage_out_readdata2
add wave -noupdate /tb_risc_v/i_dut/i_decode_stage/i_rf_id/rf_regwrite
add wave -noupdate /tb_risc_v/i_dut/i_decode_stage/i_rf_id/rf_writeadd
add wave -noupdate /tb_risc_v/i_dut/i_decode_stage/i_rf_id/rf_writedata
add wave -noupdate -radix decimal -expand -subitemconfig {/tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(0) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(1) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(2) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(3) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(4) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(5) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(6) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(7) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(8) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(9) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(10) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(11) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(12) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(13) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(14) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(15) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(16) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(17) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(18) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(19) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(20) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(21) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(22) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(23) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(24) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(25) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(26) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(27) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(28) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(29) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(30) {-radix decimal} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers(31) {-radix decimal}} /tb_risc_v/i_dut/i_decode_stage/i_rf_id/registers
add wave -noupdate -divider -height 25 EXECUTE
add wave -noupdate -radix decimal /tb_risc_v/i_dut/i_execution_stage/i_pc_adder/a_signed
add wave -noupdate -radix decimal /tb_risc_v/i_dut/i_execution_stage/i_pc_adder/b_signed
add wave -noupdate -radix decimal /tb_risc_v/i_dut/i_execution_stage/i_pc_adder/sum_signed
add wave -noupdate -radix decimal /tb_risc_v/i_dut/i_execution_stage/i_mux_alu_res/mux_out
add wave -noupdate -radix decimal /tb_risc_v/i_dut/i_execution_stage/i_alu/alu_out
add wave -noupdate -divider -height 25 {data memory}
add wave -noupdate -radix decimal /tb_risc_v/i_data_mem/dm_in_addr
add wave -noupdate /tb_risc_v/i_data_mem/dm_in_w_data
add wave -noupdate /tb_risc_v/i_data_mem/dm_in_memwrite
add wave -noupdate /tb_risc_v/i_data_mem/dm_in_memread
add wave -noupdate /tb_risc_v/i_data_mem/dm_out_r_data
add wave -noupdate /tb_risc_v/i_data_mem/data_mem
add wave -noupdate -divider {WRITE BACK}
add wave -noupdate -radix decimal /tb_risc_v/i_dut/i_final_mux/mux_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {329 ns} 0}
configure wave -namecolwidth 249
configure wave -valuecolwidth 202
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {67 ns} {295 ns}
