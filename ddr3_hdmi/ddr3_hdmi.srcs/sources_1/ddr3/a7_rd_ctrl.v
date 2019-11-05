//A7 DDR3 IPºË¶Á¿ØÖÆÄ£¿é
module a7_rd_ctrl(
input	wire		ui_clk		,
input	wire		rst_n		,
input	wire		a7_rd_start	,
input	wire[5:0]	a7_rd_bl	,
input	wire[27:0]	a7_rd_init_addr	,
input	wire		app_rdy		,
input	wire		app_rd_data_valid	,
input	wire[127:0]	app_rd_data	,

output	reg[27:0]	app_addr	,
output	reg		app_en		,
output	wire[2:0]	app_cmd		,
output	reg		a7_rd_end	,
output	reg[127:0]	a7_rd_data	,
output	reg		a7_rd_data_valid
);

reg[5:0]	rd_bl	;
reg[5:0]	cmd_cnt	;
reg[5:0]	data_cnt;

//rd_bl
always@(posedge	ui_clk)
if(rst_n==0)
	rd_bl	<=	0;
else if(a7_rd_start==1)
	rd_bl	<=	a7_rd_bl;

//app_addr
always@(posedge	ui_clk)
if(rst_n==0)
	app_addr	<=	0;
else if(a7_rd_end==1)
	app_addr	<=	0;
else if(a7_rd_start==1)
	app_addr	<=	a7_rd_init_addr;
else if(app_en==1&&app_rdy==1)
	app_addr	<=	app_addr+8;	
	

//cmd_cnt
always@(posedge	ui_clk)
if(rst_n==0)
	cmd_cnt	<=	0;
else if(cmd_cnt==rd_bl&&app_en==1&&app_rdy==1)
	cmd_cnt	<=	0;
else if(app_en==1&&app_rdy==1)
	cmd_cnt	<=	cmd_cnt+1;

//app_en
always@(posedge	ui_clk)
if(rst_n==0)
	app_en	<=	0;
else if(cmd_cnt==rd_bl&&app_en==1&&app_rdy==1)
	app_en	<=	0;
else if(a7_rd_start==1)
	app_en	<=	1;

//data_cnt
always@(posedge	ui_clk)
if(rst_n==0)
	data_cnt	<=	0;
else if(data_cnt==rd_bl&&app_rd_data_valid==1)
	data_cnt	<=	0;
else if(app_rd_data_valid==1)
	data_cnt	<=	data_cnt+1;	

//a7_rd_end
always@(posedge	ui_clk)
if(rst_n==0)
	a7_rd_end	<=	0;
else if(data_cnt==rd_bl&&app_rd_data_valid==1)
	a7_rd_end	<=	1;
else 
	a7_rd_end	<=	0;

//a7_rd_data
always@(posedge	ui_clk)
if(rst_n==0)
	a7_rd_data	<=	0;
else 
	a7_rd_data	<=	app_rd_data;
	
//a7_rd_data_valid
always@(posedge	ui_clk)
if(rst_n==0)
	a7_rd_data_valid	<=	0;
else 
	a7_rd_data_valid	<=	app_rd_data_valid;

//app_cmd
assign	app_cmd		=	app_en;

endmodule
