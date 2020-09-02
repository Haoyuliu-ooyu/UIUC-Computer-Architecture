// 00 -> AND, 01 -> OR, 10 -> NOR, 11 -> XOR
module mux4v(out, A, B, C, D, control);
  output      out;
  input       A, B, C, D;
  input [1:0] control;

  wire  wA, wB, wC, wD;

  assign wA = A & (control == 2'b00);
  assign wB = B & (control == 2'b01);
  assign wC = C & (control == 2'b10);
  assign wD = D & (control == 2'b11);

  or  o1(out, wA, wB, wC, wD);

endmodule // mux4v

module logicunit(out, A, B, control);
    output      out;
    input       A, B;
    input [1:0] control;
    wire wa, wo, wno, wxo;
    and a1(wa, A, B);
    or o1(wo, A, B);
    nor no1(wno, A, B);
    xor xo1(wxo, A, B);
    mux4v mux4v1(out, wa, wo, wno, wxo, control);

endmodule // logicunit
