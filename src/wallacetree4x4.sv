`timescale 1ns/1ps
module wallacetree4x4(
    input logic[3:0] a,
    input logic[3:0] b,
    output logic[7:0] prod
);
logic[15:0] pp;
int i,j;
logic c6,c7;
logic [1:0] c1,c5;
logic[2:0] c2,c4;
logic[3:0] c3;
always_comb begin
    pp[0]  = a[0] & b[0];
    pp[1]  = a[1] & b[0];
    pp[2]  = a[2] & b[0];
    pp[3]  = a[3] & b[0];

    pp[4]  = a[0] & b[1];
    pp[5]  = a[1] & b[1];
    pp[6]  = a[2] & b[1];
    pp[7]  = a[3] & b[1];

    pp[8]  = a[0] & b[2];
    pp[9]  = a[1] & b[2];
    pp[10] = a[2] & b[2];
    pp[11] = a[3] & b[2];

    pp[12] = a[0] & b[3];
    pp[13] = a[1] & b[3];
    pp[14] = a[2] & b[3];
    pp[15] = a[3] & b[3];
end

always_comb begin 
    prod[0] = pp[0];

    c1 = {pp[1],  pp[4]};
    c2 = {pp[2],  pp[5],  pp[8]};
    c3 = {pp[3],  pp[6],  pp[9],  pp[12]};
    c4 = {pp[7],  pp[10], pp[13]};
    c5 = {pp[11], pp[14]};
    c6 =  pp[15];
    c7 = 0;
end





// initial begin

//     $strobe("Beginning vars are\nc0:%b\nc1:%b\nc2:%b\nc3:%b\nc4:%b\nc5:%b\nc6:%b",pp[0][0],c1,c2,c3,c4,c5,c6);
// end
//=====================================================================
//FIRST COMPRESSION
//=====================================================================
// AdderColumn_Iteration is the naming convention
// In column_temp vars,at 0th is the carry from prev stage at 1st position is the sum of current
logic      c1_temp_1;
logic[1:0] c2_temp_1;
logic[1:0] c3_temp_1;
logic[1:0] c4_temp_1;
logic[1:0] c5_temp_1;
logic c6_temp_1;
logic c7_temp_1;
half_adder HA1_1(
    .a(c1[0]),
    .b(c1[1]),
    .sum(c1_temp_1),
    .cout(c2_temp_1[0])
);

full_adder FA2_1(
    .a(c2[0]),
    .b(c2[1]),
    .cin(c2[2]),
    .sum(c2_temp_1[1]),
    .cout(c3_temp_1[0])
);
full_adder FA3_1(
    .a(c3[0]),
    .b(c3[1]),
    .cin(c3[2]),
    .sum(c3_temp_1[1]),
    .cout(c4_temp_1[0])
);
full_adder FA4_1(
    .a(c4[0]),
    .b(c4[1]),
    .cin(c4[2]),
    .sum(c4_temp_1[1]),
    .cout(c5_temp_1[0])
);
half_adder HA5_1(
    .a(c5[0]),
    .b(c5[1]),
    .sum(c5_temp_1[1]),
    .cout(c6_temp_1)
);

logic[1:0] c5_1;
logic[1:0] c6_1;
logic[1:0] c2_1,c4_1;
logic[2:0] c3_1;
always_comb begin 
    prod[1] = c1_temp_1;
    c2_1 = {c2_temp_1[1],c2_temp_1[0]};
    c3_1 = {c3_temp_1[1],c3[3],c3_temp_1[0]};
    c4_1 = {c4_temp_1[1],c4_temp_1[0]};
    c5_1 = {c5_temp_1[1],c5_temp_1[0]};
    c6_1 = {c6,c6_temp_1};
end
// initial begin
//     #1;
//     $strobe("At the end of 1st compression values are\nc1:%b\nc2:%b\nc3:%b\nc4:%b\nc5:%b\nc6:%b",c1_temp_1,c2_1,c3_1,c4_1,c5_1,c6_1);
// end
//===============================================================
//SECOND COMPRESSION
//===============================================================
logic      c1_temp_2;
logic c2_temp_2;
logic[1:0] c3_temp_2;
logic[1:0] c4_temp_2;
logic[1:0] c5_temp_2;
logic[1:0] c6_temp_2;
logic c7_temp_2;
half_adder HA2_2(
    .a(c2_1[0]),
    .b(c2_1[1]),
    .sum(c2_temp_2),
    .cout(c3_temp_2[0])
);
full_adder FA3_2(
    .a(c3_1[0]),
    .b(c3_1[1]),
    .cin(c3_1[2]),
    .sum(c3_temp_2[1]),
    .cout(c4_temp_2[0])
);
half_adder HA4_2(
    .a(c4_1[0]),
    .b(c4_1[1]),
    .sum(c4_temp_2[1]),
    .cout(c5_temp_2[0])
);
half_adder HA5_2(
    .a(c5_1[0]),
    .b(c5_1[1]),
    .sum(c5_temp_2[1]),
    .cout(c6_temp_2[0])
);
half_adder HA6_2(
    .a(c6_1[0]),
    .b(c6_1[1]),
    .sum(c6_temp_2[1]),
    .cout(c7_temp_2)
);
logic[1:0] c5_2;
logic[1:0] c6_2;
logic[1:0] c4_2;
logic[1:0] c3_2;
logic c7_2;
always_comb begin 
    prod[2] = c2_temp_2;
    c3_2 = {c3_temp_2[1],c3_temp_2[0]};
    c4_2 = {c4_temp_2[1],c4_temp_2[0]};
    c5_2 = {c5_temp_2[1],c5_temp_2[0]};
    c6_2 = {c6_temp_2[1],c6_temp_2[0]}; 
    c7_2 = c7_temp_2;
end
// initial begin
//     #20;
//     $display("At the end of 2nd compression values are \nc3:%b\nc4:%b\nc5:%b\nc6:%b\nc7:%b",c3_temp_2,c4_2,c5_2,c6_2,c7_2);
// end
//==========================================================
//THIRD COMPRESSION(Final)
//==========================================================
logic c4_temp_3;
logic c5_temp_3;
logic c6_temp_3;
logic c7_temp_3;
half_adder HA3_3(
    .a(c3_2[0]),
    .b(c3_2[1]),
    .sum(prod[3]),
    .cout(c4_temp_3)
);
full_adder FA4_3(
    .a(c4_2[0]),
    .b(c4_2[1]),
    .cin(c4_temp_3),
    .sum(prod[4]),
    .cout(c5_temp_3)
);
full_adder FA5_3(
    .a(c5_2[0]),
    .b(c5_2[1]),
    .cin(c5_temp_3),
    .sum(prod[5]),
    .cout(c6_temp_3)
);
full_adder FA6_3(
    .a(c6_2[0]),
    .b(c6_2[1]),
    .cin(c6_temp_3),
    .sum(prod[6]),
    .cout(c7_temp_3)
);
logic dummy;
half_adder HA7_3(
    .a(c7_2),
    .b(c7_temp_3),
    .sum(prod[7]),
    .cout(dummy)
);
endmodule
