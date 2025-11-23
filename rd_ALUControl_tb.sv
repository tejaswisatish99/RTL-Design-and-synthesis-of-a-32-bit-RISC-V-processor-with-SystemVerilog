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

module rd_ALUControl_tb;

    // Testbench variables
    reg [1:0] ALUOp_i;
    reg [3:0] instruction_i;
    wire [3:0] ALUControl_o;
	
	// Define operation codes
	localparam ADD  =  `ADD
	localparam SUB  =  `SUB
	localparam AND  =  `AND
	localparam OR   =  `OR
	localparam XOR  =  `XOR
	localparam SLL  =  `SLL // Shift left logical
	localparam SRL  =  `SRL // Shift right logical
	localparam SRA  =  `SRA // Shift right arithmetic

    // Instantiate the ALUControl module
    rd_ALUControl rd_ALUControl_uut (
        .ALUOp_i(ALUOp_i),
        .instruction_i(instruction_i),
        .ALUControl_o(ALUControl_o)
    );

    // Test sequence
    initial begin
        // Display header
        $display("ALUOp_i  instruction_i  ALUControl_o");
        
        // Test case 1: LW, SW - ADD operation
        ALUOp_i = 2'b00;
        instruction_i = 4'bxxxx; // Don't care
        #10;
        $display("%b      %b          %b", ALUOp_i, instruction_i, ALUControl_o);

        // Test case 2: Branch - SUB operation
        ALUOp_i = 2'b01;
        instruction_i = 4'bxxxx; // Don't care
        #10;
        $display("%b      %b          %b", ALUOp_i, instruction_i, ALUControl_o);

        // Test case 3: R-type ADD operation
        ALUOp_i = 2'b10;
        instruction_i = ADD;
        #10;
        $display("%b      %b          %b", ALUOp_i, instruction_i, ALUControl_o);

        // Test case 4: R-type SUB operation
        ALUOp_i = 2'b10;
        instruction_i = SUB;
        #10;
        $display("%b      %b          %b", ALUOp_i, instruction_i, ALUControl_o);

        // Test case 5: R-type AND operation
        ALUOp_i = 2'b10;
        instruction_i = AND;
        #10;
        $display("%b      %b          %b", ALUOp_i, instruction_i, ALUControl_o);

        // Test case 6: R-type OR operation
        ALUOp_i = 2'b10;
        instruction_i = OR;
        #10;
        $display("%b      %b          %b", ALUOp_i, instruction_i, ALUControl_o);

        // Test case 7: Undefined ALUOp_i
        ALUOp_i = 2'b11;
        instruction_i = 4'bxxxx; // Don't care
        #10;
        $display("%b      %b          %b", ALUOp_i, instruction_i, ALUControl_o);

        // End of test
        $stop;
    end

endmodule
