//vgaģ��  1024x768@60Hz  ʱ��65MHz
module	vga(
input	wire		vga_clk		,
input	wire		s_rst_n		,
input	wire[23:0]	pi_rgb_data	,

output	wire		h_sync		,	
output	wire		v_sync		,

output	wire		de		,//��Ч����
output	wire		po_start_flag	,//һ��ͼ��Ŀ�ʼʱ��
	
output	reg[7:0]	r		,
output	reg[7:0]	g		,
output	reg[7:0]	b		
);

reg[10:0]	h_cnt;	
reg[10:0]	v_cnt;	

parameter	
		H_ALL	=	1344,	//�������ص�
		H_SYNC	=	136,	//��ͬ��ʱ��	
		H_BP	=	160,	//�к��ʱ��
		H_LB	=	0,	//����߿�ʱ��
		H_ACT	=	1024,	//����Ч�������ص�
		H_RB	=	0,	//���ұ߿�ʱ��	
		H_FP	=	24,	//��ǰ��ʱ��
		V_ALL	=	806,	//����������      
		V_SYNC	=	6,	//��ͬ��ʱ��	  	
		V_BP	=	29,	//�к��ʱ��      
		V_TB	=	0,	//���ϱ߿�ʱ��    
		V_ACT	=	768,	//����Ч��������
		V_BB	=	0,	//���ұ߿�ʱ��	  
		V_FP	=	3;      //��ǰ��ʱ�� 

//po_start_flagһ��ͼ��Ŀ�ʼʱ��		
assign	po_start_flag	=(h_cnt==H_SYNC&&v_cnt==V_SYNC)?1'b1:1'b0;

//��������ͬ��
assign	h_sync	=	(h_cnt<=H_SYNC-1'b1)?1'b1:1'b0;
assign	v_sync	=	(v_cnt<=V_SYNC-1'b1)?1'b1:1'b0;

/********************************��ɨ�������*******************************/		
always@(posedge	vga_clk	or	negedge	s_rst_n)
	if(s_rst_n==1'b0)
		h_cnt	<=	10'd0;
	else if(h_cnt==H_ALL-1'b1)
		h_cnt	<=	10'd0;
	else
		h_cnt	<=	h_cnt+1'b1;


/*******��ɨ�������********/		
always@(posedge	vga_clk	or	negedge	s_rst_n)
	if(s_rst_n==1'b0)
		v_cnt	<=	10'd0;
	else if(h_cnt==(H_ALL-1'b1)&&v_cnt==(V_ALL-1'b1))
		v_cnt	<=	10'd0;
	else if(h_cnt==(H_ALL-1'b1))
		v_cnt	<=	v_cnt+1'b1;

/*********��ʾɫ��**********/		
always@(posedge	vga_clk	or	negedge	s_rst_n)
	if(s_rst_n==1'b0)
		{r,g,b}	<=	24'h0;
	else if(h_cnt>=(H_SYNC+H_BP+H_LB)&&h_cnt<(H_SYNC+H_BP+H_LB+H_ACT)&&
		v_cnt>=(V_SYNC+V_BP+V_TB-1'b1)&&v_cnt<(V_SYNC+V_BP+V_TB+V_ACT-1'b1))
		{r,g,b}	<=	pi_rgb_data;
	else
		{r,g,b}	<=	24'h00;

assign	de=(h_cnt>=(H_SYNC+H_BP+H_LB)&&h_cnt<(H_SYNC+H_BP+H_LB+H_ACT)
		&&v_cnt>=(V_SYNC+V_BP+V_TB-1'b1)&&v_cnt<(V_SYNC+V_BP+V_TB+V_ACT-1'b1))?1'b1:1'b0;

endmodule