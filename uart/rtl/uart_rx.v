module	uart_rx(
input	wire		clk,
input	wire		rst_n,
input	wire		rx,//上位机传过来的1bit数据

output	reg[7:0]	po_data,//位拼接rx的8bit数据
output	reg		po_flag//标志po_data数据有效
);

reg		rx1;
reg		rx2;
reg		rx2_reg;
reg		rx_flag;
reg	[12:0]	cnt_baud;
reg		bit_flag;
reg	[3:0]	bit_cnt;

parameter	CNT_BAUD_MAX	=	5207;
parameter	CNT_HALF_BAUD_MAX=	2603;

//rx1,打第一拍，消除一级亚稳态
always@(posedge	clk	or	negedge	rst_n)
	if(rst_n==0)
		rx1	<=	1;
	else
		rx1	<=	rx;
//rx2,打第二拍，消除二级亚稳态
always@(posedge	clk	or	negedge	rst_n)
	if(rst_n==0)
		rx2	<=	1;
	else
		rx2	<=	rx1;
//rx2_reg,打第三拍，寻找第一个下降沿
always@(posedge	clk	or	negedge	rst_n)
	if(rst_n==0)
		rx2_reg	<=	1;
	else
		rx2_reg	<=	rx2;
//rx_flag,控制cnt_baud循环计数
always@(posedge	clk	or	negedge	rst_n)
	if(rst_n==0)
		rx_flag	<=	0;
	else if(rx2_reg==1&&rx2==0)
		rx_flag	<=	1;
	else if(bit_cnt==8)
		rx_flag	<=	0;
//cnt_baud,当rx_flag为1时,0-5207循环计数
always@(posedge	clk	or	negedge	rst_n)
	if(rst_n==0)
		cnt_baud	<=	0;
	else if(cnt_baud==CNT_BAUD_MAX)
		cnt_baud	<=	0;
	else if(bit_cnt==8&&bit_flag==1)
		cnt_baud	<=	0;
	else if(rx_flag==1)
		cnt_baud	<=	cnt_baud+1;
//bit_flag,代替了cnt_baud==2603条件,控制po_data取数
always@(posedge	clk	or	negedge	rst_n)
	if(rst_n==0)
		bit_flag	<=	0;
	else if(cnt_baud==CNT_HALF_BAUD_MAX)
		bit_flag	<=	1;
	else
		bit_flag	<=	0;
//bit_cnt,对bit_flag计数,0-8循环计数
always@(posedge	clk	or	negedge	rst_n)
	if(rst_n==0)
		bit_cnt	<=	0;
	else if(bit_flag==1)
		bit_cnt	<=	bit_cnt+1;
	else if(bit_cnt==8&&bit_flag==1)
		bit_cnt	<=	0;	
//po_data,对rx2进行位拼接的变量,在后8个bit_flag为1时取数
always@(posedge	clk	or	negedge	rst_n)
	if(rst_n==0)
		po_data	<=	0;
	else if(bit_cnt>=1&&bit_flag==1)
		po_data<={rx2,po_data[7:1]};
//po_flag,当拼接完8bit数据时,拉高一个clk的高电平
always@(posedge	clk	or	negedge	rst_n)
	if(rst_n==0)
		po_flag	<=	0;
	else if(bit_cnt==8)
		po_flag	<=	1;
	else
		po_flag	<=	0;

endmodule