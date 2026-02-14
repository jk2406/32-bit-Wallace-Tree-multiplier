`timescale 1ns/1ps
module wallacetree16x16(
    input logic[15:0] a,
    input logic[15:0] b,
    output logic[31:0] prod
);
logic[31:0] p0,p1,p2,p3; 
logic[7:0] AL,AH,BL,BH;
assign p0[31:16] = {16{1'b0}};
assign p1[31:16] = {16{1'b0}};
assign p2[31:16] = {16{1'b0}};
assign p3[31:16] = {16{1'b0}};
always_comb begin 
    AL = a[7:0];
    BL = b[7:0];
    AH = a[15:8];
    BH = b[15:8];
end
wallacetree8x8 WT8x8_1(
    .a(AL),
    .b(BL),
    .prod(p0[15:0])
);
wallacetree8x8 WT8x8_2(
    .a(AL),
    .b(BH),
    .prod(p1[15:0])
);
wallacetree8x8 WT48x8_3(
    .a(AH),
    .b(BL),
    .prod(p2[15:0])
);
wallacetree8x8 WT8x8_4(
    .a(AH),
    .b(BH),
    .prod(p3[15:0])
);
logic[31:0] shift_p0,shift_p1,shift_p2,shift_p3;
always_comb begin 
    shift_p0 = p0;
    shift_p1 = p1<<8;
    shift_p2 = p2<<8;
    shift_p3 = p3<<16;
end
logic[31:0] sum1,sum2,sum3;
logic[31:0] carry1,carry2; 
logic[31:0] carry1_shift,carry2_shift; 
csa_32bit CSA_0(
    .A(shift_p0),
    .B(shift_p1),
    .C(shift_p2),
    .Sum(sum1),
    .Carry(carry1)
);
assign carry1_shift = carry1<<1;
csa_32bit CSA_1(
    .A(sum1),
    .B(carry1_shift),
    .C(shift_p3),
    .Sum(sum2),
    .Carry(carry2)
);
assign carry2_shift = carry2<<1;
logic dummy;
brent_kung_32 CLA_2(
    .A(sum2),
    .B(carry2_shift),
    .Cin(1'b0),
    .Sum(prod),
    .Cout(dummy)
);




endmodule