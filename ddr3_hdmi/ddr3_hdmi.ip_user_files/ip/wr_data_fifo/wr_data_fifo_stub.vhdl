-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (win64) Build 2700185 Thu Oct 24 18:46:05 MDT 2019
-- Date        : Sun Nov  3 16:54:03 2019
-- Host        : DESKTOP-QEOALQR running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               C:/Users/mingf/Desktop/github/ddr3_hdmi/ddr3_hdmi.srcs/sources_1/ip/wr_data_fifo/wr_data_fifo_stub.vhdl
-- Design      : wr_data_fifo
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tfgg484-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity wr_data_fifo is
  Port ( 
    wr_clk : in STD_LOGIC;
    rd_clk : in STD_LOGIC;
    din : in STD_LOGIC_VECTOR ( 143 downto 0 );
    wr_en : in STD_LOGIC;
    rd_en : in STD_LOGIC;
    dout : out STD_LOGIC_VECTOR ( 143 downto 0 );
    full : out STD_LOGIC;
    empty : out STD_LOGIC;
    wr_data_count : out STD_LOGIC_VECTOR ( 6 downto 0 )
  );

end wr_data_fifo;

architecture stub of wr_data_fifo is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "wr_clk,rd_clk,din[143:0],wr_en,rd_en,dout[143:0],full,empty,wr_data_count[6:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "fifo_generator_v13_2_5,Vivado 2019.2";
begin
end;
