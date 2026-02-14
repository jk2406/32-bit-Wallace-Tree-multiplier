module csa_32bit(
    input  logic [31:0] A,
    input  logic [31:0] B,
    input  logic [31:0] C,
    output logic [31:0] Sum,
    output logic [31:0] Carry
);

    assign Sum   = A ^ B ^ C;
    assign Carry = (A & B) | (B & C) | (A & C);

endmodule
