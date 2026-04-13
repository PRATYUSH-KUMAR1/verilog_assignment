module registerFile (
    input clk,
    input regWrite,

    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,

    input [31:0] writeData,

    output [31:0] readData1,
    output [31:0] readData2
);

    reg [31:0] registers [0:31];

    // Initialize registers
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] = 32'b0;
    end

    // Read (combinational)
    assign readData1 = (rs1 == 0) ? 32'b0 : registers[rs1];
    assign readData2 = (rs2 == 0) ? 32'b0 : registers[rs2];

    // Write (synchronous)
    always @(posedge clk) begin
        if (regWrite && rd != 0)
            registers[rd] <= writeData;
    end

endmodule