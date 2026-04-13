`timescale 1ns/1ps

module tb_mux;

    reg [31:0] a, b;
    reg sel;
    wire [31:0] y;

    mux uut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_mux);

        // Test Case 1
        a = 32'hAAAAAAAA; 
        b = 32'h55555555; 
        sel = 0; 
        #10;

        // Test Case 2
        sel = 1; 
        #10;

        // Test Case 3
        a = 32'h12345678; 
        b = 32'h87654321; 
        sel = 0; 
        #10;

        // Test Case 4
        sel = 1; 
        #10;

        $finish;
    end

    initial begin
        $monitor("Time=%0t | sel=%b | a=%h | b=%h | y=%h",
                  $time, sel, a, b, y);
    end

endmodule