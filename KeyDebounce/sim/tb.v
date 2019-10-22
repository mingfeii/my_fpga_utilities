module tb;
// Inputs
reg clk_i;
reg rst_n_i;
reg key_i;
wire [3:0] led_o;

key_jitter (
.clk_i(clk_i),
.rst_n_i(rst_n_i),
.key_i(key_i),
.led_o(led_o)
);

initial
begin
    // Initialize Inputs
    clk_i = 0;
    forever
    #5 clk_i=~clk_i;
end

initial
begin
    // Initialize Inputs
    rst_n_i = 0;
    #100;
    rst_n_i=1;
    key_i = 1;
    #10000;
    forever
    begin
        key_i = 0;
        // Wait 100 ns for global reset to finish
        #100;
        key_i=1; #1000;
        key_i=0; #1000;
        key_i=1; #2000;
        key_i=0; #5000;
        #50000000;
        key_i=1;
        key_i=0; #1000;
        key_i=1; #2000;
        key_i=0; #1000;
        key_i=1; #2000;
        #50000000;
        key_i=0;
    end
end
endmodule 