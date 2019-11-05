module par2ser(
input	wire		clk_1x	,
input	wire		clk_5x	,
input	wire		rst_n	,
input	wire[9:0]	par_dat	,

output	wire		ser_p	,	
output	wire		ser_n
);
wire		ser_dat	;	
wire[1:0]	shift_dat;

OBUFDS #(
.IOSTANDARD("DEFAULT"), // Specify the output I/O standard
.SLEW("SLOW")           // Specify the output slew rate
) OBUFDS_inst (
.O(ser_p),     // Diff_p output (connect directly to top-level port)
.OB(ser_n),   // Diff_n output (connect directly to top-level port)
.I(ser_dat)      // Buffer input
);


OSERDESE2 #(
.DATA_RATE_OQ("DDR"),   // DDR, SDR
.DATA_RATE_TQ("DDR"),   // DDR, BUF, SDR
.DATA_WIDTH(10),         // Parallel data width (2-8,10,14)
.INIT_OQ(1'b0),         // Initial value of OQ output (1'b0,1'b1)
.INIT_TQ(1'b0),         // Initial value of TQ output (1'b0,1'b1)
.SERDES_MODE("MASTER"), // MASTER, SLAVE
.SRVAL_OQ(1'b0),        // OQ output value when SR is used (1'b0,1'b1)
.SRVAL_TQ(1'b0),        // TQ output value when SR is used (1'b0,1'b1)
.TBYTE_CTL("FALSE"),    // Enable tristate byte operation (FALSE, TRUE)
.TBYTE_SRC("FALSE"),    // Tristate byte source (FALSE, TRUE)
.TRISTATE_WIDTH(1)      // 3-state converter width (1,4)
)
OSERDESE2_inst_master (
.OFB(),             // 1-bit output: Feedback path for data
.OQ(ser_dat),               // 1-bit output: Data path output
// SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
.SHIFTOUT1(),
.SHIFTOUT2(),
.TBYTEOUT(),   // 1-bit output: Byte group tristate
.TFB(),             // 1-bit output: 3-state control
.TQ(),               // 1-bit output: 3-state control
.CLK(clk_5x),             // 1-bit input: High speed clock
.CLKDIV(clk_1x),       // 1-bit input: Divided clock
// D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
.D1(par_dat[0]),
.D2(par_dat[1]),
.D3(par_dat[2]),
.D4(par_dat[3]),
.D5(par_dat[4]),
.D6(par_dat[5]),
.D7(par_dat[6]),
.D8(par_dat[7]),
.OCE(1),             // 1-bit input: Output data clock enable
.RST(~rst_n),             // 1-bit input: Reset
// SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
.SHIFTIN1(shift_dat[0]),
.SHIFTIN2(shift_dat[1]),
// T1 - T4: 1-bit (each) input: Parallel 3-state inputs
.T1(0),
.T2(0),
.T3(0),
.T4(0),
.TBYTEIN(0),     // 1-bit input: Byte group tristate
.TCE(0)              // 1-bit input: 3-state clock enable
);

OSERDESE2 #(
.DATA_RATE_OQ("DDR"),   // DDR, SDR
.DATA_RATE_TQ("DDR"),   // DDR, BUF, SDR
.DATA_WIDTH(10),         // Parallel data width (2-8,10,14)
.INIT_OQ(1'b0),         // Initial value of OQ output (1'b0,1'b1)
.INIT_TQ(1'b0),         // Initial value of TQ output (1'b0,1'b1)
.SERDES_MODE("SLAVE"), // MASTER, SLAVE
.SRVAL_OQ(1'b0),        // OQ output value when SR is used (1'b0,1'b1)
.SRVAL_TQ(1'b0),        // TQ output value when SR is used (1'b0,1'b1)
.TBYTE_CTL("FALSE"),    // Enable tristate byte operation (FALSE, TRUE)
.TBYTE_SRC("FALSE"),    // Tristate byte source (FALSE, TRUE)
.TRISTATE_WIDTH(1)      // 3-state converter width (1,4)
)
OSERDESE2_inst_slave (
.OFB(),             // 1-bit output: Feedback path for data
.OQ(),               // 1-bit output: Data path output
// SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
.SHIFTOUT1(shift_dat[0]),
.SHIFTOUT2(shift_dat[1]),
.TBYTEOUT(),   // 1-bit output: Byte group tristate
.TFB(),             // 1-bit output: 3-state control
.TQ(),               // 1-bit output: 3-state control
.CLK(clk_5x),             // 1-bit input: High speed clock
.CLKDIV(clk_1x),       // 1-bit input: Divided clock
// D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
.D1(0),
.D2(0),
.D3(par_dat[8]),
.D4(par_dat[9]),
.D5(0),
.D6(0),
.D7(0),
.D8(0),
.OCE(1),             // 1-bit input: Output data clock enable
.RST(~rst_n),             // 1-bit input: Reset
// SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
.SHIFTIN1(0),
.SHIFTIN2(0),
// T1 - T4: 1-bit (each) input: Parallel 3-state inputs
.T1(0),
.T2(0),
.T3(0),
.T4(0),
.TBYTEIN(0),     // 1-bit input: Byte group tristate
.TCE(0)              // 1-bit input: 3-state clock enable
);
       
endmodule
