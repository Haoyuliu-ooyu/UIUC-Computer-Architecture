module pipelined_machine(clk, reset);
    input        clk, reset;

    wire [31:0]  PC;
    wire [31:2]  next_PC, PC_plus4, PC_target, PC_plus4_pip;
    wire [31:0]  inst, inst_bfpip;

    wire [31:0]  imm = {{ 16{inst[15]} }, inst[15:0] };  // sign-extended immediate
    wire [4:0]   rs = inst[25:21];
    wire [4:0]   rt = inst[20:16];
    wire [4:0]   rd = inst[15:11];
    wire [5:0]   opcode = inst[31:26];
    wire [5:0]   funct = inst[5:0];

    wire [4:0]   wr_regnum, wr_regnum_MW;
    wire [2:0]   ALUOp;

    wire         RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg,
                 RegDst, RegWrite_pip, MemRead_pip, 
                 MemWrite_pip, MemToReg_pip, RegDst_pip;
    wire         PCSrc, zero;
    wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data, load_data, wr_data, alu_out_data_pip, rd2_data_pip;


    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, /* enable */1'b1, reset);

    assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
    adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);
    adder30 target_PC_adder(PC_target, PC_plus4_pip, imm[29:0]);
    mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
    assign PCSrc = BEQ & zero;

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory imem(inst_bfpip, PC[31:2]);

    mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst,
                      opcode, funct);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rd1_data, rd2_data,
               rs, rt, wr_regnum_MW, wr_data,
               RegWrite_pip, clk, reset);

    mux2v #(32) imm_mux(B_data, rd2_data, imm, ALUSrc); 
    alu32 alu(alu_out_data, zero, ALUOp, rd1_data, B_data);

    // DO NOT comment out or rename this module
    // or the test bench will break
    data_mem data_memory(load_data, alu_out_data_pip, rd2_data_pip, MemRead_pip, MemWrite_pip, clk, reset);

    mux2v #(32) wb_mux(wr_data, alu_out_data_pip, load_data, MemToReg_pip);
    mux2v #(5) rd_mux(wr_regnum, rt, rd, RegDst);

    register #(30, 30'h0) IF_DE_PC(PC_plus4_pip, PC_plus4, clk, 1'b1, reset);
    register #(32, 32'h0) IF_DE_INST(inst, inst_bfpip, clk, 1'b1, reset);

    register #(5) DE_MW_regnum(wr_regnum_MW, wr_regnum, clk, 1'b1, PCSrc);
    register #(32, 32'h0) DE_MW_ALUOUT(alu_out_data_pip, alu_out_data, clk, 1'b1, PCSrc);
    register #(32, 32'h0) DE_MW_WRDATA(rd2_data_pip, rd2_data, clk, 1'b1, PCSrc);
    register #(1, 1'h0) DE_MW_RegWrite(RegWrite_pip, RegWrite, clk, 1'b1, PCSrc);
    register #(1, 1'h0) DE_MW_MemRead(MemRead_pip, MemRead, clk, 1'b1, PCSrc);
    register #(1, 1'h0) DE_MW_MemWrite(MemWrite_pip, MemWrite, clk, 1'b1, PCSrc);
    register #(1, 1'h0) DE_MW_MemToReg(MemToReg_pip, MemToReg, clk, 1'b1, PCSrc);
    register #(1, 1'h0) DE_MW_RegDst(RegDst_pip, RegDst, clk, 1'b1, PCSrc);

endmodule // pipelined_machine
