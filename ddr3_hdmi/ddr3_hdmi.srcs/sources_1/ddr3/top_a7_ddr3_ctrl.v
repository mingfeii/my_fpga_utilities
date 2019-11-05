module top_a7_ddr3_ctrl(
input	wire		sclk		,
input	wire		rst_n		,
input	wire		key		,
output	wire		led		,

//ddr3
// Inouts
inout [15:0]		ddr3_dq		,
inout [1:0]		ddr3_dqs_n	,
inout [1:0]		ddr3_dqs_p	,
// Outputs
output [13:0]		ddr3_addr	,
output [2:0]		ddr3_ba		,
output			ddr3_ras_n	,
output			ddr3_cas_n	,
output			ddr3_we_n	,
output			ddr3_reset_n	,
output [0:0]		ddr3_ck_p	,
output [0:0]		ddr3_ck_n	,
output [0:0]		ddr3_cke	,
output [0:0]		ddr3_cs_n	,
output [1:0]		ddr3_dm		,
output [0:0]		ddr3_odt
);

wire		init_calib_complete;

//用户端接口
wire		c3_p2_cmd_en	;
wire[2:0]	c3_p2_cmd_instr	;
wire[5:0]	c3_p2_cmd_bl	;
wire[27:0]	c3_p2_cmd_addr	;
wire		c3_p2_cmd_empty	;
wire		c3_p2_cmd_full	;
                         
wire		c3_p2_wr_en	;
wire[15:0]	c3_p2_wr_mask	;
wire[127:0]	c3_p2_wr_data	;
wire		c3_p2_wr_full	;
wire		c3_p2_wr_empty	;
wire[6:0]	c3_p2_wr_count	;
                           
wire		c3_p3_cmd_en	;
wire[2:0]	c3_p3_cmd_instr	;
wire[5:0]	c3_p3_cmd_bl	;
wire[27:0]	c3_p3_cmd_addr	;
wire		c3_p3_cmd_empty	;
wire		c3_p3_cmd_full	;

wire		c3_p3_rd_en	;
wire [127:0]	c3_p3_rd_data	;
wire		c3_p3_rd_full	;
wire		c3_p3_rd_empty	;
wire [7:0]	c3_p3_rd_count	;
                     

wire		c3_p4_cmd_en	;
wire[2:0]	c3_p4_cmd_instr	;
wire[5:0]	c3_p4_cmd_bl	;
wire[27:0]	c3_p4_cmd_addr	;
wire		c3_p4_cmd_empty	;
wire		c3_p4_cmd_full	;

wire		c3_p4_rd_en	;
wire [127:0]	c3_p4_rd_data	;
wire		c3_p4_rd_full	;
wire		c3_p4_rd_empty	;
wire [7:0]	c3_p4_rd_count	;

wire		user_wr_end	;
wire		user_rd_end1	;
wire		user_rd_end2	;
wire		clk_200MHz	;
wire		clk_100MHz	;

wire		wr_data_en	;
wire[127:0]	wr_data		;
wire		key_en		;

assign	led	=	&c3_p3_rd_data&c3_p4_rd_data&c3_p3_rd_en&c3_p4_rd_en;


ila_0	ila_0_inst(
.clk(clk_100MHz		), // input wire clk

.probe0({wr_data_en,c3_p2_cmd_en,c3_p2_cmd_bl,c3_p2_wr_en,c3_p4_rd_count,user_wr_end,c3_p2_wr_empty,init_calib_complete,key_en,c3_p3_rd_data,c3_p3_rd_en,c3_p3_rd_count,c3_p3_cmd_bl}) // input wire [299:0] probe0
);

clk_wiz_0	clk_wiz_0_inst
(
// Clock out ports
.clk_out1	(clk_200MHz	),// output clk_out1
.clk_out2	(clk_100MHz	),// output clk_out2
// Clock in ports
.clk_in1	(sclk		)// input clk_in1
);      

debounce	debounce_inst(
.sclk	(clk_100MHz	),
.rst_n	(rst_n		),
.key	(key		),

.po_key_flag(key_en	)
);

data_gen	data_gen_inst(
.sclk	(clk_100MHz	),
.rst_n	(rst_n		),
.key_en	(key_en		),

.wr_en	(wr_data_en	),
.wr_data(wr_data	)
);

//user_wr_ctrl
user_wr_ctrl
#(
.INIT_WR_BYTE_ADDR	(0	),
.MAX_WR_BYTE_ADDR	(2048	)
)
user_wr_ctrl_inst(
.sclk		(clk_100MHz		),
.rst_n		(init_calib_complete	),
.c3_p2_wr_empty	(c3_p2_wr_empty		),
.wr_data_en	(wr_data_en		),
.wr_data	(wr_data		),

.c3_p2_wr_en	(c3_p2_wr_en		),
.c3_p2_wr_data	(c3_p2_wr_data		),
.c3_p2_wr_mask	(c3_p2_wr_mask		),
.c3_p2_cmd_en	(c3_p2_cmd_en		),
.c3_p2_cmd_bl	(c3_p2_cmd_bl		),
.c3_p2_cmd_byte_addr(c3_p2_cmd_addr	),
.user_wr_end	(user_wr_end		)
);

