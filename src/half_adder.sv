`timescale 1ns/1ps
module half_adder (
    input logic a,
    input logic b,
    output logic sum,
    output logic cout
);
always_comb begin 
    sum = a ^ b;
    cout = a & b;
end
endmodule