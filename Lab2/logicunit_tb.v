module logicunit_test;
    // exhaustively test your logic unit implementation by adapting mux4_tb.v
    reg A = 0;
    always #1 A = !A;
    reg B = 0;
    always #2 B = !B;
    
    reg [1:0] control = 0;

    wire out;
    logicunit l_test(out, A, B, control);

    initial begin
        $dumpfile("logicunit.vcd");
        $dumpvars(0, logicunit_test);

        # 4 control = 1;
        # 4 control = 2;
        # 4 control = 3;
        # 4 $finish;
    end

endmodule // logicunit_test
