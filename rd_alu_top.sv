module rd_ALU_top(
    input [63:0] A_i,
    input [63:0] B_i,
    input [3:0] instruction_i,
	input [1:0] ALUop_i,
    output wire [63:0] C_o,
	//output wire carry_o,
	//output wire overflow_o,
	//output wire negative_o,
	output wire zero_o
	);
	
	// Internal signal declarations
    wire [3:0] ALUControl_s;
    wire carry_s;
    wire overflow_s;
    wire negative_s;
	
	// Instantiate the ALUControl module
    rd_ALUControl rd_ALUControl (
        .ALUOp_i(ALUop_i),
        .instruction_i(instruction_i),
        .ALUControl_o(ALUControl_s)
    );
	
	// Instantiate the ALU Module as unit under test
	rd_alu rd_alu (
		.A_in(A_i), 
		.B_in(B_i), 
		.op_in(ALUControl_s), 
		.C_o(C_o), 
		.zero_o(zero_o), 
		.carry_o(carry_s), 
		.overflow_o(overflow_s), 
		.negative_o(negative_s)
	);
	
	// Assign internal signals to output ports
    //assign carry_o = carry_s;
    //assign overflow_o = overflow_s;
    //assign negative_o = negative_s;

endmodule
