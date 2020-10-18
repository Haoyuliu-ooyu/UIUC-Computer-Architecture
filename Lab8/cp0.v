`define STATUS_REGISTER 5'd12
`define CAUSE_REGISTER  5'd13
`define EPC_REGISTER    5'd14

module cp0(rd_data, EPC, TakenInterrupt,
           wr_data, regnum, next_pc,
           MTC0, ERET, TimerInterrupt, clock, reset);
    output [31:0] rd_data;
    output [29:0] EPC;
    output        TakenInterrupt;
    input  [31:0] wr_data;
    input   [4:0] regnum;
    input  [29:0] next_pc;
    input         MTC0, ERET, TimerInterrupt, clock, reset;

    // your Verilog for coprocessor 0 goes here
    wire regnum_12, regnum_14, exception_level_reset, ands1s0, andc15s15, exception_level, epc_enable;
    wire [31:0] user_status, dec_out, cause_reg, status_reg, epc_out;
    wire [29:0] epc_in;
    register user_status_reg(user_status, wr_data, clock, regnum_12, reset);
    register #(1) exception_level_reg(exception_level, 1'b1, clock, TakenInterrupt, exception_level_reset);
    register #(30) epc_register(EPC, epc_in, clock, epc_enable, reset);
    decoder32 dec(dec_out, regnum, MTC0);

    mux2v #(30) m2(epc_in, wr_data[31:2], next_pc, TakenInterrupt);
    assign rd_data = (regnum == `STATUS_REGISTER) ? status_reg:
                     (regnum == `CAUSE_REGISTER) ? cause_reg :
                     (regnum == `EPC_REGISTER) ? epc_out:
                     32'b0;

    assign epc_out = {EPC, 2'b0};
    assign regnum_12 = dec_out[12];
    assign regnum_14 = dec_out[14];

    assign cause_reg[31:16] = {16{1'b0}};
    assign cause_reg[15] = TimerInterrupt;
    assign cause_reg[14:0] = {15{1'b0}};
    assign status_reg[31:16] = {16{1'b0}};
    assign status_reg[15:8] = user_status[15:8];
    assign status_reg[7:2] = {6{1'b0}};
    assign status_reg[1] = exception_level;
    assign status_reg[0] = user_status[0];

    or o1(exception_level_reset, reset, ERET);
    or o2(epc_enable, TakenInterrupt, regnum_14);
    and a1(ands1s0, ~status_reg[1], status_reg[0]);
    and a2(andc15s15, cause_reg[15], status_reg[15]);
    and a3(TakenInterrupt, ands1s0, andc15s15);

endmodule
