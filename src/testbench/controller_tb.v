`timescale 1ms/1ms
module tb;
    wire clk;
    wire [32:0] time32;
    reg [1:0] B, V;
    wire [2:0] S;

    // Instantiate clock generator
    clk_timer timer_inst(
        .clk(clk),
        .time32(time32)
    );

    // Instantiate controller
    state controller_inst(
        .clk(clk),
        .B(B),
        .V(V),
        .time32(time32),
        .S(S)
    );

    initial begin
        
        B = 0; V = 1;
        #20000 
    
        $finish;
    end
endmodule
