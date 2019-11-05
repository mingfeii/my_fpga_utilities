//A7 DDR3 IPºËĞ´¿ØÖÆÄ£¿é
module a7_wr_ctrl(
input	wire		ui_clk		,
input	wire		rst_n		,
input	wire		a7_wr_start	,
input	wire[5:0]	a7_wr_bl	,
input	wire[27:0]	a7_wr_init_addr	,
input	wire		app_wdf_rdy	,
input	wire		app_rdy		,
input	wire[15:0]	a7_wr_mask	,
input	wire[127:0]	a7_wr_data	,

output	reg[27:0]	app_addr	,
output	wire		app_en		,
output	wire[2:0]	app_cmd		,
output	wire		app_wdf_en	,
output	wire		app_wdf_end	,
output	wire		data_req	,
output	reg		a7_wr_end	,
output	wire[127:0]	app_wdf_data	,
output	wire[15:0]	app_wdf_mask
);

reg[5:0]	wr_bl	;
reg		wr_flag	;
reg[5:0]	cnt	;

//wr_bl
always@(posedge	ui_clk)
if(rst_n==0)
	wr_bl	<=	0;
else if(a7_wr_start==1&&wr_flag==0)
	wr_bl	<=	a7_wr_bl;

//app_addr
always@(posedge	ui_clk)
if(rst_n==0)
	app_addr	<=	0;
else if(a7_wr_end==1)
	app_addr	<=	0;
else if(a7_wr_start==1)
	app_addr	<=	a7_wr_init_addr;
else if(app_en==1)
	app_addr	<=	app_addr+8;	
	
//wr_flag
always@(posedge	ui_clk)
if(rst_n==0)
	wr_flag	<=	0;
else if(a7_wr_start==1)
	wr_flag	<=	1;
else if(cnt==wr_bl&&app_en==1)
	wr_flag	<=	0;

//cnt
always@(posedge	ui_clk)
if(rst_n==0)
	cnt	<=	0;
else if(cnt==wr_bl&&app_en==1)
	cnt	<=	0;
else if(app_en==1)
	cnt	<=	cnt+1;

//app_en
assign	app_en	=	wr_flag&app_rdy&app_wdf_rdy;

//app_wdf_en
assign	app_wdf_en	=	app_en;

//app_wdf_end
assign	app_wdf_end	=	app_en;

//data_req
assign	data_req	=	app_en;

//a7_wr_end
always@(posedge	ui_clk)
if(rst_n==0)
	a7_wr_end	<=	0;
else if(cnt==wr_bl&&app_en==1)
	a7_wr_end	<=	1;
else 
	a7_wr_end	<=	0;

//app_wdf_data
assign	app_wdf_data	=	a7_wr_data;

//app_wdf_mask
assign	app_wdf_mask	=	a7_wr_mask;

//app_cmd
assign	app_cmd		=	0;


endmodule
