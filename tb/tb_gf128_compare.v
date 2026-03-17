`timescale 1ns/1ps

module tb_gf128_compare;

    reg  [127:0] a, b;
    wire [255:0] prod_naive;
    wire [255:0] prod_kara;
    wire [255:0] prod_karaUT;
    wire [255:0] prod_UT;

    integer test;

    // Golden reference: naive multiplier
    gf128_naive u_naive (
        .a(a),
        .b(b),
        .product(prod_naive)
    );

    // DUT: Karatsuba multiplier
    gf128_karatsuba u_kara (
        .a(a),
        .b(b),
        .product(prod_kara)
    );

    // DUT: Karatsuba UT multiplier
    gf128_karatsuba u_karaUT (
        .a(a),
        .b(b),
        .product(prod_karaUT)
    );
    
    // DUT: 128-bit UT multiplier
    gf128_UTmul u_UT (
        .a(a),
        .b(b),
        .product(prod_UT)
    );

    initial begin
        $dumpfile("gf128_compare.vcd");
        $dumpvars;
    end

    initial begin
        $display("Starting GF(2^128) Karatsuba vs Naive comparison...");

        // Simple sanity test
        a = 128'h1;
        b = 128'h1;
        #1;
        if (prod_naive !== prod_kara) begin
            $display("ERROR: 1 x 1 mismatch");
            $stop;
        end

        // Random tests
        for (test = 0; test < 500; test = test + 1) begin
            a = {$random, $random, $random, $random};
            b = {$random, $random, $random, $random};
            #1;

            if (prod_naive !== prod_kara) begin
                $display("Mismatch at test %0d", test);
                $display("a      = %032h", a);
                $display("b      = %032h", b);
                $display("Naive  = %064h", prod_naive);
                $display("Kara   = %064h", prod_kara);
                $stop;
            end
        end

        $display("PASS: Karatsuba matches naive for all tests.");

        $display("Starting GF(2^128) Karatsuba UT vs Naive comparison...");

        // Simple sanity test
        a = 128'h1;
        b = 128'h1;
        #1;
        if (prod_naive !== prod_kara) begin
            $display("ERROR: 1 x 1 mismatch");
            $stop;
        end

        // Random tests
        for (test = 0; test < 500; test = test + 1) begin
            a = {$random, $random, $random, $random};
            b = {$random, $random, $random, $random};
            #1;

            if (prod_naive !== prod_karaUT) begin
                $display("Mismatch at test %0d", test);
                $display("a      = %032h", a);
                $display("b      = %032h", b);
                $display("Naive  = %064h", prod_naive);
                $display("Kara   = %064h", prod_karaUT);
                $stop;
            end
        end

        $display("PASS: Karatsuba UT matches naive for all tests.");

        $display("Starting GF(2^128) UT vs Naive comparison...");

        // Simple sanity test
        #1;
        a = 128'h1;
        b = 128'h1;
        #1;
        if (prod_naive !== prod_UT) begin
            $display("ERROR: 1 x 1 mismatch");
            $stop;
        end

        // Random tests
        for (test = 0; test < 500; test = test + 1) begin
            a = {$random, $random, $random, $random};
            b = {$random, $random, $random, $random};
            #1;

            if (prod_naive !== prod_UT) begin
                $display("Mismatch at test %0d", test);
                $display("a      = %032h", a);
                $display("b      = %032h", b);
                $display("Naive  = %064h", prod_naive);
                $display("UT   = %064h", prod_UT);
                $stop;
            end
        end

        $display("PASS: UT_128 matches naive for all tests.");

        $finish;
    end

endmodule

