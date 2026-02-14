module csa_64bit(
    input  logic [63:0] A,
    input  logic [63:0] B,
    input  logic [63:0] C,
    output logic [63:0] Sum,
    output logic [63:0] Carry
);

    assign Sum   = A ^ B ^ C;
    assign Carry = (A & B) | (B & C) | (A & C);

endmodule
