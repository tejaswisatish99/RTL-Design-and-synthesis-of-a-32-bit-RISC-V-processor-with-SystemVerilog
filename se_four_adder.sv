`timescale 1ns / 1ps

module se_four_adder(
    input logic [63:0] pco_i,       // program counter out 
    output logic [63:0] nextAddr_o, // next address
    output logic c_o                // carry out
    );
    
    localparam logic [63:0] addr_inc = 64'd4;   // define address increments four byte
    
    assign{c_o, nextAddr_o} = pco_i + addr_inc;
endmodule
