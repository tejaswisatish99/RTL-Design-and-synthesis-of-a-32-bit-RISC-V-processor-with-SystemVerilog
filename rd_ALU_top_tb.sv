`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2024 04:14:12 PM
// Design Name: 
// Module Name: rd_ALUControl_tb
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
`include "global_params.vh"
module rd_ALU_top_tb;


// Inputs
reg [63:0] A_i;
reg [63:0] B_i;
reg [3:0] instruction_i;
reg [1:0] ALUop_i;

// Outputs
wire [63:0] C_o;
wire zero_o;

// Define operation codes
localparam ADD  =  `ADD
localparam SUB  =  `SUB
localparam AND  =  `AND
localparam OR   =  `OR
localparam XOR  =  `XOR
localparam SLL  =  `SLL // Shift left logical
localparam SRL  =  `SRL // Shift right logical
localparam SRA  =  `SRA // Shift right arithmetic


// Instantiate the Unit Under Test (UUT)
rd_ALU_top rd_ALU_top_uut (
    .A_i(A_i),
    .B_i(B_i),
    .instruction_i(instruction_i),
    .ALUop_i(ALUop_i),
    .C_o(C_o),
    .zero_o(zero_o)
);

initial begin
    // Initialize Inputs
    A_i = 0;
    B_i = 0;
    instruction_i = 0;
    ALUop_i = 0;

    // Wait for global reset
    #100;

    // Test Case 1: Simple addition
    A_i = 64'h0000000000000005;
    B_i = 64'h0000000000000003;
    instruction_i = ADD; // Example instruction for addition
    ALUop_i = 2'b10; // Example ALUop
    #20;
    if (C_o !== 64'h0000000000000008) 
        $display("Error in Test Case 1: C_o = %h, expected = 0000000000000008", C_o);
    
    // Test Case 2: Addition with overflow
    A_i = 64'hFFFFFFFFFFFFFFFF;
    B_i = 64'h0000000000000001;
    instruction_i = ADD; // Example instruction for addition
    ALUop_i = 2'b10; // Example ALUop
    #20;
    if (C_o !== 64'h0000000000000000)
        $display("Error in Test Case 2: C_o = %h, expected = 0000000000000000", C_o);

    // Test Case 3: Subtraction
    A_i = 64'h123456789ABCDEF0;
    B_i = 64'h0FEDCBA987654321;
    instruction_i = SUB; // Example instruction for subtraction
    ALUop_i = 2'b10; // Example ALUop
    #20;
    if (C_o !== 64'h2468ACF13579BCF)
        $display("Error in Test Case 3: C_o = %h, expected = 024691024691024F", C_o);

    // Test Case 4: Bitwise AND
    A_i = 64'hFFFF0000FFFF0000;
    B_i = 64'h0000FFFF0000FFFF;
    instruction_i = AND; // Example instruction for AND
    ALUop_i = 2'b10; // Example ALUop
    #20;
    if (C_o !== 64'h0000000000000000)
        $display("Error in Test Case 4: C_o = %h, expected = 0000000000000000", C_o);

    // Test Case 5: Bitwise OR
    A_i = 64'hF0F0F0F0F0F0F0F0;
    B_i = 64'h0F0F0F0F0F0F0F0F;
    instruction_i = OR; // Example instruction for OR
    ALUop_i = 2'b10; // Example ALUop ADD
    #20;
    if (C_o !== 64'hFFFFFFFFFFFFFFFF)
        $display("Error in Test Case 5: C_o = %h, expected = FFFFFFFFFFFFFFFF", C_o);
		
	// Test Case 6: Logical shift left
    A_i = 64'h0000000000000001;
    B_i = 64'h0000000000000004; // Shift by 4
    instruction_i = SLL; // Example instruction for logical shift left
    ALUop_i = 2'b10; // Example ALUop
    #20;
    if (C_o !== 64'h0000000000000010)
        $display("Error in Test Case 6: C_o = %h, expected = 0000000000000010", C_o);
		

    // Test Case 7: Logical shift right
    A_i = 64'h0000000000000010;
    B_i = 64'h0000000000000002; // Shift by 2
    instruction_i = SRL; // Example instruction for logical shift right
    ALUop_i = 2'b10; // Example ALUop
    #20;
    if (C_o !== 64'h0000000000000004)
        $display("Error in Test Case 7: C_o = %h, expected = 0000000000000004", C_o);

    // Test Case 8: OPcode 2'b00 ADD
    A_i = 64'h0000000000000010;
    B_i = 64'h0000000000000020;
    instruction_i = SUB; // Example instruction for multiplication
    ALUop_i = 2'b00; // Example ALUop
    #20;
    if (C_o !== 64'h0000000000000030)
        $display("Error in Test Case 8: C_o = %h, expected = 0000000000000030", C_o);

    // Test Case 9: OPcode 2'b01 SUB
    A_i = 64'h0000000000000020;
    B_i = 64'h0000000000000010;
    instruction_i = ADD; // Example instruction for ADD
    ALUop_i = 2'b01; // Example ALUop SUB
    #20;
    if (C_o !== 64'h0000000000000010)
        $display("Error in Test Case 9: C_o = %h, expected = 0000000000000010", C_o);
		
	// Test Case 10: OPcode 2'b11 Default 0
    A_i = 64'h0000000000000040;
    B_i = 64'h0000000000000050;
    instruction_i = ADD; // Example instruction for addition
    ALUop_i = 2'b11; // Example ALUop
    #20;
    if (C_o !== 64'h0000000000000000)
        $display("Error in Test Case 10: C_o = %h, expected = 0000000000000000", C_o);


    // Test Case 11: Test for zero output
    A_i = 64'h0000000000000000;
    B_i = 64'h0000000000000000;
    instruction_i = ADD; // Example instruction for addition
    ALUop_i = 2'b10; // Example ALUop
    #20;
    if (zero_o !== 1'b1)
        $display("Error in Test Case 11: zero_o = %b, expected = 1", zero_o);

    // Finish simulation
    $finish;
end

// Monitor statement
initial begin
    $monitor("At time %t, A_i = %h, B_i = %h, instruction_i = %b, ALUop_i = %b, C_o = %h, zero_o = %b", 
             $time, A_i, B_i, instruction_i, ALUop_i, C_o, zero_o);
end

endmodule