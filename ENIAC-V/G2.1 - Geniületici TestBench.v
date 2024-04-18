`timescale 1ns / 1ps

module expender();
    reg [15:0] compressed;
    wire [31:0] expanded;

    expander uut (
        .compressed(compressed),
        .expanded(expanded)
    );

    initial begin
        compressed = 16'h0000;
        #1;
        assert(expanded == 32'h000000010000);
        $display("Test 1 passed");

        compressed = 16'hffff;
        #1;
        assert(expanded == 32'h0000ffff0001);
        $display("Test 2 passed");

        compressed = 16'h1234;
        #1;
        assert(expanded == 32'h000012340001);
        $display("Test 3 passed");

        $finish;
    end
endmodule