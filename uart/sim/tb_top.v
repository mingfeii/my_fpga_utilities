`timescale	1ns/1ns
module	tb_top();
reg	clk;
reg	rst_n;
reg	rx;//16byte:16*(1+8bit+1)

wire	tx;

reg	[7:0]	a_mem[15:0];//a_mem是一个存储器，相当于一个ram

initial
	$readmemh("./data.txt",a_mem);

initial
	begin
		clk	=	0;
		rst_n	<=	0;
		#30
		rst_n	<=	1;	
	end
initial
	begin
		rx	<=	1;
		#200
		rx_byte();
	end

always	#10	clk	=	~clk;

task	rx_byte();
	integer	j;//定义了一个整形变量
	for(j=0;j<16;j=j+1)
		rx_bit(a_mem[j]);//a_mem[j]是data.txt文件里面第j个8bit的数据
endtask

task	rx_bit(input[7:0]	data);//data是a_memd[j]的值
	integer	i;
	for(i=0;i<10;i=i+1)
		begin
		case(i)
		0:	rx	<=	1'b0;//起始位
		1:	rx	<=	data[0];
		2:	rx	<=	data[1];
		3:	rx	<=	data[2];
		4:	rx	<=	data[3];
		5:	rx	<=	data[4];
		6:	rx	<=	data[5];
		7:	rx	<=	data[6];
		8:	rx	<=	data[7];
		9:	rx	<=	1'b1;//停止位
		endcase
		#104160;   //104160*10*16  =18ms
		end
endtask
top_uart	top_uart_inst(
.clk	(clk	),
.rst_n	(rst_n	),
.rx	(rx	),
                
.tx     (tx     )
);
endmodule