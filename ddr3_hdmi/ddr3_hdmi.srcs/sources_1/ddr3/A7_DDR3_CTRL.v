module A7_DDR3_CTRL(
input	wire		clk_200MHz	,
input	wire		rst_n		,

output	wire		init_calib_complete,

//用户端接口
input	wire		c3_p2_cmd_clk	,
input	wire		c3_p2_cmd_en	,
input	wire[2:0]	c3_p2_cmd_instr	,
input	wire[5:0]	c3_p2_cmd_bl	,
input	wire[27:0]	c3_p2_cmd_addr	,
output	wire		c3_p2_cmd_empty	,
output	wire		c3_p2_cmd_full	,

input	wire		c3_p2_wr_clk	,
input	wire		c3_p2_wr_en	,
input	wire[15:0]	c3_p2_wr_mask	,
input	wire[127:0]	c3_p2_wr_data	,
output	wire		c3_p2_wr_full	,
output	wire		c3_p2_wr_empty	,
output	wire[6:0]	c3_p2_wr_count	,

input	wire		c3_p3_cmd_clk	,
input	wire		c3_p3_cmd_en	,
input	wire[2:0]	c3_p3_cmd_instr	,
input	wire[5:0]	c3_p3_cmd_bl	,
input	wire[27:0]	c3_p3_cmd_addr	,
output	wire		c3_p3_cmd_empty	,
output	wire		c3_p3_cmd_full	,
input	wire		c3_p3_rd_clk	,
input	wire		c3_p3_rd_en	,
output	wire [127:0]	c3_p3_rd_data	,
output	wire		c3_p3_rd_full	,
output	wire		c3_p3_rd_empty	,
output	wire [7:0]	c3_p3_rd_count	,

input	wire		c3_p4_cmd_clk	,
input	wire		c3_p4_cmd_en	,
input	wire[2:0]	c3_p4_cmd_instr	,
input	wire[5:0]	c3_p4_cmd_bl	,
input	wire[27:0]	c3_p4_cmd_addr	,
output	wire		c3_p4_cmd_empty	,
output	wire		c3_p4_cmd_full	,
input	wire		c3_p4_rd_clk	,
input	wire		c3_p4_rd_en	,
output	wire [127:0]	c3_p4_rd_data	,
output	wire		c3_p4_rd_full	,
output	wire		c3_p4_rd_empty	,
output	wire [7:0]	c3_p4_rd_count	,



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

wire		ui_clk		;
wire		a7_rd_start1	;
wire		a7_rd_start2	;
wire[5:0]	a7_rd_bl1	;
wire[27:0]	a7_rd_init_addr1;
wire[5:0]	a7_rd_bl2	;
wire[27:0]	a7_rd_init_addr2;
wire		app_rdy		;
wire		app_rd_data_valid;
wire[127:0]	app_rd_data	;

wire[27:0]	app_addr	;
wire		app_en		;
wire[2:0]	app_cmd		;
wire		a7_rd_end1	;
wire[127:0]	a7_rd_data1	;
wire		a7_rd_data_valid1;
wire		a7_rd_end2	;
wire[127:0]	a7_rd_data2	;
wire		a7_rd_data_valid2;


wire		a7_wr_start	;
wire[5:0]	a7_wr_bl	;
wire[27:0]	a7_wr_init_addr	;
wire		app_wdf_rdy	;

wire[15:0]	a7_wr_mask	;
wire[127:0]	a7_wr_data	;

wire		app_wdf_wren	;
wire		app_wdf_end	;
wire		data_req	;
wire		a7_wr_end	;
wire[2:0]	a7_wr_cmd	;
wire[2:0]	a7_rd_cmd1	;
wire[2:0]	a7_rd_cmd2	;
wire[127:0]	app_wdf_data	;
wire[15:0]	app_wdf_mask    ;

wire[27:0]	app_addr_wr	;
wire		app_en_wr	;
wire[2:0]	app_cmd_wr	;

wire[27:0]	app_addr_rd1	;
wire[27:0]	app_addr_rd2	;
wire		app_en_rd1	;
wire[2:0]	app_cmd_rd1	;
wire		app_en_rd2	;
wire[2:0]	app_cmd_rd2	;
wire[4:0]	arbit_state	;

   
   
mig_7series_0 u_mig_7series_0 (

// Memory interface ports
.ddr3_addr                      (ddr3_addr),  // output [13:0]		ddr3_addr
.ddr3_ba                        (ddr3_ba),  // output [2:0]		ddr3_ba
.ddr3_cas_n                     (ddr3_cas_n),  // output			ddr3_cas_n
.ddr3_ck_n                      (ddr3_ck_n),  // output [0:0]		ddr3_ck_n
.ddr3_ck_p                      (ddr3_ck_p),  // output [0:0]		ddr3_ck_p
.ddr3_cke                       (ddr3_cke),  // output [0:0]		ddr3_cke
.ddr3_ras_n                     (ddr3_ras_n),  // output			ddr3_ras_n
.ddr3_reset_n                   (ddr3_reset_n),  // output			ddr3_reset_n
.ddr3_we_n                      (ddr3_we_n),  // output			ddr3_we_n
.ddr3_dq                        (ddr3_dq),  // inout [15:0]		ddr3_dq
.ddr3_dqs_n                     (ddr3_dqs_n),  // inout [1:0]		ddr3_dqs_n
.ddr3_dqs_p                     (ddr3_dqs_p),  // inout [1:0]		ddr3_dqs_p
.init_calib_complete            (init_calib_complete),  // output			init_calib_complete

.ddr3_cs_n                      (ddr3_cs_n),  // output [0:0]		ddr3_cs_n
.ddr3_dm                        (ddr3_dm),  // output [1:0]		ddr3_dm
.ddr3_odt                       (ddr3_odt),  // output [0:0]		ddr3_odt
// Application interface ports
.app_addr                       (app_addr),  // input [27:0]		app_addr
.app_cmd                        (app_cmd),  // input [2:0]		app_cmd
.app_en                         (app_en),  // input				app_en
.app_wdf_data                   (app_wdf_data),  // input [127:0]		app_wdf_data
.app_wdf_end                    (app_wdf_end),  // input				app_wdf_end
.app_wdf_wren                   (app_wdf_wren),  // input				app_wdf_wren
.app_rd_data                    (app_rd_data),  // output [127:0]		app_rd_data
.app_rd_data_end                (app_rd_data_end),  // output			app_rd_data_end
.app_rd_data_valid              (app_rd_data_valid),  // output			app_rd_data_valid
.app_rdy                        (app_rdy),  // output			app_rdy
.app_wdf_rdy                    (app_wdf_rdy),  // output			app_wdf_rdy
.app_sr_req                     (0),  // input			app_sr_req
.app_ref_req                    (0),  // input			app_ref_req
.app_zq_req                     (0),  // input			app_zq_req
.app_sr_active                  (app_sr_active),  // output			app_sr_active
.app_ref_ack                    (app_ref_ack),  // output			app_ref_ack
.app_zq_ack                     (app_zq_ack),  // output			app_zq_ack
.ui_clk                         (ui_clk),  // output			ui_clk
.ui_clk_sync_rst                (ui_clk_sync_rst),  // output			ui_clk_sync_rst
.app_wdf_mask                   (app_wdf_mask),  // input [15:0]		app_wdf_mask
// System Clock Ports
.sys_clk_i			(clk_200MHz),
.sys_rst                        (rst_n) // input sys_rst
);

arbit	arbit_inst(
.ui_clk			(ui_clk			),
.rst_n			(init_calib_complete	),
.c3_p2_cmd_empty	(c3_p2_cmd_empty	),
.c3_p3_cmd_empty	(c3_p3_cmd_empty	),
.c3_p4_cmd_empty	(c3_p4_cmd_empty	),
.a7_wr_end		(a7_wr_end		),	
.a7_rd1_end		(a7_rd_end1		),
.a7_rd2_end		(a7_rd_end2		),

.a7_wr_start		(a7_wr_start		),
.a7_rd1_start		(a7_rd_start1		),
.a7_rd2_start		(a7_rd_start2		),
.state			(arbit_state		)
);

//wr cmd fifo
cmd_fifo	wr_cmd_fifo_inst(
.wr_clk		(c3_p2_cmd_clk		),// input wire wr_clk
.rd_clk		(ui_clk			),// input wire rd_clk
.din		({3'b0,c3_p2_cmd_bl,c3_p2_cmd_addr}),        // input wire [36 : 0] din
.wr_en		(c3_p2_cmd_en		),// input wire wr_en
.rd_en		(a7_wr_start		),// input wire rd_en
.dout		({a7_wr_cmd,a7_wr_bl,a7_wr_init_addr}),      // output wire [36 : 0] dout
.full		(c3_p2_cmd_full		),// output wire full
.empty		(c3_p2_cmd_empty	)// output wire empty
);

//wr data fifo
wr_data_fifo	wr_data_fifo_inst(
.wr_clk		(c3_p2_wr_clk		),// input wire wr_clk
.rd_clk		(ui_clk			),// input wire rd_clk
.din		({c3_p2_wr_mask,c3_p2_wr_data}),// input wire [143 : 0] din
.wr_en		(c3_p2_wr_en		),// input wire wr_en
.rd_en		(data_req		),// input wire rd_en
.dout		({a7_wr_mask,a7_wr_data}),// output wire [17 : 0] dout
.full		(c3_p2_wr_full		),// output wire full
.empty		(c3_p2_wr_empty		),// output wire empty
.wr_data_count	(c3_p2_wr_count		)// output wire [7 : 0] wr_data_count
);

//a7_wr_ctrl
a7_wr_ctrl	a7_wr_ctrl_inst(
.ui_clk		(ui_clk		        ),
.rst_n		(init_calib_complete	),
.a7_wr_start	(a7_wr_start	        ),
.a7_wr_bl	(a7_wr_bl		),
.a7_wr_init_addr(a7_wr_init_addr	),
.app_wdf_rdy	(app_wdf_rdy	        ),
.app_rdy	(app_rdy		),
.a7_wr_mask	(a7_wr_mask		),
.a7_wr_data	(a7_wr_data	        ),

.app_addr	(app_addr_wr	        ),
.app_en		(app_en_wr		),
.app_cmd	(app_cmd_wr		),
.app_wdf_en	(app_wdf_wren	        ),
.app_wdf_end	(app_wdf_end	        ),
.data_req	(data_req	        ),
.a7_wr_end	(a7_wr_end	        ),
.app_wdf_data	(app_wdf_data	        ),
.app_wdf_mask	(app_wdf_mask           )
);

//rd1 cmd fifo
cmd_fifo	rd1_cmd_fifo_inst(
.wr_clk		(c3_p3_cmd_clk		),// input wire wr_clk
.rd_clk		(ui_clk			),// input wire rd_clk
.din		({3'b1,c3_p3_cmd_bl,c3_p3_cmd_addr}),        // input wire [36 : 0] din
.wr_en		(c3_p3_cmd_en		),// input wire wr_en
.rd_en		(a7_rd_start1		),// input wire rd_en
.dout		({a7_rd_cmd1,a7_rd_bl1,a7_rd_init_addr1}),      // output wire [36 : 0] dout
.full		(c3_p3_cmd_full		),// output wire full
.empty		(c3_p3_cmd_empty	)// output wire empty
);

//ila_0	ila_0_inst(
//.clk(ui_clk		), // input wire clk
//
//.probe0({}) // input wire [299:0] probe0
//);

//rd data fifo 1
rd_data_fifo	rd_data_fifo_inst1(
.wr_clk		(ui_clk			),// input wire wr_clk
.rd_clk		(c3_p3_rd_clk		),// input wire rd_clk
.din		(a7_rd_data1		),// input wire [127 : 0] din
.wr_en		(a7_rd_data_valid1	),// input wire wr_en
.rd_en		(c3_p3_rd_en		),// input wire rd_en
.dout		(c3_p3_rd_data		),// output wire [127 : 0] dout
.full		(c3_p3_rd_full		),// output wire full
.empty		(c3_p3_rd_empty		),// output wire empty
.wr_data_count	(c3_p3_rd_count		)// output wire [6 : 0] wr_data_count
);

//a7_rd_ctrl1
a7_rd_ctrl	a7_rd_ctrl_inst1(
.ui_clk		(ui_clk		        ),
.rst_n		(init_calib_complete	),
.a7_rd_start	(a7_rd_start1	        ),
.a7_rd_bl	(a7_rd_bl1		),
.a7_rd_init_addr(a7_rd_init_addr1	),
.app_rdy	(app_rdy		),
.app_rd_data_valid(app_rd_data_valid&arbit_state[3]),//
.app_rd_data	(app_rd_data		),//

.app_addr	(app_addr_rd1	        ),
.app_en		(app_en_rd1		),
.app_cmd	(app_cmd_rd1		),
.a7_rd_end	(a7_rd_end1	        ),
.a7_rd_data	(a7_rd_data1	        ),
.a7_rd_data_valid(a7_rd_data_valid1	)
);


//rd2 cmd fifo
cmd_fifo	rd2_cmd_fifo_inst(
.wr_clk		(c3_p4_cmd_clk		),// input wire wr_clk
.rd_clk		(ui_clk			),// input wire rd_clk
.din		({3'b1,c3_p4_cmd_bl,c3_p4_cmd_addr}),        // input wire [36 : 0] din
.wr_en		(c3_p4_cmd_en		),// input wire wr_en
.rd_en		(a7_rd_start2		),// input wire rd_en
.dout		({a7_rd_cmd2,a7_rd_bl2,a7_rd_init_addr2}),      // output wire [36 : 0] dout
.full		(c3_p4_cmd_full		),// output wire full
.empty		(c3_p4_cmd_empty	)// output wire empty
);

// //rd data fifo 2
// rd_data_fifo	rd_data_fifo_inst2(
// .wr_clk		(ui_clk			),// input wire wr_clk
// .rd_clk		(c3_p4_rd_clk		),// input wire rd_clk
// .din		(a7_rd_data2		),// input wire [127 : 0] din
// .wr_en		(a7_rd_data_valid2	),// input wire wr_en
// .rd_en		(c3_p4_rd_en		),// input wire rd_en
// .dout		(c3_p4_rd_data		),// output wire [127 : 0] dout
// .full		(c3_p4_rd_full		),// output wire full
// .empty		(c3_p4_rd_empty		),// output wire empty
// .wr_data_count	(c3_p4_rd_count		)// output wire [6 : 0] wr_data_count
// );

//a7_rd_ctrl2
a7_rd_ctrl	a7_rd_ctrl_inst2(
.ui_clk		(ui_clk		        ),
.rst_n		(init_calib_complete	),
.a7_rd_start	(a7_rd_start2	        ),
.a7_rd_bl	(a7_rd_bl2		),
.a7_rd_init_addr(a7_rd_init_addr2	),
.app_rdy	(app_rdy		),
.app_rd_data_valid(app_rd_data_valid&arbit_state[4]),
.app_rd_data	(app_rd_data		),

.app_addr	(app_addr_rd2	        ),
.app_en		(app_en_rd2		),
.app_cmd	(app_cmd_rd2		),
.a7_rd_end	(a7_rd_end2	        ),
.a7_rd_data	(a7_rd_data2	        ),
.a7_rd_data_valid(a7_rd_data_valid2	)
);

assign	app_addr	=	app_addr_wr|app_addr_rd1|app_addr_rd2;
assign	app_cmd		=	app_cmd_wr|app_cmd_rd1|app_cmd_rd2;
assign	app_en		=	app_en_wr|app_en_rd1|app_en_rd2;

endmodule
