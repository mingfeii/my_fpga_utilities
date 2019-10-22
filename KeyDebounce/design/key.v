module key #
(
    parameter CLK_FREQ = 100000000
)
(
    input clk_i,
    input key_i,
    output key_cap
);

//10ms
parameter CNT_10MS = (CLK_FREQ/100 - 1'b1);
parameter KEY_S0 = 2'd0;
parameter KEY_S1 = 2'd1;
parameter KEY_S2 = 2'd2;
parameter KEY_S3 = 2'd3;
reg [24:0] cnt10ms = 25'd0;
(*mark_debug = "true"*) reg [1:0] key_s = 2'b0;
(*mark_debug = "true"*) reg [1:0] key_s_r = 2'b0;
(*mark_debug = "true"*) wire en_10ms ;

assign en_10ms = (cnt10ms == CNT_10MS);
assign key_cap = (key_s==KEY_S2)&&(key_s_r==KEY_S1); //s1到s2的转变确认了一次按键按下动作，这个信可以拿到外层去用

always @(posedge clk_i) begin
    if(cnt10ms < CNT_10MS)
        cnt10ms <= cnt10ms + 1'b1;
    else
         cnt10ms <= 25'd0;
end

always @(posedge clk_i) begin
    key_s_r <= key_s;
end

always @(posedge clk_i)begin //判断按键按下要坚持10ms才能判断
    if(en_10ms)begin
        case(key_s)
        KEY_S0:begin
            if(!key_i) //判断按键按下，是则转移到s1
             key_s <= KEY_S1;
            end
        KEY_S1:begin
            if(!key_i)
             key_s <= KEY_S2; //10ms后再次判断按键是否按下，是则确认按键已经按下，转移到s2,否则还回到s0
            else
             key_s <= KEY_S0;
            end
        KEY_S2:begin
            if(key_i)  //判断按键是否抬起，是则转移到s3
                key_s <= KEY_S3;
            end
        KEY_S3:begin
            if(key_i)
                key_s <= KEY_S0; //10ms后判断按键是否抬起，是则转移到s0,否则继续回到s2
            else
                key_s <= KEY_S2;
            end
        endcase
    end
end
endmodule