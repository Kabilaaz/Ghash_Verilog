`timescale 1ns/1ps

module gf64_UTmul(
    input [63:0] a, b,
    output reg [127:0] product
);

    always @(*) begin
        product = 128'b0;

        // UT multiplication is identical to convolution
        for (integer i = 0; i < 64; i = i + 1) begin
            for (integer j = 0; j < 64; j = j + 1) begin
                product[i+j] = product[i+j] ^ (a[i] & b[j]);
            end
        end
    end

endmodule
