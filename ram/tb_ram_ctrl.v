module tb_ram_ctrl();
reg clk;
reg rst_n;
reg [7:0] pi_data;
wire [7:0] po_data;

initial 
begin
	clk = 1'b1;
	rst_n = 1'b0;
	pi_data = 8'b0;
	#20
	rst_n = 1'b1;
end

always #5 clk = ~clk;
always #20 pi_data <= {$random};

ram_ctrl ram_ctrl_inst
(
	.clk (clk),
	.rst_n(rst_n),
	.pi_data(pi_data),
	.po_data(po_data),
);

endmodule 

