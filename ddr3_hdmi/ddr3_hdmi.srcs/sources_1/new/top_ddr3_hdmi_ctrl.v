`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/10 19:53:58
// Design Name: 
// Module Name: top_ddr3_hdmi_ctrl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_ddr3_hdmi_ctrl(

input sclk,
input rst_n,

//HDMI输入输出
output	wire		r_ser_p		,
output	wire		r_ser_n		,
output	wire		g_ser_p		,
output	wire		g_ser_n		,
output	wire		b_ser_p		,
output	wire		b_ser_n		,
output	wire		clk_ser_p	,
output	wire		clk_ser_n	,
output	wire		hdmi_en     ,

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

wire clk_100MHz_1;
wire clk_100MHz;

//A7_DDR3_CTRL的信号定义
	wire		clk_200MHz	            ;
	//wire		rst_n		            ;
	wire		init_calib_complete     ;
                //用户端接口
	wire		c3_p2_cmd_clk	        ;
	wire		c3_p2_cmd_en	        ;
	wire[2:0]	c3_p2_cmd_instr	        ;
	wire[5:0]	c3_p2_cmd_bl	        ;
	wire[27:0]	c3_p2_cmd_addr	        ;
	wire		c3_p2_cmd_empty	        ;
	wire		c3_p2_cmd_full	        ;

	wire		c3_p2_wr_clk	        ;
	wire		c3_p2_wr_en	            ;
	wire[15:0]	c3_p2_wr_mask	        ;
	wire[127:0]	c3_p2_wr_data	        ;
	wire		c3_p2_wr_full	        ;
	wire		c3_p2_wr_empty	        ;
	wire[6:0]	c3_p2_wr_count	        ;

	wire		c3_p3_cmd_clk	        ;
	wire		c3_p3_cmd_en	        ;
	wire[2:0]	c3_p3_cmd_instr	        ;
	wire[5:0]	c3_p3_cmd_bl	        ;
	wire[27:0]	c3_p3_cmd_addr	        ;
	wire		c3_p3_cmd_empty	        ;
	wire		c3_p3_cmd_full	        ;
	wire		c3_p3_rd_clk	        ;
	wire		c3_p3_rd_en	            ;
	wire [127:0]	c3_p3_rd_data	    ;
	wire		c3_p3_rd_full	        ;
	wire		c3_p3_rd_empty	        ;
	wire [7:0]	c3_p3_rd_count	        ;

	wire		c3_p4_cmd_clk	        ;
	wire		c3_p4_cmd_en	        ;
	wire[2:0]	c3_p4_cmd_instr	        ;
	wire[5:0]	c3_p4_cmd_bl	        ;
	wire[27:0]	c3_p4_cmd_addr	        ;
	wire		c3_p4_cmd_empty	        ;
	wire		c3_p4_cmd_full	        ;
	wire		c3_p4_rd_clk	        ;
	wire		c3_p4_rd_en	            ;
	wire [127:0]	c3_p4_rd_data	    ;
	wire		c3_p4_rd_full	        ;
	wire		c3_p4_rd_empty	        ;
	wire [7:0]	c3_p4_rd_count	        ;

//HDMI信号的定义，连线
wire        clk_65MHz           ;
wire        clk_325MHz          ;
wire        de                  ;
wire    [23:0]  pi_rgb_data     ;
wire           po_start_flag    ;

//hdmi_ddr3_buffer信号的定义，连线
wire rd_start;
wire user_rd_end;



hdmi_ctrl hdmi_ctrl_inst(
    .clk_65MHz	        (clk_65MHz	    )           ,
    .clk_325MHz	        (clk_325MHz	    )           ,
    .rst_n		        (rst_n		    )           ,
    .pi_rgb_data        (pi_rgb_data    )           ,
    .po_start_flag      (po_start_flag  )           ,
    .r_ser_p		    (r_ser_p		)           ,
    . de                ( de            )           ,
    .r_ser_n		    (r_ser_n		)           ,
    .g_ser_p		    (g_ser_p		)           ,
    .g_ser_n		    (g_ser_n		)           ,
    .b_ser_p		    (b_ser_p		)           ,
    .b_ser_n		    (b_ser_n		)           ,
    .clk_ser_p	        (clk_ser_p	    )           ,
    .clk_ser_n	        (clk_ser_n	    )           ,
    .hdmi_en            (hdmi_en        )        
);


hdmi_ddr3_buffer hdmi_ddr3_buffer_inst(
    .clk_65MHz           (clk_65MHz    )          ,
	.clk_100MHz          (clk_100MHz   )          ,
	.rst_n               (rst_n        )          ,
	.vga_start           (po_start_flag)          ,
	.de                  (de           )          ,
	.c3_p3_rd_en         (c3_p3_rd_en  )          ,
	.user_rd_end         (user_rd_end  )          ,
	.c3_p3_rd_data       (c3_p3_rd_data)          ,
	.rd_start            (rd_start     )          ,
	.pi_rgb_data         (pi_rgb_data  )      
    );


A7_DDR3_CTRL A7_DDR3_CTRL_inst(
        .clk_200MHz	                 (clk_200MHz	     )               ,
        .rst_n		                 (rst_n		         )               ,
        .init_calib_complete         (init_calib_complete)               ,
        .c3_p2_cmd_clk	             (c3_p2_cmd_clk	     )               ,
        .c3_p2_cmd_en	             (c3_p2_cmd_en	     )               ,
        .c3_p2_cmd_instr	         (c3_p2_cmd_instr	 )               ,
        .c3_p2_cmd_bl	             (c3_p2_cmd_bl	     )               ,
        .c3_p2_cmd_addr	             (c3_p2_cmd_addr	 )               ,
        .c3_p2_cmd_empty	         (c3_p2_cmd_empty	 )               ,
        .c3_p2_cmd_full	             (c3_p2_cmd_full	 )               ,   
        .c3_p2_wr_clk	             (c3_p2_wr_clk	     )               ,
        .c3_p2_wr_en	             (c3_p2_wr_en	     )               ,
        .c3_p2_wr_mask	             (c3_p2_wr_mask	     )               ,
        .c3_p2_wr_data	             (c3_p2_wr_data	     )               ,
        .c3_p2_wr_full	             (c3_p2_wr_full	     )               ,
        .c3_p2_wr_empty	             (c3_p2_wr_empty	 )               ,
        .c3_p2_wr_count	             (c3_p2_wr_count	 )               ,
        .c3_p3_cmd_clk	             (c3_p3_cmd_clk	     )               ,
        .c3_p3_cmd_en	             (c3_p3_cmd_en	     )               ,
        .c3_p3_cmd_instr	         (c3_p3_cmd_instr	 )               ,
        .c3_p3_cmd_bl	             (c3_p3_cmd_bl	     )               ,
        .c3_p3_cmd_addr	             (c3_p3_cmd_addr	 )               ,
        .c3_p3_cmd_empty	         (c3_p3_cmd_empty	 )               ,
        .c3_p3_cmd_full	             (c3_p3_cmd_full	 )               ,
        .c3_p3_rd_clk	             (c3_p3_rd_clk	     )               ,
        .c3_p3_rd_en	             (c3_p3_rd_en	     )               ,
        .c3_p3_rd_data	             (c3_p3_rd_data	     )               ,
        .c3_p3_rd_full	             (c3_p3_rd_full	     )               ,
        .c3_p3_rd_empty	             (c3_p3_rd_empty	 )               ,
        .c3_p3_rd_count	             (c3_p3_rd_count	 )               ,
        .c3_p4_cmd_clk	             (c3_p4_cmd_clk	     )               ,
        .c3_p4_cmd_en	             (c3_p4_cmd_en	     )               ,
        .c3_p4_cmd_instr	         (c3_p4_cmd_instr	 )               ,
        .c3_p4_cmd_bl	             (c3_p4_cmd_bl	     )               ,   
        .c3_p4_cmd_addr	             (c3_p4_cmd_addr	 )               ,
        .c3_p4_cmd_empty             (c3_p4_cmd_empty    )	             ,
        .c3_p4_cmd_full	             (c3_p4_cmd_full	 )               ,
        .c3_p4_rd_clk	             (c3_p4_rd_clk	     )               ,
        .c3_p4_rd_en	             (c3_p4_rd_en	     )               ,
        .c3_p4_rd_data	             (c3_p4_rd_data	     )               ,
        .c3_p4_rd_full	             (c3_p4_rd_full	     )               ,
        .c3_p4_rd_empty	             (c3_p4_rd_empty	 )               ,
        .c3_p4_rd_count	             (c3_p4_rd_count	 )               ,
        .ddr3_dq		             (ddr3_dq		     )               ,
        .ddr3_dqs_n	                 (ddr3_dqs_n	     )               ,
        .ddr3_dqs_p	                 (ddr3_dqs_p	     )               ,
        .ddr3_addr                   (ddr3_addr          )           	 ,
        .ddr3_ba	                 (ddr3_ba	         )           	 ,
        .ddr3_ras_n	                 (ddr3_ras_n	     )               ,
        .ddr3_cas_n	                 (ddr3_cas_n	     )               ,
        .ddr3_we_n                   (ddr3_we_n          )           	 ,
        .ddr3_reset_n	             (ddr3_reset_n	     )               ,
        .ddr3_ck_p	                 (ddr3_ck_p	         )               ,
        .ddr3_ck_n	                 (ddr3_ck_n	         )               ,
        .ddr3_cke	                 (ddr3_cke	         )               ,
        .ddr3_cs_n	                 (ddr3_cs_n	         )               ,
        .ddr3_dm		             (ddr3_dm		     )               ,
        .ddr3_odt                    (ddr3_odt           )            
);



//user_rd_ctrl
user_rd_ctrl
#(
.INIT_RD_BYTE_ADDR	(0	                   )         ,
.MAX_RD_BYTE_ADDR	(2048	               )
)
user_rd_ctrl_inst(
.sclk		(clk_100MHz		                )        ,
.rst_n		(init_calib_complete	        )        ,
.rd_start	(rd_start		            )            ,//cmd_en
.rd_cmd_bl	(63			                    )        ,
.c3_p3_rd_count	(c3_p3_rd_count		        )        ,

.c3_p3_rd_en	(c3_p3_rd_en		        )        ,
.c3_p3_cmd_en	(c3_p3_cmd_en		        )        ,
.c3_p3_cmd_bl	(c3_p3_cmd_bl		        )        ,
.c3_p3_cmd_byte_addr(c3_p3_cmd_addr	        )        ,
.user_rd_end	(user_rd_end		        )
);


//PLL
//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG

  clk_wiz_0 clk_wiz_01
   (
    // Clock out ports
    .clk_out1(clk_100MHz),     // output clk_out1
    .clk_out2(clk_200MHz),     // output clk_out2
    .clk_out3(clk_100MHz_1),     // output clk_out3
   // Clock in ports
    .clk_in1(sclk));      // input clk_in1
// INST_TAG_END ------ End INSTANTIATION Template ---------

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG

  clk_wiz_1 clk_wiz_12
   (
    // Clock out ports
    .clk_out1(clk_65MHz),     // output clk_out1
    .clk_out2(clk_325MHz),     // output clk_out2
   // Clock in ports
    .clk_in1(clk_100MHz_1));      // input clk_in1
// INST_TAG_END ------ End INSTANTIATION Template ---------






endmodule