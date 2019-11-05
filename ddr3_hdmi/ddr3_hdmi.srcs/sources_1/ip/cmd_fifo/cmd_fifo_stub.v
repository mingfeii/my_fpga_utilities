// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2700185 Thu Oct 24 18:46:05 MDT 2019
// Date        : Sun Nov  3 16:54:01 2019
// Host        : DESKTOP-QEOALQR running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/Users/mingf/Desktop/github/ddr3_hdmi/ddr3_hdmi.srcs/sources_1/ip/cmd_fifo/cmd_fifo_stub.v
// Design      : cmd_fifo
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tfgg484-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_5,Vivado 2019.2" *)
module cmd_fifo(wr_clk, rd_clk, din, wr_en, rd_en, dout, full, empty)
/* synthesis syn_black_box black_box_pad_pin="wr_clk,rd_clk,din[36:0],wr_en,rd_en,dout[36:0],full,empty" */;
  input wr_clk;
  input rd_clk;
  input [36:0]din;
  input wr_en;
  input rd_en;
  output [36:0]dout;
  output full;
  output empty;
endmodule
