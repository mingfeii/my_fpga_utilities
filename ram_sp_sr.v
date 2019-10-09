//单端口 同步ram
module  ram_sp_sr #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 8,
    parameter RAM_DEPTH  = 1 << ADDR_WIDTH;
)(
    input clk,
    input [ADDR_WIDTH-1：0] address,
    input cs,
    input we,
    input oe,
    inout [DATA_WIDTH-1:0] data
);

reg [DATA_WIDTH-1:0] data_out;
reg [DATA_WIDTH-1:0] mem [0:RAM_DEPTH-1]; //建立memory
reg oe_r;

//we = 0,oe = 1,cs = 1
assign data = (cs && oe && !we) ? data_out : 0'bz;

//write operation we = 1,cs = 1;
always@(posedge clk)
begin :MEM_WRITE
    if(cs && we) begin
        mem[address] = data;
        end
end

//read operation we = 0,oe = 1,cs = 1;
always @(posedge clk)
begin : MEM_READ
    if (cs & !we && oe) begin
        data_out = mem[address];
        oe_r = 1;
        end
    end
endmodule 
