// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock  (input)  - the clock signal
// reset  (input)  - set to 1 to set all registers to zero, set to 0 for normal execution.

module arith_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;  
    wire [31:0] PC, nextPC, rsData, rtData, out, sign_e_out, zero_e_out, B_;
    wire [4:0] w_addr;
    wire wr_enable, rd_src;
    wire [1:0] alu_src2;
    wire [2:0] alu_op;

    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg( /* connect signals */ PC, nextPC, clock, 1'b1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im( /* connect signals */ inst, PC[31:2]);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf ( /* connect signals */ rsData, rtData, inst[25:21], inst[20:16], w_addr, out, wr_enable, clock, reset);

    /* add other modules */
    mux2v #(5) S1 (w_addr, inst[15:11], inst[20:16], rd_src);

    mux3v S2 (B_, rtData, sign_e_out, zero_e_out, alu_src2);

    alu32 alu1(out, , , , rsData, B_, alu_op);

    alu32 alu2(nextPC, , , , PC, 32'b100, `ALU_ADD);

    mips_decode decoder(rd_src, wr_enable, alu_src2, alu_op, except, inst[31:26], inst[5:0]);

    sign_extender signExtention(sign_e_out, inst[15:0]);

    zero_extender zeroExtention(zero_e_out, inst[15:0]);
endmodule // arith_machine

module sign_extender(out, inp);
    output[31:0] out;
    input[15:0] inp;
    wire [15:0] a = {16{inp[15]}};
    assign out[31:0] = {a[15:0], inp[15:0]};
endmodule


module zero_extender(out, inp);
    output[31:0] out;
    input[15:0] inp;
    wire [15:0] a = 16'b0;
    assign out[31:0] = {a[15:0], inp[15:0]};
endmodule