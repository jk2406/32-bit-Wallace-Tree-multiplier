`timescale 1ns/1ps

module wallacetree4x4(
    input  [3:0] a,
    input  [3:0] b,
    output [7:0] prod
);

// ==========================================================
// Partial Products (Pure Structural)
// ==========================================================

wire p00 = a[0] & b[0];
wire p01 = a[1] & b[0];
wire p02 = a[2] & b[0];
wire p03 = a[3] & b[0];

wire p10 = a[0] & b[1];
wire p11 = a[1] & b[1];
wire p12 = a[2] & b[1];
wire p13 = a[3] & b[1];

wire p20 = a[0] & b[2];
wire p21 = a[1] & b[2];
wire p22 = a[2] & b[2];
wire p23 = a[3] & b[2];

wire p30 = a[0] & b[3];
wire p31 = a[1] & b[3];
wire p32 = a[2] & b[3];
wire p33 = a[3] & b[3];

// ==========================================================
// First stage compression
// ==========================================================

assign prod[0] = p00;

wire s11, c11;
half_adder HA1 (p01, p10, s11, c11);

wire s21, c21;
full_adder FA1 (p02, p11, p20, s21, c21);

wire s31, c31;
full_adder FA2 (p03, p12, p21, s31, c31);

wire s41, c41;
full_adder FA3 (p13, p22, p31, s41, c41);

wire s51, c51;
half_adder HA2 (p23, p32, s51, c51);

// ==========================================================
// Second stage compression
// ==========================================================

assign prod[1] = s11;

wire s22, c22;
half_adder HA3 (s21, c11, s22, c22);

wire s32, c32;
full_adder FA4 (s31, c21, c22, s32, c32);

wire s42, c42;
full_adder FA5 (s41, c31, c32, s42, c42);

wire s52, c52;
full_adder FA6 (s51, c41, c42, s52, c52);

wire s62, c62;
half_adder HA4 (p33, c51, s62, c62);

// ==========================================================
// Final Ripple Addition
// ==========================================================

assign prod[2] = s22;

wire s33, c33;
half_adder HA5 (s32, c22, s33, c33);
assign prod[3] = s33;

wire s44, c44;
full_adder FA7 (s42, c33, 1'b0, s44, c44);
assign prod[4] = s44;

wire s55, c55;
full_adder FA8 (s52, c44, 1'b0, s55, c55);
assign prod[5] = s55;

wire s66, c66;
full_adder FA9 (s62, c55, 1'b0, s66, c66);
assign prod[6] = s66;

assign prod[7] = c62 | c66;

endmodule
