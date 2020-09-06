//implement a test bench for your 32-bit ALU
module alu32_test;
    reg [31:0] A = 0, B = 0;
    reg [2:0] control = 0;

    initial begin
        $dumpfile("alu32.vcd");
        $dumpvars(0, alu32_test);

            A = 8; B = 4; control = `ALU_ADD; // try adding 8 and 4 = 12
            # 10 A = 2; B = 5; control = `ALU_SUB; // try subtracting 5 from 2 = -3
            # 10 A = 17; B = 18; control = `ALU_AND; // should be 16
            # 10 A = 17; B = 18; control = `ALU_OR; //should be 19
            # 10 A = 17; B = 18; control = `ALU_NOR; //should be -20
            # 10 A = 17; B = 18; control = `ALU_XOR; //should be 3
            # 10 A = 20; B = 20; control = `ALU_SUB; //should be zero
            # 10 A = 36; B = 32'h7ffffff0; control = `ALU_SUB; // should overflow
            # 10 A = 32'h40000000; B = 32'h40000000; control = `ALU_ADD; //should overflow
            # 10 A = 32'h80000000; B = 32'h80000000; control = `ALU_ADD; //should overflow
            # 10 A = 32'h40000000; B = 32'hf0000000; control = `ALU_SUB;
            # 10 A = 32'hffffffff; B = 32'hffffffff; control = `ALU_ADD;
            // add more test cases here!

            # 10 $finish;
    end

    wire [31:0] out;
    wire overflow, zero, negative;
    alu32 a(out, overflow, zero, negative, A, B, control);  
endmodule // alu32_test
