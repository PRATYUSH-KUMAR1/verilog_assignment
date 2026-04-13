`timescale 1ns/1ps

module tb_registerFile;

    reg clk;
    reg regWrite;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] writeData;

    wire [31:0] readData1, readData2;

    registerFile uut (
        .clk(clk),
        .regWrite(regWrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .writeData(writeData),
        .readData1(readData1),
        .readData2(readData2)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_registerFile);

        clk = 0;
        regWrite = 0;

        // Write to x1
        rd = 5'd1;
        writeData = 32'd100;
        regWrite = 1;
        #10;

        // Write to x2
        rd = 5'd2;
        writeData = 32'd200;
        #10;

        // Disable write
        regWrite = 0;

        // Read x1 and x2
        rs1 = 5'd1;
        rs2 = 5'd2;
        #10;

        // Try writing to x0 (should NOT change)
        regWrite = 1;
        rd = 5'd0;
        writeData = 32'd999;
        #10;

        rs1 = 5'd0;
        #10;

        $finish;
    end

    initial begin
        $monitor("Time=%0t | rs1=%d rs2=%d rd=%d | WD=%d | RD1=%d RD2=%d",
                  $time, rs1, rs2, rd, writeData, readData1, readData2);
    end

endmodule