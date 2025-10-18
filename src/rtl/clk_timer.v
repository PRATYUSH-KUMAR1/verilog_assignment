`timescale 1ms/1ms

/*
* This module generates the clock and secound timer.
* This clock is assumed to tick every 1ms.
*/
module clk_timer(
        output wire	clk,
        output wire [32:0] time32
        );

    // internal registers that stores state
    reg r_clk;
    reg [32:0] r_time32;

     // initialize registers
    initial begin
        r_clk = 1'b0;
        r_time32 = 32'b0;
    end

    // assume clk toggles every 1ms for #1.
    // hence secound timer increments by 1 after every #1000
    always #1 r_clk =~r_clk;
    always #1000 r_time32= r_time32 + 1;

    // wire out the registers
    assign clk = r_clk;
    assign time32 = r_time32;

endmodule