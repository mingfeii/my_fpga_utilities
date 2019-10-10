//单口ram,异步读，同步写
module ram_sp_ar_sw #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 8,
    parameter RAM_DEPTH = 1 << ADDR_WIDTH
    
)(
    input clk,                          //时钟输入
    input [ADDR_WIDTH-1:0] address,     //地址输入
    input cs,                           //片选信号
    input oe,                           //输出使能
    inout [DATA_WIDTH-1:0] data         //双向传输的数据

);
reg [DATA_WIDTH-1:0] data_out;
reg [DATA_WIDTH-1:0] mem [0:RAM_DEPTH-1];

assign data = (cs && oe && !we) ? data_out : 8'bz;

always@(posedge clk)
begin:MEM_WRITE
    if(cs && we) begin
        mem[address] = data;
    end
end

always@(*) begin :MEM_READ
    if(cs && !we && oe) begin
        data_out = mem[address]
    end
end
endmodule

