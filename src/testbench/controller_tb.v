`timescale 1ms/1ms

module controller_tb;
   
    reg clk;
    reg [1:0] B, V;
    wire [32:0] time32;
    wire [2:0] S;

   
    clk_timer CLK1(
        .clk(clk),
        .time32(time32)
    );

 
    controller U0(
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
        #5000;                     
        B = 1; V = 1;                     
        #2000;
        B = 0; V = 0;            
        #2000;               
        B = 1; V = 0;                     
        #3000;                

        $finish;                   
    end
endmodule
