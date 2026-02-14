`timescale 1ns/1ps
module wallacetree8x8(
    input logic[7:0] a,
    input logic[7:0] b,
    output logic[15:0] prod
);
logic[15:0] p0,p1,p2,p3; 
logic[3:0] AL,AH,BL,BH;
assign p0[15:8] = {8{1'b0}};
assign p1[15:8] = {8{1'b0}};
assign p2[15:8] = {8{1'b0}};
assign p3[15:8] = {8{1'b0}};
always_comb begin 
    AL = a[3:0];
    BL = b[3:0];
    AH = a[7:4];
    BH = b[7:4];
end
wallacetree4x4 WT4x4_1(
    .a(AL),
    .b(BL),
    .prod(p0[7:0])
);
wallacetree4x4 WT4x4_2(
    .a(AL),
    .b(BH),
    .prod(p1[7:0])
);
wallacetree4x4 WT4x4_3(
    .a(AH),
    .b(BL),
    .prod(p2[7:0])
);
wallacetree4x4 WT4x4_4(
    .a(AH),
    .b(BH),
    .prod(p3[7:0])
);
logic[15:0] shift_p0,shift_p1,shift_p2,shift_p3;
always_comb begin 
    shift_p0 = p0;
    shift_p1 = p1<<4;
    shift_p2 = p2<<4;
    shift_p3 = p3<<8;
end
logic[15:0] sum1,sum2,sum3;
logic[15:0] carry1,carry2; 
logic[15:0] carry1_shift,carry2_shift; 
csa_16bit CSA_0(
    .A(shift_p0),
    .B(shift_p1),
    .C(shift_p2),
    .Sum(sum1),
    .Carry(carry1)
);
assign carry1_shift = carry1<<1;
csa_16bit CSA_1(
    .A(sum1),
    .B(carry1_shift),
    .C(shift_p3),
    .Sum(sum2),
    .Carry(carry2)
);
assign carry2_shift = carry2<<1;
logic dummy;
cla_16bit CLA_2(
    .A(sum2),
    .B(carry2_shift),
    .Cin(1'b0),
    .Sum(prod),
    .Cout(dummy)
);




endmodule