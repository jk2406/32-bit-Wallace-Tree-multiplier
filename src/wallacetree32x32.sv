`timescale 1ns/1ps
`timescale 1ns/1ps
module wallacetree32x32(
    input logic[31:0] a,
    input logic[31:0] b,
    output logic[63:0] prod
);
logic[63:0] p0,p1,p2,p3; 
logic[15:0] AL,AH,BL,BH;
assign p0[63:32] = {16{1'b0}};
assign p1[63:32] = {16{1'b0}};
assign p2[63:32] = {16{1'b0}};
assign p3[63:32] = {16{1'b0}};
always_comb begin 
    AL = a[15:0];
    BL = b[15:0];
    AH = a[31:16];
    BH = b[31:16];
end
wallacetree16x16 WT16x16_1(
    .a(AL),
    .b(BL),
    .prod(p0[31:0])
);
wallacetree16x16 WT16x16_2(
    .a(AL),
    .b(BH),
    .prod(p1[31:0])
);
wallacetree16x16 WT16x16_3(
    .a(AH),
    .b(BL),
    .prod(p2[31:0])
);
wallacetree16x16 WT16x16_4(
    .a(AH),
    .b(BH),
    .prod(p3[31:0])
);
logic[63:0] shift_p0,shift_p1,shift_p2,shift_p3;
always_comb begin 
    shift_p0 = p0;
    shift_p1 = p1<<16;
    shift_p2 = p2<<16;
    shift_p3 = p3<<32;
end
logic[63:0] sum1,sum2,sum3;
logic[63:0] carry1,carry2; 
logic[63:0] carry1_shift,carry2_shift; 
csa_64bit CSA_0(
    .A(shift_p0),
    .B(shift_p1),
    .C(shift_p2),
    .Sum(sum1),
    .Carry(carry1)
);
assign carry1_shift = carry1<<1;
csa_64bit CSA_1(
    .A(sum1),
    .B(carry1_shift),
    .C(shift_p3),
    .Sum(sum2),
    .Carry(carry2)
);
assign carry2_shift = carry2<<1;
logic dummy;
brent_kung_64 CLA_2(
    .A(sum2),
    .B(carry2_shift),
    .Cin(1'b0),
    .Sum(prod),
    .Cout(dummy)
);




endmodule