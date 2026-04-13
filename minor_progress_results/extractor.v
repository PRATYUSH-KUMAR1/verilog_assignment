module extractor (
    input  [31:0] instruction,
    output reg [31:0] imm_data
);

always @(*) begin
    case (instruction[6:0])  // opcode

        // I-type (e.g., ADDI, LW)
        7'b0010011,
        7'b0000011: begin
            imm_data = {{20{instruction[31]}}, instruction[31:20]};
        end

        // S-type (e.g., SW)
        7'b0100011: begin
            imm_data = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
        end

        // B-type (branch)
        7'b1100011: begin
            imm_data = {{19{instruction[31]}},
                        instruction[31],
                        instruction[7],
                        instruction[30:25],
                        instruction[11:8],
                        1'b0};
        end

        // U-type (LUI, AUIPC)
        7'b0110111,
        7'b0010111: begin
            imm_data = {instruction[31:12], 12'b0};
        end

        // J-type (JAL)
        7'b1101111: begin
            imm_data = {{11{instruction[31]}},
                        instruction[31],
                        instruction[19:12],
                        instruction[20],
                        instruction[30:21],
                        1'b0};
        end

        default: begin
            imm_data = 32'b0;
        end
    endcase
end

endmodule