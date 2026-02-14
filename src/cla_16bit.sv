`timescale 1ns/1ps
module cla_16bit (
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] Sum,
    output        Cout
);

    wire [3:0] P_group, G_group;
    wire C4, C8, C12;

    // First 4-bit block
    cla_4bit CLA0 (
        .A(A[3:0]),
        .B(B[3:0]),
        .Cin(Cin),
        .Sum(Sum[3:0]),
        .Cout(),
        .P_group(P_group[0]),
        .G_group(G_group[0])
    );

    // Block Carry Logic
    assign C4 = G_group[0] | (P_group[0] & Cin);

    cla_4bit CLA1 (
        .A(A[7:4]),
        .B(B[7:4]),
        .Cin(C4),
        .Sum(Sum[7:4]),
        .Cout(),
        .P_group(P_group[1]),
        .G_group(G_group[1])
    );

    assign C8 = G_group[1] 
              | (P_group[1] & G_group[0]) 
              | (P_group[1] & P_group[0] & Cin);

    cla_4bit CLA2 (
        .A(A[11:8]),
        .B(B[11:8]),
        .Cin(C8),
        .Sum(Sum[11:8]),
        .Cout(),
        .P_group(P_group[2]),
        .G_group(G_group[2])
    );

    assign C12 = G_group[2] 
               | (P_group[2] & G_group[1]) 
               | (P_group[2] & P_group[1] & G_group[0]) 
               | (P_group[2] & P_group[1] & P_group[0] & Cin);

    cla_4bit CLA3 (
        .A(A[15:12]),
        .B(B[15:12]),
        .Cin(C12),
        .Sum(Sum[15:12]),
        .Cout(),
        .P_group(P_group[3]),
        .G_group(G_group[3])
    );

    assign Cout = G_group[3]
                | (P_group[3] & G_group[2])
                | (P_group[3] & P_group[2] & G_group[1])
                | (P_group[3] & P_group[2] & P_group[1] & G_group[0])
                | (P_group[3] & P_group[2] & P_group[1] & P_group[0] & Cin);

endmodule
