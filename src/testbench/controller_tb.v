`timescale 1ms/1ms

module controller_tb;
   
    reg clk;
    reg [1:0] B, V;
    reg [1:0] B, V;
    wire [2:0] S;

   
    clk_timer CLK1(
        .clk(clk),
        .time32(time32)
    );

 
    state DUT(
        .clk(clk),
        .B(B),
        .V(V),
        .time32(time32),
        .S(S)
    );

   
    initial begin
     
        $dumpfile("traffic.vcd");   
        $dumpvars(0, controller_tb);         

        
        B = 0; V = 1; 
        #50000;                     
        B = 1;                     
        #20000;
        B = 0;              
        #3000;              

        $finish;                   
    end
endmodule
