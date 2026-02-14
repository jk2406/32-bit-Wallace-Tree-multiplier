`timescale 1ns/1ps
module cla_4bit (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout,
    output       P_group,
    output       G_group
);

    wire [3:0] P, G;
    wire C1, C2, C3, C4;

    // Propagate and Generate
    assign P = A ^ B;
    assign G = A & B;

    // Carry Look Ahead Logic
    assign C1 = G[0] | (P[0] & Cin);
    assign C2 = G[1] | (P[1] & G[0]) 
                        | (P[1] & P[0] & Cin);

    assign C3 = G[2] | (P[2] & G[1]) 
                        | (P[2] & P[1] & G[0]) 
                        | (P[2] & P[1] & P[0] & Cin);

    assign C4 = G[3] | (P[3] & G[2]) 
                        | (P[3] & P[2] & G[1]) 
                        | (P[3] & P[2] & P[1] & G[0]) 
                        | (P[3] & P[2] & P[1] & P[0] & Cin);

    // Sum
    assign Sum[0] = P[0] ^ Cin;
    assign Sum[1] = P[1] ^ C1;
    assign Sum[2] = P[2] ^ C2;
    assign Sum[3] = P[3] ^ C3;

    assign Cout = C4;

    // Group Propagate & Generate
    assign P_group = P[3] & P[2] & P[1] & P[0];

    assign G_group = G[3] 
                    | (P[3] & G[2])
                    | (P[3] & P[2] & G[1])
                    | (P[3] & P[2] & P[1] & G[0]);

endmodule
