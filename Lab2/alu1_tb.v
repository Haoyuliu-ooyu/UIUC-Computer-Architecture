module alu1_test;
    // exhaustively test your 1-bit ALU implementation by adapting mux4_tb.v
    reg A = 0;
    always #1 A = !A;
    reg B = 0;
    always #2 B = !B;
    reg carryin = 0;
    always #4 carryin = !carryin;

    reg [2:0] control = 2;

    wire out, carryout;

    alu1 alu1_test(out, carryout, A, B, carryin, control);

    initial begin
        $dumpfile("alu1.vcd");
        $dumpvars(0, alu1_test);

        #8 control = 3;
        #8 control = 4;
        #8 control = 5;
        #8 control = 6;
        #8 control = 7;
        #8 $finish;
    end

endmodule //alu1_test
