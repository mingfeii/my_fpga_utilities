module	debounce(
input	wire	sclk,
input	wire	rst_n,
input	wire	key,

output	reg	po_key_flag
);

reg[19:0]	key_cnt;

reg		cnt_flag;

parameter	CNT_END	=	999999;



/***********产生key_cnt************/	
always@(posedge	sclk	or	negedge	rst_n)
	if(rst_n==1'b0)
		key_cnt	<=	19'b0;
	else if(key==1'b0)
		key_cnt	<=	key_cnt+1'b1;
	else
		key_cnt	<=	19'b0;

/**********产生cnt_flag***********/	
always@(posedge	sclk	or	negedge	rst_n)
	if(rst_n==1'b0)
		cnt_flag	<=	1'b0;
	else if(key==1'b1)
		cnt_flag	<=	1'b0;
	else if(key_cnt==CNT_END)
		cnt_flag	<=	1'b1;
	
		
/********产生key_flag*********/	
always@(posedge	sclk	or	negedge	rst_n)
	if(rst_n==1'b0)
		po_key_flag	<=	1'b0;
	else if(key_cnt==CNT_END&&cnt_flag==1'b0)
		po_key_flag	<=	1'b1;
	else
		po_key_flag	<=	1'b0;

endmodule
		
	