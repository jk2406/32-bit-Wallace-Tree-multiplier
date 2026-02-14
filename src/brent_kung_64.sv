module brent_kung_64 (
    input  logic [63:0] A,
    input  logic [63:0] B,
    input  logic        Cin,
    output logic [63:0] Sum,
    output logic        Cout
);

logic [63:0] P, G;
logic [63:0] C;

// Stage 0: bitwise propagate & generate
assign P = A ^ B;
assign G = A & B;

// Prefix stages
logic [63:0] G1, P1;
logic [63:0] G2, P2;
logic [63:0] G3, P3;
logic [63:0] G4, P4;
logic [63:0] G5, P5;
logic [63:0] G6;

genvar i;

// ---- Stage 1 (distance 1) ----
assign G1[0] = G[0];
assign P1[0] = P[0];
generate
    for (i=1; i<64; i++) begin
        assign G1[i] = G[i] | (P[i] & G[i-1]);
        assign P1[i] = P[i] & P[i-1];
    end
endgenerate

// ---- Stage 2 (distance 2) ----
generate
    for (i=0; i<2; i++) begin
        assign G2[i] = G1[i];
        assign P2[i] = P1[i];
    end
    for (i=2; i<64; i++) begin
        assign G2[i] = G1[i] | (P1[i] & G1[i-2]);
        assign P2[i] = P1[i] & P1[i-2];
    end
endgenerate

// ---- Stage 3 (distance 4) ----
generate
    for (i=0; i<4; i++) begin
        assign G3[i] = G2[i];
        assign P3[i] = P2[i];
    end
    for (i=4; i<64; i++) begin
        assign G3[i] = G2[i] | (P2[i] & G2[i-4]);
        assign P3[i] = P2[i] & P2[i-4];
    end
endgenerate

// ---- Stage 4 (distance 8) ----
generate
    for (i=0; i<8; i++) begin
        assign G4[i] = G3[i];
        assign P4[i] = P3[i];
    end
    for (i=8; i<64; i++) begin
        assign G4[i] = G3[i] | (P3[i] & G3[i-8]);
        assign P4[i] = P3[i] & P3[i-8];
    end
endgenerate

// ---- Stage 5 (distance 16) ----
generate
    for (i=0; i<16; i++) begin
        assign G5[i] = G4[i];
        assign P5[i] = P4[i];
    end
    for (i=16; i<64; i++) begin
        assign G5[i] = G4[i] | (P4[i] & G4[i-16]);
        assign P5[i] = P4[i] & P4[i-16];
    end
endgenerate

// ---- Stage 6 (distance 32) ----
generate
    for (i=0; i<32; i++) begin
        assign G6[i] = G5[i];
    end
    for (i=32; i<64; i++) begin
        assign G6[i] = G5[i] | (P5[i] & G5[i-32]);
    end
endgenerate

// ---- Carry Calculation ----
assign C[0] = Cin;

generate
    for (i=1; i<64; i++) begin
        assign C[i] = G6[i-1] | (P[i-1] & Cin);
    end
endgenerate

assign Cout = G6[63] | (P[63] & Cin);

// ---- Sum ----
assign Sum = P ^ C;

endmodule
