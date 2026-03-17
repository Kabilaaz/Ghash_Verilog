`timescale 1ns/1ps

module gf128_UTmul(
    input [127:0] a, b,
    output reg [255:0] product
);

    always @(*) begin
        product = 256'b0;

        // UT multiplication is identical to convolution
        for (integer i = 0; i < 128; i = i + 1) begin
            for (integer j = 0; j < 128; j = j + 1) begin
                product[i+j] = product[i+j] ^ (a[i] & b[j]);
            end
        end
    end

endmodule

