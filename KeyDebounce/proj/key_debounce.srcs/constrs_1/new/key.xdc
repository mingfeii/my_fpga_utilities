create_clock -period 20.000 -name clk_i [get_ports clk_i]
set_property PACKAGE_PIN V4 [get_ports clk_i]
set_property IOSTANDARD LVCMOS15 [get_ports clk_i]

set_property PACKAGE_PIN N13 [get_ports rst_n_i]
set_property IOSTANDARD LVCMOS15 [get_ports rst_n_i]

set_property PACKAGE_PIN R14 [get_ports key_i]
set_property IOSTANDARD LVCMOS15 [get_ports key_i]

set_property PACKAGE_PIN E21 [get_ports {led_o[0]}]
set_property PACKAGE_PIN D21 [get_ports {led_o[1]}]
set_property PACKAGE_PIN E22 [get_ports {led_o[2]}]
set_property PACKAGE_PIN D22 [get_ports {led_o[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_o[*]}]
