module timer(TimerInterrupt, cycle, TimerAddress,
             data, address, MemRead, MemWrite, clock, reset);
    output        TimerInterrupt;
    output [31:0] cycle;
    output        TimerAddress;
    input  [31:0] data, address;
    input         MemRead, MemWrite, clock, reset;

    // complete the timer circuit here

    // HINT: make your interrupt cycle register reset to 32'hffffffff
    //       (using the reset_value parameter)
    //       to prevent an interrupt being raised the very first cycle
    wire [31:0] cyclecounter_in, cyclecounter_out, interrupt_cycle_out;
    wire TimerWrite, equal_1, acknowledge_or, Acknowledge, alu_val_1, equal_2, equal_3, TimerRead;

    //Cycle counter
    register cycle_counter(cyclecounter_out, cyclecounter_in, clock, 1, reset);
    //Interrupt cycle
    register #(32, 32'hffffffff) interrupt_cycle(interrupt_cycle_out, data, clock, TimerWrite, reset);
    // interrupt line
    register interrupt_line(TimerInterrupt, 1, clock, equal_1, acknowledge_or);
    //ALU
    alu32 a32(cyclecounter_in,,,`ALU_ADD, cyclecounter_out, alu_val_1);
    //tristate
    tristate t1(cycle, cyclecounter_out, TimerRead);

    assign alu_val_1 = 32'h1;
    assign equal_1 = (cyclecounter_out == interrupt_cycle_out);
    assign equal_2 = (address == 32'hffff001c);
    assign equal_3 = (address == 32'hffff006c);

    or o1(acknowledge_or, Acknowledge, reset);
    or o2(TimerAddress, equal_2, equal_3);
    and a1(TimerRead, equal_2, MemRead);
    and a2(TimerWrite, equal_2, MemWrite);
    and a3(Acknowledge, equal_3, MemWrite);


endmodule
