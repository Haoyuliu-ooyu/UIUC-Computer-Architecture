// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op       (output) - control signal to be sent to the ALU
// writeenable  (output) - should a new value be captured by the register file
// rd_src       (output) - should the destination register be rd (0) or rt (1)
// alu_src2     (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except       (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register 
// mem_read     (output) - the register value written is coming from the memory
// word_we      (output) - we're writing a word's worth of data
// byte_we      (output) - we're only writing a byte's worth of data
// byte_load    (output) - we're doing a byte load
// slt          (output) - the instruction is an slt
// lui          (output) - the instruction is a lui
// addm         (output) - the instruction is an addm
// opcode        (input) - the opcode field from the instruction
// funct         (input) - the function field from the instruction
// zero          (input) - from the ALU
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, slt, lui, addm,
                   opcode, funct, zero);
    output [2:0] alu_op;
    output [1:0] alu_src2;
    output       writeenable, rd_src, except;
    output [1:0] control_type;
    output       mem_read, word_we, byte_we, byte_load, slt, lui, addm;
    input  [5:0] opcode, funct;
    input        zero;

    wire add = (opcode == `OP_OTHER0) && (funct == `OP0_ADD);
    wire sub = (opcode == `OP_OTHER0) && (funct == `OP0_SUB);
    wire and_ = (opcode == `OP_OTHER0) && (funct == `OP0_AND);
    wire or_ = (opcode == `OP_OTHER0) && (funct == `OP0_OR);
    wire nor_ = (opcode == `OP_OTHER0) && (funct == `OP0_NOR);
    wire xor_ = (opcode == `OP_OTHER0) && (funct == `OP0_XOR);
    wire addi = (opcode == `OP_ADDI);
    wire andi = (opcode == `OP_ANDI);
    wire ori = (opcode == `OP_ORI);
    wire xori = (opcode == `OP_XORI);
    wire beq = (opcode == `OP_BEQ);
    wire bne = (opcode == `OP_BNE);
    wire j = (opcode == `OP_J); //jtype
    wire jr = (opcode == `OP_OTHER0) && (funct == `OP0_JR); //jtype
    assign lui = (opcode == `OP_LUI);
    assign slt = (opcode == `OP_OTHER0) && (funct == `OP0_SLT);
    wire lw = (opcode == `OP_LW);
    wire lbu = (opcode == `OP_LBU);
    wire sw = (opcode == `OP_SW);
    wire sb = (opcode == `OP_SB);
    assign addm = (opcode == `OP_OTHER0) && (funct == `OP0_ADDM);

    assign rd_src = addi | andi | ori | xori | lw | lbu | lui;
    assign except = ~(add|sub|and_|or_|nor_|xor_|addi|andi|ori|xori|beq|bne|j|jr|lui|slt|lw|lbu|sw|sb|addm);
    assign writeenable = add|sub|and_|or_|nor_|xor_|addi|andi|ori|xori|lui|slt|lw|lbu|addm;

    assign alu_op = (add | addi | addm | lw | lbu | sw | sb) ? 3'b010 :
                    (sub | beq | bne | slt) ? 3'b011 :
                    (and_ | andi) ? 3'b100 :
                    (or_ | ori) ? 3'b101 :
                    (nor_) ? 3'b110 :
                    (xor_ | xori) ? 3'b111 :
                    0;
    assign alu_src2 = (add | sub | and_ | or_ | nor_ | xor_ | slt| beq | bne) ? 2'b00 :
                      (addi | lw | lbu | sw | sb) ? 2'b01 :
                      (andi | ori | xori) ? 2'b10 :
                      0;
    assign mem_read = lw|lbu;
    assign word_we = sw;
    assign byte_we = sb;
    assign byte_load = lbu;
    assign control_type = (add|sub|and_|or_|nor_|xor_|addi|andi|ori|xori|lui|slt|lw|lbu|sw|sb|addm) ? 2'b00 :
                            ((beq & zero) | (bne & ~zero)) ? 2'b01 :
                            (j) ? 2'b10 :
                            (jr) ? 2'b11 :
                            0;
endmodule // mips_decode
