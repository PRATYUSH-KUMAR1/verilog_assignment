`timescale 1ms/1ms

module controller_tb;

    reg [1:0] B, V;
    wire clk;
    wire [32:0] time32;
    wire [2:0] S;

    // instantiate the clock generator
    clk_timer CLK1 (
        .clk(clk),
        .time32(time32)
    );

    // instantiate the traffic controller
    controller U0 (
        .clk(clk),
        .B(B),
        .V(V),
        .time32(time32),
        .S(S)
    );

    // test sequence
    initial begin
        $dumpfile("traffic.vcd");
        $dumpvars(0, controller_tb);

        B = 0; V = 1;
        #50000;
        B = 1; V = 1;
        #20000;
        B = 0; V = 0;
        #80000;
        B = 1; V = 0;
        #70000;

        $finish;
    end

endmodule
