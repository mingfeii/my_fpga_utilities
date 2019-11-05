module arbit(
input	wire		ui_clk		,
input	wire		rst_n		,
input	wire		c3_p2_cmd_empty	,
input	wire		c3_p3_cmd_empty	,
input	wire		c3_p4_cmd_empty	,
input	wire		a7_wr_end	,	
input	wire		a7_rd1_end	,
input	wire		a7_rd2_end	,

output	reg		a7_wr_start	,
output	reg		a7_rd1_start	,
output	reg		a7_rd2_start	,
output	reg[4:0]	state		
);


reg[1:0]	cnt		;
reg		wr_flag		;
reg		rd1_flag	;
reg		rd2_flag	;

parameter	IDLE	=	5'b00001;
parameter	ARBIT	=	5'b00010;
parameter	WR	=	5'b00100;
parameter	RD1	=	5'b01000;
parameter	RD2	=	5'b10000;

//cnt
always@(posedge	ui_clk)
if(rst_n==0) 
	cnt	<=	0;
else if(cnt==2)
	cnt	<=	0;
else
	cnt	<=	cnt+1;

//state
always@(posedge	ui_clk)
if(rst_n==0) 
	state	<=	IDLE;
else case(state)
IDLE:
	state	<=	ARBIT;
ARBIT:
if(cnt==0&&c3_p2_cmd_empty==0)
	state	<=	WR;
else if(cnt==1&&c3_p3_cmd_empty==0)
	state	<=	RD1;
else if(cnt==2&&c3_p4_cmd_empty==0)
	state	<=	RD2;
WR:
if(a7_wr_end==1)
	state	<=	ARBIT;
RD1:
if(a7_rd1_end==1)
	state	<=	ARBIT;
RD2:
if(a7_rd2_end==1)
	state	<=	ARBIT;
default:state	<=	IDLE;
endcase

//wr_flag
always@(posedge	ui_clk)
if(rst_n==0) 
	wr_flag	<=	0;
else if(a7_wr_end==1)
	wr_flag	<=	0;
else if(state==WR)
	wr_flag	<=	1;
	
//rd1_flag
always@(posedge	ui_clk)
if(rst_n==0) 
	rd1_flag	<=	0;
else if(a7_rd1_end==1)
	rd1_flag	<=	0;
else if(state==RD1)
	rd1_flag	<=	1;

//rd2_flag
always@(posedge	ui_clk)
if(rst_n==0) 
	rd2_flag	<=	0;
else if(a7_rd2_end==1)
	rd2_flag	<=	0;
else if(state==RD2)
	rd2_flag	<=	1;

//a7_wr_start
always@(posedge	ui_clk)
if(rst_n==0) 
	a7_wr_start	<=	0;
else if(state==WR&&wr_flag==0)
	a7_wr_start	<=	1;
else 
	a7_wr_start	<=	0;

//a7_rd1_start
always@(posedge	ui_clk)
if(rst_n==0) 
	a7_rd1_start	<=	0;
else if(state==RD1&&rd1_flag==0)
	a7_rd1_start	<=	1;
else 
	a7_rd1_start	<=	0;

//a7_rd2_start
always@(posedge	ui_clk)
if(rst_n==0) 
	a7_rd2_start	<=	0;
else if(state==RD2&&rd2_flag==0)
	a7_rd2_start	<=	1;
else 
	a7_rd2_start	<=	0;
		
endmodule
