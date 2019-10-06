.main clear
quit -sim

vlib work

vlog ./tb_top.v
vlog ./../design/*.v

vsim -voptargs=+acc work.tb_top

add wave /tb_top/top_uart_inst/uart_rx_inst/*

add wave /tb_top/top_uart_inst/uart_tx_inst/*

run 18ms
