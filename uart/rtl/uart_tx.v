module	uart_tx(
input	wire		clk,
input	wire		rst_n,
input	wire	[7:0]	pi_data,//需要通过tx发送给上位机的
input	wire		pi_flag,//标志pi_data有效

output	reg		tx
);

reg	[7:0]	data_reg;
reg		tx_flag;
reg	[12:0]	cnt_baud;
reg		bit_flag;
reg	[3:0]	bit_cnt;

parameter	CNT_BAUD_MAX	=	5207;

//data_reg,数据缓存,避免上个模块输出变量发生变化而影响
always@(posedge	clk	or	negedge	rst_n)
	if(rst_n==0)
		data_reg	<=	8'b0;
	else if(pi_flag==1)
		data_reg	<=	pi_data;
//tx_flag,控制cnt_baud计数
always@(posedge	clk	or	negedge	rst_n)
	if(rst_n==0)
		tx_flag	<=	0;
	else if(pi_flag==1)
		tx_flag	<=	1;
	else if(bit_cnt==8&&bit_flag==1)
		tx_flag	<=	0;
//cnt_baud,当tx_flag为1时,cnt_baud计数,0-5207循环计数
always@(posedge	clk	or	negedge	rst_n)
	if(rst_n==0)
		cnt_baud	<=	0;
	else if(cnt_baud==CNT_BAUD_MAX)
		cnt_baud	<=	0;
	else if(tx_flag==1)
		cnt_baud	<=	cnt_baud+1;
//bit_flag,控制给tx赋值标志
always@(posedge	clk	or	negedge	rst_n)
	if(rst_n==0)
		bit_flag	<=	0;
	else if(cnt_baud==CNT_BAUD_MAX-1)
		bit_flag	<=	1;
	else
		bit_flag	<=	0;
//bit_cnt,对bit_flag计数，0-8循环计数
always@(posedge	clk	or	negedge	rst_n)
	if(rst_n==0)
		bit_cnt	<=	0;
	else if(bit_cnt==8&&bit_flag==1)
		bit_cnt	<=	0;
	else if(bit_flag==1)
		bit_cnt	<=	bit_cnt+1;
//tx
always@(posedge	clk	or	negedge	rst_n)
	if(rst_n==0)
		tx	<=	1;//空闲状态
	else if(pi_flag==1)
		tx	<=	0;//起始位
	else if(bit_cnt<=7&&bit_flag==1)
		tx	<=	data_reg[bit_cnt];//8个数据位
	else if(bit_cnt==8&&bit_flag==1)
		tx	<=	1;//停止位

endmodule