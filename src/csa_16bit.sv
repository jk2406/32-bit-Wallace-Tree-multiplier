`timescale 1ns/1ps
//CARRY SAVE ADDER
module csa_16bit(
    input  logic [15:0] A,
    input  logic [15:0] B,
    input  logic [15:0] C,
    output logic [15:0] Sum,
    output logic [15:0] Carry
);

    assign Sum   = A ^ B ^ C;
    assign Carry = (A & B) | (B & C) | (A & C);

endmodule
