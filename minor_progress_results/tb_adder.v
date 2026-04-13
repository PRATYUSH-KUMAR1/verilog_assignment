`timescale 1ns/1ps

module tb_Adder;

  reg [31:0] a;
  reg [31:0] b;
  wire [31:0] out;

  // Instantiate DUT (Device Under Test)
  Adder uut (
    .a(a),
    .b(b),
    .out(out)
  );

  initial begin
    // Dump file for GTKWave
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_Adder);

    // Test cases
    a = 0; b = 0;
    #10;

    a = 10; b = 5;
    #10;

    a = 100; b = 200;
    #10;

    a = 32'hFFFFFFFF; b = 1;   // overflow case
    #10;

    a = 32'hAAAA5555; b = 32'h5555AAAA;
    #10;

    $finish;
  end

endmodule