module expander(
    // Map C instructions to RV32I
    input [15:0] compressed,
    output [31:0] expanded
    );
    wire [31:0] temp;
    assign temp[15:0] = compressed;
    assign temp[31:16] = 0;
    assign temp[29] = 1;
    assign expanded = temp;
endmodule