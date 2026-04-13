`timescale 1ms/1ms

module controller_tb;

    reg [1:0] B;
    reg [2:0] V;
    wire clk;
    wire [32:0] time32;
    wire [2:0] S;
    
   
    // instantiate the clock generator
    clk_timer CLK1 (
        .clk(clk),
        .time32(time32)
    );

    // instantiate the traffic controller
    controller utt (
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

        B = 2'b00; V = 3'b000;
        #50000;
        // TESTCASE 1: EW only (car waiting on EW)
        V = 3'b100; // EW car
        #30000; // run 30 s

        // TESTCASE 2: MR only, button pressed during MR green
        V = 3'b010; // MR car
        #50000;    // let MR green start
        B = 2'b01; // press ped button during MR green
        #10000;
        B = 2'b00; // release button (latched)
        #20000;

        // TESTCASE 3: No cars anywhere, press ped button (should go to ped)
        V = 3'b000;
        #10000;
        B = 2'b11;
        #10000;
        B = 2'b00;
        #20000;

        // TESTCASE 4: Car leaves during green (simulate early termination)
        V = 3'b001; // OBH car
        #20000;
        V = 3'b000; // car leaves during green -> should shorten green
        #50000;

        $finish;
    end

endmodule
