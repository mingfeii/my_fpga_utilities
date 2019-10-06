Run do文件的一些常用命令

#打开现有工程

project open C:/Users/jayash/Desktop/sim/ImageProcess

#新建一个库

vlib my_lib

#将其映射到work

vmap my_lib work

#删除制定库

vmap -del my_lib

#添加指定设计文件

project addfile src/Verilog/test.v

#编译工程内所有文件

project compileall

#编译指定verilog文件

vlog src/Verilog/test.v

#编译指定的vhdl文件，同时检查可综合性

vcom –check_synthesis src/video_cap.vhd

 

##仿真work库下面的test_tb实例，同时调用220model_ver库，不再进行任何优化，仿真分辨率1ns。

vsim –t 1ns –L 220model_ver –gui –novopt work.test_tb

#取消warning，例如‘x’，‘u’，‘z’信号的警告，对提高编译速度很有帮助

set StdarithNoWarning 1

#查看object

View objects

#查看局部变量

View locals

#查看source

View source

#添加模块顶层所有信号到波形图

add wave*

#10进制无符号显示

Radix usigned

#16进制显示

Radix hex

#重新进行仿真

Restart

#开始仿真

Run

#仿真指定时间

Run 1ms

#时钟激励50ns周期 占空比50%

Force –repeat 50 clk 0 0，1 25

#指定信号置0

Force rst_n 0

#指定信号置1

Force rst_n 1

#指定信号赋值

Force din_a 123

Force din_b 39
