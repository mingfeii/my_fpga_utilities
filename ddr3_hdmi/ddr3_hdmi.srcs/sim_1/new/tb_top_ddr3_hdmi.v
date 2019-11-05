`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/10 21:46:28
// Design Name: 
// Module Name: tb_top_ddr3_hdmi
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

`timescale 1ns / 1ps
module tb_top_ddr3_hdmi();




reg		sclk	;//input 1bit
reg		rst_n	;//input 1bit



initial
	begin
		sclk	=	1'b1;
		rst_n	<=	1'b0;
		#200
		rst_n	<=	1'b1;
	end
always	#10	sclk	=	~sclk;	
   
wire		r_ser_p		;
wire		r_ser_n		;
wire		g_ser_p		;
wire		g_ser_n		;
wire		b_ser_p		;
wire		b_ser_n		;
wire		clk_ser_p	;
wire		clk_ser_n	;
wire		hdmi_en     ;

    //ddr3
// Inouts
wire [15:0]		ddr3_dq		;
wire [1:0]		ddr3_dqs_n	;
wire [1:0]		ddr3_dqs_p	;
// Outputs
wire [13:0]		ddr3_addr	;
wire [2:0]		ddr3_ba		;
wire			ddr3_ras_n	;
wire			ddr3_cas_n	;
wire			ddr3_we_n	;
wire			ddr3_reset_n;
wire [0:0]		ddr3_ck_p	;
wire [0:0]		ddr3_ck_n	;
wire [0:0]		ddr3_cke	;
wire [0:0]		ddr3_cs_n	;
wire [1:0]		ddr3_dm		;
wire [0:0]		ddr3_odt    ;
		
//end
top_ddr3_hdmi_ctrl	top_ddr3_hdmi_ctrl_inst(
.sclk(sclk),
.rst_n(rst_n),


//HDMI输入输出
.r_ser_p(r_ser_p)		,
.r_ser_n(r_ser_n)		,
.g_ser_p(g_ser_p)		,
.g_ser_n(g_ser_n)		,
.b_ser_p(b_ser_p)		,
.b_ser_n(b_ser_n)		,
.clk_ser_p(clk_ser_p)	    ,
.clk_ser_n(clk_ser_n)	    ,
.hdmi_en(hdmi_en)         ,

.ddr3_dq	(ddr3_dq),
.ddr3_dqs_n	(ddr3_dqs_n),
.ddr3_dqs_p	(ddr3_dqs_p),
.ddr3_addr	(ddr3_addr),
.ddr3_ba	(ddr3_ba),
.ddr3_ras_n	(ddr3_ras_n),
.ddr3_cas_n	(ddr3_cas_n),
.ddr3_we_n	(ddr3_we_n),
.ddr3_reset_n	(ddr3_reset_n),
.ddr3_ck_p	(ddr3_ck_p),
.ddr3_ck_n	(ddr3_ck_n),
.ddr3_cke	(ddr3_cke),
.ddr3_dm	(ddr3_dm),
.ddr3_odt	(ddr3_odt)
//ddr3 pin end	
);


//model
ddr3_model	ddr3_model_inst(
.rst_n	(ddr3_reset_n),
.ck	(ddr3_ck_p),
.ck_n	(ddr3_ck_n),
.cke	(ddr3_cke),
.cs_n	(1'b0),
.ras_n	(ddr3_ras_n),
.cas_n	(ddr3_cas_n),
.we_n	(ddr3_we_n),
.dm_tdqs(ddr3_dm),
.ba	(ddr3_ba),
.addr	(ddr3_addr),
.dq	(ddr3_dq),
.dqs	(ddr3_dqs_p),
.dqs_n	(ddr3_dqs_n),
.tdqs_n	(),
.odt	(ddr3_odt)
);


endmodule
