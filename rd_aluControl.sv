`include "global_params.sv"

module rd_ALUControl (
    input [1:0] ALUOp_i,         // 2-bit ALU operation code
    input [3:0] instruction_i,   // 4-bit function field from the instruction
    output reg [3:0] ALUControl_o // 4-bit control signal to the ALU
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

always @* begin
    case (ALUOp_i)
        2'b00: ALUControl_o = ADD; // LW, SW - ADD operation
        2'b01: ALUControl_o = SUB; // Branch - SUB operation
        2'b10: begin
            case (instruction_i)
                ADD: ALUControl_o = ADD; // ADD
                SUB: ALUControl_o = SUB; // SUB
                AND: ALUControl_o = AND; // AND
                OR:  ALUControl_o = OR;  // OR
                XOR: ALUControl_o = XOR; // XOR
                SLL: ALUControl_o = SLL; // SLL
                SRL: ALUControl_o = SRL; // SRL
                SRA: ALUControl_o = SRA; // SRA
                default: ALUControl_o = 4'b1111; // Undefined operation
            endcase
        end
        default: ALUControl_o = 4'b1111; // Undefined ALUOp
    endcase
end


endmodule
