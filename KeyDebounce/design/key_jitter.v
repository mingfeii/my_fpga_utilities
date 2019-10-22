module key_jitter(
    input clk_i,
    input rst_n_i,
    input key_i, 
    output [3:0] led_o  //绑定开发板上的led模块
);
(*mark_debug = "true"*) reg [3:0] led_o;
(*mark_debug = "true"*) wire key_cap;

always @(posedge clk_i)begin
if(!rst_n_i)begin
    led_o <= 4'b0000;
    end
    else if(key_cap)begin
    led_o <= ~led_o; //按键按下 led取反
    end
end

key#
(
.CLK_FREQ(100000000)
)
    key0
    (
    .clk_i(clk_i),
    .key_i(key_i),
    .key_cap(key_cap)
    );

endmodule