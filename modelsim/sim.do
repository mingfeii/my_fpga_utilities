#退出当前仿真

quit -sim

vlib work

#编译修改后的文件，我这里把设计文件和仿真文件分开放了，所以写两个。

vlog "../Src/*.v"
vlog "../Sim/*.v"

#开始仿真

vsim -voptargs=+acc work.tb_top

#添加指定信号
#添加顶层所有的信号
# Set the window types
# 打开波形窗口

view wave
view structure

# 打开信号窗口

view signals

# 添加波形模板

add wave /tb_top/top_uart_inst/uart_rx_inst/*
add wave /tb_top/top_uart_inst/uart_tx_inst/*


.main clear

#运行xxms

run 100us
