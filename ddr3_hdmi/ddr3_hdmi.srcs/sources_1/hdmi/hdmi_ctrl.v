module hdmi_ctrl(
input wire		clk_65MHz	  ,
input wire		clk_325MHz	,
input	wire		rst_n		    ,
input wire [23:0] pi_rgb_data,

output  wire po_start_flag,
output	wire		r_ser_p		,
output  wire    de        ,
output	wire		r_ser_n		,
output	wire		g_ser_p		,
output	wire		g_ser_n		,
output	wire		b_ser_p		,
output	wire		b_ser_n		,
output	wire		clk_ser_p	,
output	wire		clk_ser_n	,
output	wire		hdmi_en
);


wire		h_sync		;	
wire		v_sync		;	                                       
		                                
wire[7:0]	r		;	
wire[7:0]	g		;	
wire[7:0]	b		;	
wire[9:0]	r_10bit		;	
wire[9:0]	g_10bit		;	
wire[9:0]	b_10bit		;	


//vgaʵ����
vga	vga_inst(
.vga_clk	(clk_65MHz	),
.s_rst_n	(rst_n		),
.pi_rgb_data	(pi_rgb_data	),

.h_sync		(h_sync		),	
.v_sync		(v_sync		),

.de		(de		),//��Ч����
.po_start_flag	(po_start_flag),//һ��ͼ��Ŀ�ʼʱ��

.r		(r		),
.g		(g		),
.b		(b		)
);

//encode
encode	encode_r (
.clkin	(clk_65MHz	),// pixel clock input
.rstin	(~rst_n		),// async. reset input (active high)
.din	(r		),// data inputs: expect registered
.c0	(0		),// c0 input
.c1	(0		),// c1 input
.de	(de		),// de input
.dout	(r_10bit	)// data outputs
);
encode	encode_g (
.clkin	(clk_65MHz	),// pixel clock input
.rstin	(~rst_n		),// async. reset input (active high)
.din	(g		),// data inputs: expect registered
.c0	(0		),// c0 input
.c1	(0		),// c1 input
.de	(de		),// de input
.dout	(g_10bit	)// data outputs
);
encode	encode_b (
.clkin	(clk_65MHz	),// pixel clock input
.rstin	(~rst_n		),// async. reset input (active high)
.din	(b		),// data inputs: expect registered
.c0	(h_sync		),// c0 input
.c1	(v_sync		),// c1 input
.de	(de		),// de input
.dout	(b_10bit	)// data outputs
);

//par2ser
par2ser	par2ser_r(
.clk_1x	(clk_65MHz	),
.clk_5x	(clk_325MHz	),
.rst_n	(rst_n		),
.par_dat(r_10bit	),

.ser_p	(r_ser_p	),	
.ser_n	(r_ser_n	)
);
par2ser	par2ser_g(
.clk_1x	(clk_65MHz	),
.clk_5x	(clk_325MHz	),
.rst_n	(rst_n		),
.par_dat(g_10bit	),

.ser_p	(g_ser_p	),	
.ser_n	(g_ser_n	)
);
par2ser	par2ser_b(
.clk_1x	(clk_65MHz	),
.clk_5x	(clk_325MHz	),
.rst_n	(rst_n		),
.par_dat(b_10bit	),

.ser_p	(b_ser_p	),	
.ser_n	(b_ser_n	)
);
par2ser	par2ser_clk(
.clk_1x	(clk_65MHz	),
.clk_5x	(clk_325MHz	),
.rst_n	(rst_n		),
.par_dat(992		),

.ser_p	(clk_ser_p	),	
.ser_n	(clk_ser_n	)
);

assign	hdmi_en	=	1;

endmodule
