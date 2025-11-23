`timescale 1ns / 1ps

`include "global_params.sv"

module rd_alu(
    input [63:0] A_in,
    input [63:0] B_in,
    input [3:0] op_in,
    output reg [63:0] C_o,
    output zero_o,
    output reg carry_o,
    output reg overflow_o,
    output reg negative_o
);

// Define operation codes
localparam ADD  =  `ADD
localparam SUB  =  `SUB
localparam AND  =  `AND
localparam OR   =  `OR
localparam XOR  =  `XOR
localparam SLL  =  `SLL // Shift left logical
localparam SRL  =  `SRL // Shift right logical
localparam SRA  =  `SRA // Shift right arithmetic

always @(*) begin
    case (op_in)
        ADD: begin
            {carry_o, C_o} = A_in + B_in; // Addition with carry
            overflow_o = ((A_in[63] && B_in[63] && !C_o[63]) || (!A_in[63] && !B_in[63] && C_o[63]));
        end
        SUB: begin
			// Subtract by adding the two's complement
            {carry_o, C_o} = A_in + (~B_in + 1);
            overflow_o = ((A_in[63] && !B_in[63] && !C_o[63]) || (!A_in[63] && B_in[63] && C_o[63]));
        end
        AND: C_o = A_in & B_in; // Bitwise AND
        OR:  C_o = A_in | B_in; // Bitwise OR
        XOR: C_o = A_in ^ B_in; // Bitwise XOR
        SLL: C_o = A_in << B_in; // Shift left logical
        SRL: C_o = A_in >> B_in; // Shift right logical
        SRA: C_o = $signed(A_in) >>> B_in; // Shift right arithmetic
        default: C_o = 64'd0; // Default case
    endcase

    // Set the negative flag based on the result's MSB
    negative_o = C_o[63];
end

// Assign the zero flag outside the always block
assign zero_o = (C_o == 64'd0);


endmodule