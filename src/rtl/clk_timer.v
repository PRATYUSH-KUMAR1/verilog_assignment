`timescale 1ms/1ms

/*
* this module generates the clock and secound timer.
* this clk is assumed to tick every 1ms.
*/
module clk_timer(
		output wire	clk;
		output wire [32:0] time32
		);

    // internal register that stores state
    reg r_clk;
    reg [32:0] r_time32;

     // initialize register
    initial begin
    	r_clk = 1'b0;
    	r_time32 = 32'b0;
    end

    // assume clk toggles every 1ms for #1.
    // hence secound time incement by 1 after every #1000
    always #1 r_clk =~r_clk;
    always #1000 r_time32= r_time32 + 1;

    // wire out the register
    assign clk = r_clk;
    assign time32 = r_time32;

endmodule