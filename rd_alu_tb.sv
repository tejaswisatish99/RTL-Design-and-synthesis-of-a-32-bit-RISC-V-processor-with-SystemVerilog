`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2024 04:14:12 PM
// Design Name: 
// Module Name: rd_alu_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "global_params.sv"

module rd_alu_tb;

// Inputs
reg [63:0] A_in;
reg [63:0] B_in;
reg [3:0] op_in;

// Outputs
wire [63:0] C_o;
wire zero_o;
wire carry_o;
wire overflow_o;
wire negative_o;

// Define operation codes
localparam ADD  =  `ADD
localparam SUB  =  `SUB
localparam AND  =  `AND
localparam OR   =  `OR
localparam XOR  =  `XOR
localparam SLL  =  `SLL // Shift left logical
localparam SRL  =  `SRL // Shift right logical
localparam SRA  =  `SRA // Shift right arithmetic

// Instantiate the ALU Module as unit under test
rd_alu rd_alu_uut (
    .A_in(A_in), 
    .B_in(B_in), 
    .op_in(op_in), 
    .C_o(C_o), 
    .zero_o(zero_o), 
    .carry_o(carry_o), 
    .overflow_o(overflow_o), 
    .negative_o(negative_o)
);

initial begin
    // Initialize Inputs
    A_in = 0;
    B_in = 0;
    op_in = 0;

    // Wait 100 ns for global reset to finish
    #100;
    
    // Add stimulus here
    // Test Addition
    A_in = 64'h0000000000000010; // 16
    B_in = 64'h0000000000000020; // 32
    op_in = ADD; // ADD operation
    #10;
    if (C_o != 64'h0000000000000030) $display("Addition failed. Expected 0x30, got %h", C_o);

    // Test Subtraction
    A_in = 64'h0000000000000020; // 32
    B_in = 64'h0000000000000010; // 16
    op_in = SUB; // SUB operation
    #10;
    if (C_o != 64'h0000000000000010) $display("Subtraction failed. Expected 0x10, got %h", C_o);

    // Test AND
    A_in = 64'h0F0F0F0F0F0F0F0F;
    B_in = 64'h00FF00FF00FF00FF;
    op_in = AND; // AND operation
    #10;
    if (C_o != 64'h000F000F000F000F) $display("AND operation failed. Expected 0x000F000F000F000F, got %h", C_o);

    // Test OR
    A_in = 64'h0F0F0F0F0F0F0F0F;
    B_in = 64'hF0F0F0F0F0F0F0F0;
    op_in = OR; // OR operation
    #10;
    if (C_o != 64'hFFFFFFFFFFFFFFFF) $display("OR operation failed. Expected 0xFFFFFFFFFFFFFFFF, got %h", C_o);

    // Test XOR
    A_in = 64'h0F0F0F0F0F0F0F0F;
    B_in = 64'hFF00FF00FF00FF00;
    op_in = XOR; // XOR operation
    #10;
    if (C_o != 64'hF00FF00FF00FF00F) $display("XOR operation failed. Expected 0xF00FF00FF00FF00F, got %h", C_o);

    // Test Shift Left Logical
    A_in = 64'h0000000000000001; // 1
    B_in = 64'h0000000000000005; // shift left by 5
    op_in = SLL; // SLL operation
    #10;
    if (C_o != 64'h0000000000000020) $display("Shift Left Logical failed. Expected 0x20, got %h", C_o);

    // Test Shift Right Logical
    A_in = 64'h8000000000000000; // High bit set
    B_in = 64'h000000000000001F; // shift right by 31
    op_in = SRL; // SRL operation
    #10;
    if (C_o != 64'h0000000100000000) $display("Shift Right Logical failed. Expected 0x1, got %h", C_o);

    // Test Shift Right Arithmetic
    A_in = 64'h8000000000000000; // High bit set
    B_in = 64'h000000000000003F; // shift right by 63
    op_in = SRA; // SRA operation
    #10;
    if (C_o != 64'hFFFFFFFFFFFFFFFF) $display("Shift Right Arithmetic failed. Expected 0xFFFFFFFFFFFFFFFF, got %h", C_o);

    // Test Zero Flag
    A_in = 64'h0000000000000000;
    B_in = 64'h0000000000000000;
    op_in = ADD; // ADD operation
    #10;
    if (!zero_o) $display("Zero flag test failed. Expected true when A = 0 and B = 0.");

    // Test Carry Flag (should occur in case of overflow from most significant bit in addition)
    A_in = 64'hFFFFFFFFFFFFFFFF; // Max unsigned value
    B_in = 64'h0000000000000001;
    op_in = ADD; // ADD operation
    #10;
    if (!carry_o) $display("Carry flag test failed. Expected true when adding 0xFFFFFFFFFFFFFFFF and 0x0000000000000001.");

    // Test Overflow Flag (occurs when two positives yield a negative, or two negatives yield a positive)
    A_in = 64'h7FFFFFFFFFFFFFFF; // Largest positive 64-bit integer
    B_in = 64'h0000000000000001;
    op_in = ADD; // ADD operation
    #10;
    if (!overflow_o) $display("Overflow flag test failed. Expected true when adding 0x7FFFFFFFFFFFFFFF and 0x0000000000000001.");

    A_in = 64'h8000000000000000; // Largest negative 64-bit integer
    B_in = 64'hFFFFFFFFFFFFFFFF; // -1 in two's complement
    op_in = ADD; // ADD operation
    #10;
    if (!overflow_o) $display("Overflow flag test failed. Expected true when adding 0x8000000000000000 and 0xFFFFFFFFFFFFFFFF.");

    // Test Negative Flag (should be set if result is negative)
    A_in = 64'h8000000000000000; // Largest negative 64-bit integer
    B_in = 64'h0000000000000000;
    op_in = ADD; // ADD operation
    #10;
    if (!negative_o) $display("Negative flag test failed. Expected true when result is negative.");


    // End of test
    $finish;
end

// Monitor changes and print
initial begin
    $monitor("Time = %t, A_in = %h, B_in = %h, Operation = %b, C_o = %h, Zero = %b, Carry = %b, Overflow = %b, Negative = %b",
             $time, A_in, B_in, op_in, C_o, zero_o, carry_o, overflow_o, negative_o);
end

endmodule
