`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/10 19:56:33
// Design Name: 
// Module Name: hdmi_ddr3_buffer
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


module hdmi_ddr3_buffer(
    input wire clk_65MHz,
	input wire clk_100MHz,
	input wire rst_n,
	input wire vga_start,
	input wire de,
	input wire c3_p3_rd_en,
	input wire user_rd_end,
	input wire [127:0] c3_p3_rd_data,
	output reg rd_start,
	output wire [23:0] pi_rgb_data
    );
wire [31:0] rgb_data;
assign pi_rgb_data = rgb_data[23:0];



wire [11:0] fifo_cnt;

parameter IDLE = 3'b001;
parameter JUDGE = 3'b010;
parameter RD = 3'b101;
parameter THRESHOLD = 1500;

reg [1:0] state;
reg rd_flag;
wire ddr3_hdmi_fifo_rd_en;



//rd_flag
always@(posedge clk_65MHz)
	if (rst_n == 0)
		rd_flag <= 0;
	else if (fifo_cnt >= THRESHOLD && vga_start == 1)
		rd_flag <= 1;




//state
always@(posedge clk_100MHz)
	if (rst_n == 0)
		state <= IDLE;
	else case(state)
		IDLE:state <= JUDGE;
		JUDGE:if (fifo_cnt < THRESHOLD)
				state <= RD;
		RD:if (fifo_cnt >= THRESHOLD && user_rd_end == 1)
					state <= JUDGE;
		default:state <= IDLE;

	endcase // state

//rd_start
always@(posedge clk_100MHz)
	if (rst_n == 0)
		rd_start <= 0;
	else if (state == JUDGE && fifo_cnt < THRESHOLD)
		rd_start <= 1;
	else rd_start <= 0;



assign ddr3_hdmi_fifo_rd_en = rd_flag & de;

buffer_fifo buffer_fifo_1 (
  .wr_clk(clk_100MHz),                // input wire wr_clk
  .rd_clk(clk_65MHz),                // input wire rd_clk
  .din(c3_p3_rd_data),                      // input wire [127 : 0] din
  .wr_en(c3_p3_rd_en),                  // input wire wr_en
  .rd_en(ddr3_hdmi_fifo_rd_en),                  // input wire rd_en
  .dout(rgb_data),                    // output wire [31 : 0] dout
  .full(full),                    // output wire full
  .empty(empty),                  // output wire empty
  .rd_data_count(fifo_cnt)  // output wire [11 : 0] rd_data_count
);
endmodule
