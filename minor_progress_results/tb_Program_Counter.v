`timescale 1ns/1ps

module tb_Program_Counter;

    reg clk;
    reg reset;
    reg [31:0] pc_in;
    wire [31:0] pc_out;

    Program_Counter uut (
        .clk(clk),
        .reset(reset),
        .pc_in(pc_in),
        .pc_out(pc_out)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_Program_Counter);

        clk = 0;
        reset = 1;
        pc_in = 0;

        #10;
        reset = 0;

        // Simulate PC increment
        pc_in = 4;   #10;
        pc_in = 8;   #10;
        pc_in = 12;  #10;
        pc_in = 16;  #10;

        // Reset again
        reset = 1; #10;
        reset = 0;

        pc_in = 20; #10;

        $finish;
    end

    initial begin
        $monitor("Time=%0t | reset=%b | pc_in=%d | pc_out=%d",
                  $time, reset, pc_in, pc_out);
    end

endmodule