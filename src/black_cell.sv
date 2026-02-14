`timescale 1ns/1ps
module black_cell (
    input  logic Gin, Pin,
    input  logic Gk,  Pk,
    output logic Gout, Pout
);
    assign Gout = Gin | (Pin & Gk);
    assign Pout = Pin & Pk;
endmodule



module grey_cell (
    input  logic Gin, Pin,
    input  logic Gk,
    output logic Gout
);
    assign Gout = Gin | (Pin & Gk);
endmodule

