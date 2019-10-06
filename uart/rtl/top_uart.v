module	top_uart(
input	wire		clk,
input	wire		rst_n,
input	wire		rx,

output	wire		tx
);

wire	[7:0]	data;
wire		flag;

uart_rx	uart_rx_inst(
.clk	(clk),
.rst_n	(rst_n),
.rx	(rx), 

.po_data(data), 
.po_flag(flag) 
);

uart_tx	uart_tx_inst(
.clk	(clk),
.rst_n	(rst_n),
.pi_data(data), 
.pi_flag(flag), 

.tx     (tx)
);
endmodule