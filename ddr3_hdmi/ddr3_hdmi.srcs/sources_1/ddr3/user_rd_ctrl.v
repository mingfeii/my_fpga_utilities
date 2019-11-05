module	user_rd_ctrl
#(
parameter	INIT_RD_BYTE_ADDR	=0,
parameter	MAX_RD_BYTE_ADDR	=2048
)
(
input	wire		sclk		,
input	wire		rst_n		,
input	wire		rd_start	,//cmd_en
input	wire[5:0]	rd_cmd_bl	,
input	wire[7:0]	c3_p3_rd_count	,

output	reg		c3_p3_rd_en	,
output	reg		c3_p3_cmd_en	,
output	reg[5:0]	c3_p3_cmd_bl	,
output	reg[27:0]	c3_p3_cmd_byte_addr,
output	reg		user_rd_end	
);

reg[6:0]	data_cnt		;

//data_cnt
always@(posedge	sclk)
if(rst_n==0)
	data_cnt	<=	0;
else if(c3_p3_rd_en==1)
	data_cnt	<=	data_cnt+1'b1;
else
	data_cnt	<=	0;

//c3_p3_rd_en
always@(posedge	sclk)
if(rst_n==0)
	c3_p3_rd_en	<=	0;
else if(data_cnt==c3_p3_cmd_bl)
	c3_p3_rd_en	<=	0;
else if(c3_p3_rd_count==c3_p3_cmd_bl+1)
	c3_p3_rd_en	<=	1;

//c3_p3_cmd_en
always@(posedge	sclk)
if(rst_n==0)
	c3_p3_cmd_en	<=	0;
else
	c3_p3_cmd_en	<=	rd_start;
	
//c3_p3_cmd_bl
always@(posedge	sclk)
if(rst_n==0)
	c3_p3_cmd_bl	<=	0;
else if(rd_start==1)
	c3_p3_cmd_bl	<=	rd_cmd_bl;

//c3_p3_cmd_byte_addr
always@(posedge	sclk)
if(rst_n==0)
	c3_p3_cmd_byte_addr	<=	INIT_RD_BYTE_ADDR;
else if(c3_p3_cmd_byte_addr==MAX_RD_BYTE_ADDR)
	c3_p3_cmd_byte_addr	<=	INIT_RD_BYTE_ADDR;
else if(c3_p3_cmd_en==1)
	c3_p3_cmd_byte_addr	<=	c3_p3_cmd_byte_addr+((c3_p3_cmd_bl+1)<<3);


//user_rd_end
always@(posedge	sclk)
if(rst_n==0)
	user_rd_end	<=	0;
else if(data_cnt==c3_p3_cmd_bl)
	user_rd_end	<=	1;	
else
	user_rd_end	<=	0;
	
endmodule