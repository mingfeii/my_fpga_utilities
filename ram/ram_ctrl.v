//对于Xilinx的单端口ram的一个简单的读写操作
module ram_ctrl(
	input wire clk,
	input wire rst_n,
	input wire [7:0] pi_data,
	output wire [7:0] podata
);

reg wr_en; //写使能
reg [7:0] wr_addr; //写地址
reg [7:0] rd_addr; //读地址


//产生写使能
always@(posedge clk or negedge rst_n)
	if (!rst_n)
		wr_en <= 1'b0;
	else if (wr_addr = 8'd255)
		wr_en <= 1'b0;
	else if (rd_addr == 8'd255)
		wr_en <= 1'b1;
//产生写地址
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		wr_addr <= 8'b0;
	else if (wr_en == 1)
		wr_addr <= wr_addr + 8'b1;
	else wr_addr <= 8'b0;


//产生读地址
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		rd_addr <= 8'b0;
	else if (wr_en == 1'd0)
		rd_addr <= rd_addr + 1'b1;
	else rd_addr <= 8'b0;

//例化ram
ram_256x8 ram_256x8_inst (
	.clka 		(clk),
	.wea 		(wr_en),
	.addra 		(wr_addr),
	.dina 		(pi_data),
	clkb 		(clk),
	addrb 		(rd_addr),
	.doutb 		(po_data)
);
endmodule 
