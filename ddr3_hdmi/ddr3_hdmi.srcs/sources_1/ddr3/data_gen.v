module data_gen(
input	wire		sclk	,
input	wire		rst_n	,
input	wire		key_en	,

output	reg		wr_en	,
output	reg[127:0]	wr_data
);

reg[6:0]	data_cnt	;

//wr_en
always@(posedge	sclk)
if(rst_n==0)
	wr_en	<=	0;
else if(key_en==1)
	wr_en	<=	1;
else if(data_cnt==63)
	wr_en	<=	0;

//wr_data
always@(posedge	sclk)
if(rst_n==0)
	wr_data	<=	0;
else if(wr_en==1)
	wr_data<=	wr_data+128'h01010101010101010101010101010101;

//data_cnt
always@(posedge	sclk)
if(rst_n==0)
	data_cnt	<=	0;
else if(data_cnt==63)
	data_cnt	<=	0;
else if(wr_en==1)
	data_cnt<=	data_cnt+1;

endmodule
