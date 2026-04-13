`timescale 1ns/1ps

module tb_extractor;

    reg [31:0] instruction;
    wire [31:0] imm_data;

    extractor uut (
        .instruction(instruction),
        .imm_data(imm_data)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_extractor);

        // I-type (ADDI)
        instruction = 32'b000000000101_00000_000_00001_0010011;
        #10;

        // S-type (SW)
        instruction = 32'b0000000_00010_00001_010_00100_0100011;
        #10;

        // B-type (BEQ)
        instruction = 32'b0000000_00010_00001_000_00010_1100011;
        #10;

        // U-type (LUI)
        instruction = 32'b00000000000000000001_00001_0110111;
        #10;

        // J-type (JAL)
        instruction = 32'b00000000000100000000_00001_1101111;
        #10;

        $finish;
    end

endmodule