//user_rd_ctrl
user_rd_ctrl
#(
.INIT_RD_BYTE_ADDR	(0	),
.MAX_RD_BYTE_ADDR	(2048	)
)
user_rd_ctrl_inst1(
.sclk		(clk_100MHz		),
.rst_n		(init_calib_complete	),
.rd_start	(user_wr_end		),//cmd_en
.rd_cmd_bl	(63			),
.c3_p3_rd_count	(c3_p3_rd_count		),

.c3_p3_rd_en	(c3_p3_rd_en		),
.c3_p3_cmd_en	(c3_p3_cmd_en		),
.c3_p3_cmd_bl	(c3_p3_cmd_bl		),
.c3_p3_cmd_byte_addr(c3_p3_cmd_addr	),
.user_rd_end	(user_rd_end1		)
);

//user_rd_ctrl
user_rd_ctrl
#(
.INIT_RD_BYTE_ADDR	(0	),
.MAX_RD_BYTE_ADDR	(2048	)
)
user_rd_ctrl_inst2(
.sclk		(clk_100MHz		),
.rst_n		(init_calib_complete	),
.rd_start	(user_wr_end		),//cmd_en
.rd_cmd_bl	(63			),
.c3_p3_rd_count	(c3_p4_rd_count		),

.c3_p3_rd_en	(c3_p4_rd_en		),
.c3_p3_cmd_en	(c3_p4_cmd_en		),
.c3_p3_cmd_bl	(c3_p4_cmd_bl		),
.c3_p3_cmd_byte_addr(c3_p4_cmd_addr	),
.user_rd_end	(user_rd_end2		)
);

//A7 IP实例化
A7_DDR3_CTRL	A7_DDR3_CTRL_inst(
.clk_200MHz		(clk_200MHz		),
.rst_n			(rst_n			),

.init_calib_complete	(init_calib_complete	),

//用户端接口
.c3_p2_cmd_clk		(clk_100MHz	        ),
.c3_p2_cmd_en		(c3_p2_cmd_en	        ),
.c3_p2_cmd_instr	(c3_p2_cmd_instr	),
.c3_p2_cmd_bl		(c3_p2_cmd_bl	        ),
.c3_p2_cmd_addr		(c3_p2_cmd_addr	        ),
.c3_p2_cmd_empty	(c3_p2_cmd_empty	),
.c3_p2_cmd_full		(c3_p2_cmd_full	        ),
                                   
.c3_p2_wr_clk		(clk_100MHz	        ),
.c3_p2_wr_en		(c3_p2_wr_en	        ),
.c3_p2_wr_mask		(c3_p2_wr_mask	        ),
.c3_p2_wr_data		(c3_p2_wr_data	        ),
.c3_p2_wr_full		(c3_p2_wr_full	        ),
.c3_p2_wr_empty		(c3_p2_wr_empty	        ),
.c3_p2_wr_count		(c3_p2_wr_count	        ),

.c3_p3_cmd_clk		(clk_100MHz	        ),
.c3_p3_cmd_en		(c3_p3_cmd_en	        ),
.c3_p3_cmd_instr	(c3_p3_cmd_instr	),
.c3_p3_cmd_bl		(c3_p3_cmd_bl	        ),
.c3_p3_cmd_addr		(c3_p3_cmd_addr	        ),
.c3_p3_cmd_empty	(c3_p3_cmd_empty	),
.c3_p3_cmd_full		(c3_p3_cmd_full	        ),
.c3_p3_rd_clk		(clk_100MHz	        ),
.c3_p3_rd_en		(c3_p3_rd_en	        ),
.c3_p3_rd_data		(c3_p3_rd_data	        ),
.c3_p3_rd_full		(c3_p3_rd_full	        ),
.c3_p3_rd_empty		(c3_p3_rd_empty	        ),
.c3_p3_rd_count		(c3_p3_rd_count	        ),

.c3_p4_cmd_clk		(clk_100MHz	        ),
.c3_p4_cmd_en		(c3_p4_cmd_en	        ),
.c3_p4_cmd_instr	(c3_p4_cmd_instr	),
.c3_p4_cmd_bl		(c3_p4_cmd_bl	        ),
.c3_p4_cmd_addr		(c3_p4_cmd_addr	        ),
.c3_p4_cmd_empty	(c3_p4_cmd_empty	),
.c3_p4_cmd_full		(c3_p4_cmd_full	        ),
.c3_p4_rd_clk		(clk_100MHz	        ),
.c3_p4_rd_en		(c3_p4_rd_en	        ),
.c3_p4_rd_data		(c3_p4_rd_data	        ),
.c3_p4_rd_full		(c3_p4_rd_full	        ),
.c3_p4_rd_empty		(c3_p4_rd_empty	        ),
.c3_p4_rd_count		(c3_p4_rd_count	        ),
                                       
                                                                          
//ddr3                                 
// Inouts                              
.ddr3_dq		(ddr3_dq		),
.ddr3_dqs_n		(ddr3_dqs_n	        ),
.ddr3_dqs_p		(ddr3_dqs_p	        ),
// Outputs                 
.ddr3_addr		(ddr3_addr	        ),
.ddr3_ba		(ddr3_ba		),
.ddr3_ras_n		(ddr3_ras_n	        ),
.ddr3_cas_n		(ddr3_cas_n	        ),
.ddr3_we_n		(ddr3_we_n	        ),
.ddr3_reset_n		(ddr3_reset_n	        ),
.ddr3_ck_p		(ddr3_ck_p	        ),
.ddr3_ck_n		(ddr3_ck_n	        ),
.ddr3_cke		(ddr3_cke	        ),
.ddr3_cs_n		(ddr3_cs_n	        ),
.ddr3_dm		(ddr3_dm		),
.ddr3_odt      	  	(ddr3_odt               )
);

endmodule
