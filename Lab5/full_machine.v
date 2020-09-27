// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst, wdata, slt_out, wdata_1, nextPC_3, addm_1_, addm_2_;
    wire [31:0] PC, nextPC_1, nextPC_2, nextPC, wdata_0, slt_flag,
                 rsData, rtData, alu1_out, sign_e_out, loaded_data, overflow_flag,
                  zero_e_out, B_, data_mem_out, branch_offset, loaded_byte_32;
    wire [4:0] w_addr;
    wire wr_enable, rd_src, overflow, zero, negative, mem_read,
             word_we, byte_we, slt, lui, addm, byte_load, preslt;
    wire [1:0] alu_src2, control_type;
    wire [2:0] alu_op;
    wire [7:0] loaded_byte;

    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg( /* connect signals */ PC, nextPC, clock, 1'b1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im( /* connect signals */ inst, PC[31:2]);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf ( /* connect signals */ rsData, rtData, inst[25:21], inst[20:16],
                                 w_addr, wdata, wr_enable, clock, reset);

    data_mem datam(data_mem_out, addm_2_, rtData, word_we, byte_we, clock, reset);

    mux4v control_type_mux(nextPC, nextPC_1, nextPC_2, nextPC_3, rsData, control_type);

    assign nextPC_3 = {nextPC_1[31:28], inst[25:0], 2'b0};

    mux4v #(8) read_byte_mux4(loaded_byte, data_mem_out[7:0], data_mem_out[15:8], data_mem_out[23:16], data_mem_out[31:24], alu1_out[1:0]);
    
    assign loaded_byte_32 = {24'b0, loaded_byte};

    mux2v byte_load_mux2(loaded_data, data_mem_out, loaded_byte_32, byte_load);

    xor pre_slt(preslt, overflow, negative);

    assign slt_flag = {31'b0, preslt};

    mux2v slt_mux2(slt_out, alu1_out, preslt, slt);

    mux2v mem_read_mux2(wdata_0, slt_out, loaded_data, mem_read);

    assign wdata_1 = {inst[15:0], 16'b0};

    mux2v lui_mux2(wdata, wdata_0, wdata_1, lui);

    /* add other modules */
    mux2v #(5) S1 (w_addr, inst[15:11], inst[20:16], rd_src);

    mux3v S2 (B_, rtData, sign_e_out, zero_e_out, alu_src2);

    mux2v addm_1(addm_1_, rsData, data_mem_out, addm);

    mux2v addm_2(addm_2_, alu1_out, rsData, addm);

    alu32 alu_out(alu1_out, overflow, zero, negative, addm_1_, B_, alu_op);

    alu32 alu_add4(nextPC_1, , , , PC, 32'b100, 3'b010);

    assign branch_offset = sign_e_out << 2;

    alu32 alu_add_bof(nextPC_2, , , ,nextPC_1, branch_offset, 3'b010);

    mips_decode decoder(alu_op, wr_enable, rd_src, alu_src2, except,
                         control_type, mem_read, word_we, byte_we, byte_load, slt, lui, addm, inst[31:26], inst[5:0], zero);

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