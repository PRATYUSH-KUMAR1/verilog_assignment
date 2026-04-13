`timescale 1ns/1ps

module tb_Instruction_Memory;

    reg [31:0] addr;
    wire [31:0] instruction;

    Instruction_Memory uut (
        .addr(addr),
        .instruction(instruction)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_Instruction_Memory);

        // Test different addresses
        addr = 0;   #10;
        addr = 4;   #10;
        addr = 8;   #10;
        addr = 12;  #10;
        addr = 16;  #10;

        $finish;
    end

    initial begin
        $monitor("Time=%0t | Addr=%h | Instruction=%h",
                  $time, addr, instruction);
    end

endmodule