module	user_wr_ctrl
#(
parameter	INIT_WR_BYTE_ADDR	=0,
parameter	MAX_WR_BYTE_ADDR	=2048
)
(
input	wire		sclk		,
input	wire		rst_n		,
input	wire		c3_p2_wr_empty	,
input	wire		wr_data_en	,
input	wire[127:0]	wr_data		,

output	reg		c3_p2_wr_en	,
output	reg[127:0]	c3_p2_wr_data	,
output	wire[15:0]	c3_p2_wr_mask	,
output	reg		c3_p2_cmd_en	,
output	reg[5:0]	c3_p2_cmd_bl	,
output	reg[27:0]	c3_p2_cmd_byte_addr,
output	reg		user_wr_end	
);

reg[6:0]	data_cnt		;
reg		c3_p2_wr_empty_reg	;

//ila_0	ila_0_inst(
//.clk(sclk		), // input wire clk
//
//.probe0({wr_data_en,c3_p2_cmd_en,c3_p2_cmd_bl,c3_p2_wr_en,user_wr_end,c3_p2_wr_empty}) // input wire [299:0] probe0
//);
//data_cnt
always@(posedge	sclk)
if(rst_n==0)
	data_cnt	<=	0;
else if(wr_data_en==1)
	data_cnt	<=	data_cnt+1'b1;
else
	data_cnt	<=	0;

//c3_p2_wr_en
always@(posedge	sclk)
if(rst_n==0)
	c3_p2_wr_en	<=	0;
else 
	c3_p2_wr_en	<=	wr_data_en;

//c3_p2_wr_data
always@(posedge	sclk)
if(rst_n==0)
	c3_p2_wr_data	<=	0;
else 
	c3_p2_wr_data	<=	wr_data;

//c3_p2_wr_mask
assign	c3_p2_wr_mask	=	0;

//c3_p2_cmd_en
always@(posedge	sclk)
if(rst_n==0)
	c3_p2_cmd_en	<=	0;
else if(wr_data_en==0&&c3_p2_wr_en==1)
	c3_p2_cmd_en	<=	1;
else
	c3_p2_cmd_en	<=	0;
	
//c3_p2_cmd_bl
always@(posedge	sclk)
if(rst_n==0)
	c3_p2_cmd_bl	<=	0;
else if(wr_data_en==0&&c3_p2_wr_en==1)
	c3_p2_cmd_bl	<=	data_cnt-1;
else
	c3_p2_cmd_bl	<=	0;

//c3_p2_cmd_byte_addr
always@(posedge	sclk)
if(rst_n==0)
	c3_p2_cmd_byte_addr	<=	INIT_WR_BYTE_ADDR;
else if(c3_p2_cmd_byte_addr==MAX_WR_BYTE_ADDR)
	c3_p2_cmd_byte_addr	<=	INIT_WR_BYTE_ADDR;
else if(c3_p2_cmd_en==1)
	c3_p2_cmd_byte_addr	<=	c3_p2_cmd_byte_addr+((c3_p2_cmd_bl+1)<<3);

//c3_p2_wr_empty_reg
always@(posedge	sclk)
if(rst_n==0)
	c3_p2_wr_empty_reg	<=	1;
else 
	c3_p2_wr_empty_reg	<=	c3_p2_wr_empty;

//user_wr_end
//c3_p2_wr_empty_reg
always@(posedge	sclk)
if(rst_n==0)
	user_wr_end	<=	0;
else if(c3_p2_wr_empty_reg==0&&c3_p2_wr_empty==1)
	user_wr_end	<=	1;	
else
	user_wr_end	<=	0;
	
endmodule