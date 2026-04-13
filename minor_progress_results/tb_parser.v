`timescale 1ns/1ps

module tb_parser;

    reg [31:0] instruction;

    wire [6:0] opcode;
    wire [4:0] rd, rs1, rs2;
    wire [2:0] funct3;
    wire [6:0] funct7;

    parser uut (
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7(funct7)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_parser);

        // Example: ADD x3, x1, x2
        instruction = 32'b0000000_00010_00001_000_00011_0110011;
        #10;

        // Example: SUB x5, x3, x4
        instruction = 32'b0100000_00100_00011_000_00101_0110011;
        #10;

        // Example: ADDI x1, x0, 10
        instruction = 32'b000000001010_00000_000_00001_0010011;
        #10;

        $finish;
    end

    initial begin
        $monitor("Time=%0t | instr=%h | opcode=%b | rd=%d | rs1=%d | rs2=%d | funct3=%b | funct7=%b",
                  $time, instruction, opcode, rd, rs1, rs2, funct3, funct7);
    end

endmodule