`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 
// Create Date: 13.05.2024 23:25:16
// Module Name: testbench_decoder
//////////////////////////////////////////////////////////////////////////////////


module hr_testbench_decoder();
  
    logic [31:0] instruction_s;
    logic [63:0] pc_in_s;
    logic [63:0] nxt_pc_s;
    logic zero_s;
    logic [4:0] Register_Source_1_s;
    logic [4:0] Register_Source_2_s;
    logic [4:0] Register_Dest_s;
    logic [63:0] pc_out_s;
    logic [1:0] Alu_OP_s;
    logic [3:0] Alu_Control_s;
    logic MemtoReg_s;
    logic MemWrite_s;
    logic MemRead_s;
    logic RegWrite_s;
    logic AluSrc_s;
    logic [63:0] immediate_s;
    
    // Parts of the instruction
    logic [6:0] funct7;
    logic [4:0] rs2;  
    logic [4:0] rs1;
    logic [2:0] funct3;
    logic [4:0] rd;
    logic [6:0] opcode; 
    logic [11:0] immediate_I_Typ;
    logic [7:0] immediate_SB_Typ_1;
    logic [4:0] immediate_SB_Typ_2;
    logic [63:0] imm_calc;
    
        // Parameters for Instruction Type
    parameter logic [6:0] R_TYPE = 7'b0110011;
    parameter logic [6:0] I_TYPE = 7'b0000011;
    parameter logic [6:0] S_TYPE = 7'b0100011;
    parameter logic [6:0] B_TYPE = 7'b1100011;
    
    // Parameters for funct7 Register
    parameter logic [6:0] funct7_add = 7'b0000000;
    parameter logic [6:0] funct7_sub = 7'b0100000;
    
    // Parameters for funct3 Register
    parameter logic [2:0] funct3_add_sub = 3'b000;
    parameter logic [2:0] funct3_and = 3'b111;
    parameter logic [2:0] funct3_or = 3'b110;
    
    // Parameters for ALU Control Bits
    parameter logic [1:0] alu_op_r_typ = 2'b10;
    parameter logic [1:0] alu_op_i_typ = 2'b00;
    parameter logic [1:0] alu_op_s_typ = 2'b00;
    parameter logic [1:0] alu_op_b_typ = 2'b01;
    
    parameter logic [3:0] alu_control_add = 4'b0010;
    parameter logic [3:0] alu_control_sub = 4'b0110;
    parameter logic [3:0] alu_control_and = 4'b0000;
    parameter logic [3:0] alu_control_or = 4'b0001;
    
    hr_instr_decoder DUT (.instruction_i(instruction_s), 
                       .pc_i(pc_in_s),
                       .nxt_pc_i(nxt_pc_s),
                       .zero_flag_i(zero_s),
                       .Register_Source_1_o(Register_Source_1_s),
                       .Register_Source_2_o(Register_Source_2_s),
                       .Register_Dest_o(Register_Dest_s),
                       .pc_o(pc_out_s),
                       .Alu_OP_o(Alu_OP_s),
                       .Alu_Control_o(Alu_Control_s),
                       .MemtoReg_o(MemtoReg_s),
                       .MemWrite_o(MemWrite_s),
                       .MemRead_o(MemRead_s),
                       .RegWrite_o(RegWrite_s),
                       .AluSrc_o(AluSrc_s),
                       .immediate_o(immediate_s)
                      );
                      
    initial begin
        $display ("Begin Testing");
        #1;
        instruction_s = 32'b0;
        pc_in_s = 64'b0;
        nxt_pc_s = 64'b0;
        zero_s = 'b0;
        $display ("Initialized");
        #1;
        $display ("Test of R-Type Instruction: ADD");
        funct7 = funct7_add;
        rs2 = 'b10001;
        rs1 = 'b11000;
        funct3 = funct3_add_sub;
        rd = 'b00011;
        opcode = R_TYPE;
        #1;
        instruction_s = {funct7, rs2, rs1, funct3, rd, opcode};
        #1;
        assert(instruction_s == 'b00000001000111000000000110110011) 
        $display("%0t : Assertion passed. Current Instruction is %b ", $time, instruction_s); 
        else $error("%0t : Assertion failed. Current Instruction is %b ", $time, instruction_s);
        
        assert(Register_Source_1_s == rs1) 
        $display("%0t : Assertion passed. Register_Source_1_s is %b", $time,Register_Source_1_s); 
        else $error("%0t : Assertion failed. rs1 is %b should be %b", $time,Register_Source_1_s, rs1); 
        
        assert(Register_Source_2_s == rs2) 
        $display("%0t : Assertion passed. Register_Source_2_s is %b and rs2 is %b", $time,rs2, Register_Source_2_s); 
        else $error("%0t : Assertion failed. rs2 is %b should be %b", $time,rs2, Register_Source_2_s); 
        
        assert(Register_Dest_s == rd) 
        $display("%0t : Assertion passed. rd is %b and Register_Dest_s is %b", $time,rd, Register_Dest_s); 
        else $error("%0t : Assertion failed. rs1 is %b and Register_Dest_s is %b", $time,rd, Register_Dest_s); 
        
        assert(Alu_OP_s == alu_op_r_typ) 
        $display("%0t : Assertion passed. Alu_OP_s is %b ", $time,Alu_OP_s); 
        else $error("%0t : Assertion failed. Alu_OP_s is %b should be %b", $time,Alu_OP_s, alu_op_r_typ); 
        
        assert(Alu_Control_s == funct3_add_sub) 
        $display("%0t : Assertion passed. Alu_Control_s is %b ", $time,Alu_Control_s); 
        else $error("%0t : Assertion failed. Alu_Control_s is %b should be %b", $time,Alu_Control_s, alu_control_add);
        
        assert(MemtoReg_s == 'b0) 
        $display("%0t : Assertion passed. MemtoReg_s is %b ", $time,MemtoReg_s); 
        else $error("%0t : Assertion failed. MemtoReg_s is %b should be %b", $time,MemtoReg_s, 'b0);
        
        assert(MemWrite_s == 'b0) 
        $display("%0t : Assertion passed. MemWrite_s is %b ", $time,MemWrite_s); 
        else $error("%0t : Assertion failed. MemWrite_s is %b should be %b", $time,MemWrite_s, 'b0);
        
        assert(MemRead_s == 'b0) 
        $display("%0t : Assertion passed. MemRead_s is %b ", $time,MemRead_s); 
        else $error("%0t : Assertion failed. MemRead_s is %b should be %b", $time,MemRead_s, 'b0);
        
        assert(RegWrite_s == 'b1) 
        $display("%0t : Assertion passed. RegWrite_s is %b ", $time,RegWrite_s); 
        else $error("%0t : Assertion failed. RegWrite_s is %b should be %b", $time,RegWrite_s, 'b1);
        
        assert(AluSrc_s == 'b0) 
        $display("%0t : Assertion passed. AluSrc_s is %b ", $time,AluSrc_s); 
        else $error("%0t : Assertion failed. AluSrc_s is %b should be %b", $time,AluSrc_s, 'b0);
        
        assert(pc_out_s == nxt_pc_s) 
        $display("%0t : Assertion passed. pc_out_s is %b ", $time,pc_out_s); 
        else $error("%0t : Assertion failed. pc_out_s is %b should be %b", $time,pc_out_s, nxt_pc_s);
        
        assert(immediate_s == 64'b0) 
        $display("%0t : Assertion passed. immediate_s is %b ", $time,immediate_s); 
        else $error("%0t : Assertion failed. immediate_s is %b should be %b", $time,immediate_s, 64'b0);
        
        #1;
        $display ("Test of R-Type Instruction: SUB");
        nxt_pc_s = nxt_pc_s + 4;
        funct7 = funct7_sub;
        rs2 = 'b10001;
        rs1 = 'b11000;
        funct3 = funct3_add_sub;
        rd = 'b00011;
        opcode = R_TYPE;
        #1;
        instruction_s = {funct7, rs2, rs1, funct3, rd, opcode};
        #1;
        assert(instruction_s == 'b01000001000111000000000110110011) 
        $display("%0t : Assertion passed. Current Instruction is %b ", $time, instruction_s); 
        else $error("%0t : Assertion failed. Current Instruction is %b ", $time, instruction_s);
        
        assert(Register_Source_1_s == rs1) 
        $display("%0t : Assertion passed. rs1 is %b and Register_Source_1_s is %b", $time,rs1, Register_Source_1_s); 
        else $error("%0t : Assertion failed. rs1 is %b and Register_Source_1_s is %b", $time,rs1, Register_Source_1_s); 
        
        assert(Register_Source_2_s == rs2) 
        $display("%0t : Assertion passed. rs2 is %b and Register_Source_2_s is %b", $time,rs2, Register_Source_2_s); 
        else $error("%0t : Assertion failed. rs2 is %b and Register_Source_2_s is %b", $time,rs2, Register_Source_2_s); 
        
        assert(Register_Dest_s == rd) 
        $display("%0t : Assertion passed. rd is %b and Register_Dest_s is %b", $time,rd, Register_Dest_s); 
        else $error("%0t : Assertion failed. rs1 is %b and Register_Dest_s is %b", $time,rd, Register_Dest_s); 
        
        assert(Alu_OP_s == alu_op_r_typ) 
        $display("%0t : Assertion passed. Alu_OP_s is %b ", $time,Alu_OP_s); 
        else $error("%0t : Assertion failed. Alu_OP_s is %b should be %b", $time,Alu_OP_s, alu_op_r_typ); 
        
        assert(Alu_Control_s == funct3_add_sub) 
        $display("%0t : Assertion passed. Alu_Control_s is %b ", $time,Alu_Control_s); 
        else $error("%0t : Assertion failed. Alu_Control_s is %b should be %b", $time,Alu_Control_s, alu_control_add);
        
        assert(MemtoReg_s == 'b0) 
        $display("%0t : Assertion passed. MemtoReg_s is %b ", $time,MemtoReg_s); 
        else $error("%0t : Assertion failed. MemtoReg_s is %b should be %b", $time,MemtoReg_s, 'b0);
        
        assert(MemWrite_s == 'b0) 
        $display("%0t : Assertion passed. MemWrite_s is %b ", $time,MemWrite_s); 
        else $error("%0t : Assertion failed. MemWrite_s is %b should be %b", $time,MemWrite_s, 'b0);
        
        assert(MemRead_s == 'b0) 
        $display("%0t : Assertion passed. MemRead_s is %b ", $time,MemRead_s); 
        else $error("%0t : Assertion failed. MemRead_s is %b should be %b", $time,MemRead_s, 'b0);
        
        assert(RegWrite_s == 'b1) 
        $display("%0t : Assertion passed. RegWrite_s is %b ", $time,RegWrite_s); 
        else $error("%0t : Assertion failed. RegWrite_s is %b should be %b", $time,RegWrite_s, 'b1);
        
        assert(AluSrc_s == 'b0) 
        $display("%0t : Assertion passed. AluSrc_s is %b ", $time,AluSrc_s); 
        else $error("%0t : Assertion failed. AluSrc_s is %b should be %b", $time,AluSrc_s, 'b0);
        
        assert(pc_out_s == nxt_pc_s) 
        $display("%0t : Assertion passed. pc_out_s is %b ", $time,pc_out_s); 
        else $error("%0t : Assertion failed. pc_out_s is %b should be %b", $time,pc_out_s, nxt_pc_s);
        
        assert(immediate_s == 64'b0) 
        $display("%0t : Assertion passed. immediate_s is %b ", $time,immediate_s); 
        else $error("%0t : Assertion failed. immediate_s is %b should be %b", $time,immediate_s, 64'b0);
        
        #1;
        $display ("Test of R-Type Instruction: AND");
        nxt_pc_s = nxt_pc_s + 4;
        funct7 = funct7_add; // funct7 bits are all zero
        rs2 = 'b10001;
        rs1 = 'b11000;
        funct3 = funct3_and;
        rd = 'b00011;
        opcode = R_TYPE;
        #1;
        instruction_s = {funct7, rs2, rs1, funct3, rd, opcode};
        #1;
        assert(instruction_s == 'b00000001000111000111000110110011) 
        $display("%0t : Assertion passed. Current Instruction is %b ", $time, instruction_s); 
        else $error("%0t : Assertion failed. Current Instruction is %b ", $time, instruction_s);
        
        assert(Register_Source_1_s == rs1) 
        $display("%0t : Assertion passed. rs1 is %b and Register_Source_1_s is %b", $time,rs1, Register_Source_1_s); 
        else $error("%0t : Assertion failed. rs1 is %b and Register_Source_1_s is %b", $time,rs1, Register_Source_1_s); 
        
        assert(Register_Source_2_s == rs2) 
        $display("%0t : Assertion passed. rs2 is %b and Register_Source_2_s is %b", $time,rs2, Register_Source_2_s); 
        else $error("%0t : Assertion failed. rs2 is %b and Register_Source_2_s is %b", $time,rs2, Register_Source_2_s); 
        
        assert(Register_Dest_s == rd) 
        $display("%0t : Assertion passed. rd is %b and Register_Dest_s is %b", $time,rd, Register_Dest_s); 
        else $error("%0t : Assertion failed. rs1 is %b and Register_Dest_s is %b", $time,rd, Register_Dest_s); 
        
        assert(Alu_OP_s == alu_op_r_typ) 
        $display("%0t : Assertion passed. Alu_OP_s is %b ", $time,Alu_OP_s); 
        else $error("%0t : Assertion failed. Alu_OP_s is %b should be %b", $time,Alu_OP_s, alu_op_r_typ); 
        
        assert(Alu_Control_s == funct3_and) 
        $display("%0t : Assertion passed. Alu_Control_s is %b ", $time,Alu_Control_s); 
        else $error("%0t : Assertion failed. Alu_Control_s is %b should be %b", $time,Alu_Control_s, alu_control_add);
        
        assert(MemtoReg_s == 'b0) 
        $display("%0t : Assertion passed. MemtoReg_s is %b ", $time,MemtoReg_s); 
        else $error("%0t : Assertion failed. MemtoReg_s is %b should be %b", $time,MemtoReg_s, 'b0);
        
        assert(MemWrite_s == 'b0) 
        $display("%0t : Assertion passed. MemWrite_s is %b ", $time,MemWrite_s); 
        else $error("%0t : Assertion failed. MemWrite_s is %b should be %b", $time,MemWrite_s, 'b0);
        
        assert(MemRead_s == 'b0) 
        $display("%0t : Assertion passed. MemRead_s is %b ", $time,MemRead_s); 
        else $error("%0t : Assertion failed. MemRead_s is %b should be %b", $time,MemRead_s, 'b0);
        
        assert(RegWrite_s == 'b1) 
        $display("%0t : Assertion passed. RegWrite_s is %b ", $time,RegWrite_s); 
        else $error("%0t : Assertion failed. RegWrite_s is %b should be %b", $time,RegWrite_s, 'b1);
        
        assert(AluSrc_s == 'b0) 
        $display("%0t : Assertion passed. AluSrc_s is %b ", $time,AluSrc_s); 
        else $error("%0t : Assertion failed. AluSrc_s is %b should be %b", $time,AluSrc_s, 'b0);
        
        assert(pc_out_s == nxt_pc_s) 
        $display("%0t : Assertion passed. pc_out_s is %b ", $time,pc_out_s); 
        else $error("%0t : Assertion failed. pc_out_s is %b should be %b", $time,pc_out_s, nxt_pc_s);
        
        assert(immediate_s == 64'b0) 
        $display("%0t : Assertion passed. immediate_s is %b ", $time,immediate_s); 
        else $error("%0t : Assertion failed. immediate_s is %b should be %b", $time,immediate_s, 64'b0);
        
        #1;
        $display ("Test of R-Type Instruction: OR");
        nxt_pc_s = nxt_pc_s + 4;
        funct7 = funct7_add; // funct7 bits are all zero
        rs2 = 'b10001;
        rs1 = 'b11000;
        funct3 = funct3_or;
        rd = 'b00011;
        opcode = R_TYPE;
        #1;
        instruction_s = {funct7, rs2, rs1, funct3, rd, opcode};
        #1;
        assert(instruction_s == 'b00000001000111000110000110110011) 
        $display("%0t : Assertion passed. Current Instruction is %b ", $time, instruction_s); 
        else $error("%0t : Assertion failed. Current Instruction is %b ", $time, instruction_s);
        
        assert(Register_Source_1_s == rs1) 
        $display("%0t : Assertion passed. rs1 is %b and Register_Source_1_s is %b", $time,rs1, Register_Source_1_s); 
        else $error("%0t : Assertion failed. rs1 is %b and Register_Source_1_s is %b", $time,rs1, Register_Source_1_s); 
        
        assert(Register_Source_2_s == rs2) 
        $display("%0t : Assertion passed. rs2 is %b and Register_Source_2_s is %b", $time,rs2, Register_Source_2_s); 
        else $error("%0t : Assertion failed. rs2 is %b and Register_Source_2_s is %b", $time,rs2, Register_Source_2_s); 
        
        assert(Register_Dest_s == rd) 
        $display("%0t : Assertion passed. rd is %b and Register_Dest_s is %b", $time,rd, Register_Dest_s); 
        else $error("%0t : Assertion failed. rs1 is %b and Register_Dest_s is %b", $time,rd, Register_Dest_s); 
        
        assert(Alu_OP_s == alu_op_r_typ) 
        $display("%0t : Assertion passed. Alu_OP_s is %b ", $time,Alu_OP_s); 
        else $error("%0t : Assertion failed. Alu_OP_s is %b should be %b", $time,Alu_OP_s, alu_op_r_typ); 
        
        assert(Alu_Control_s == funct3_or) 
        $display("%0t : Assertion passed. Alu_Control_s is %b ", $time,Alu_Control_s); 
        else $error("%0t : Assertion failed. Alu_Control_s is %b should be %b", $time,Alu_Control_s, alu_control_add);
        
        assert(MemtoReg_s == 'b0) 
        $display("%0t : Assertion passed. MemtoReg_s is %b ", $time,MemtoReg_s); 
        else $error("%0t : Assertion failed. MemtoReg_s is %b should be %b", $time,MemtoReg_s, 'b0);
        
        assert(MemWrite_s == 'b0) 
        $display("%0t : Assertion passed. MemWrite_s is %b ", $time,MemWrite_s); 
        else $error("%0t : Assertion failed. MemWrite_s is %b should be %b", $time,MemWrite_s, 'b0);
        
        assert(MemRead_s == 'b0) 
        $display("%0t : Assertion passed. MemRead_s is %b ", $time,MemRead_s); 
        else $error("%0t : Assertion failed. MemRead_s is %b should be %b", $time,MemRead_s, 'b0);
        
        assert(RegWrite_s == 'b1) 
        $display("%0t : Assertion passed. RegWrite_s is %b ", $time,RegWrite_s); 
        else $error("%0t : Assertion failed. RegWrite_s is %b should be %b", $time,RegWrite_s, 'b1);
        
        assert(AluSrc_s == 'b0) 
        $display("%0t : Assertion passed. AluSrc_s is %b ", $time,AluSrc_s); 
        else $error("%0t : Assertion failed. AluSrc_s is %b should be %b", $time,AluSrc_s, 'b0);
        
        assert(pc_out_s == nxt_pc_s) 
        $display("%0t : Assertion passed. pc_out_s is %b ", $time,pc_out_s); 
        else $error("%0t : Assertion failed. pc_out_s is %b should be %b", $time,pc_out_s, nxt_pc_s);
        
        assert(immediate_s == 64'b0) 
        $display("%0t : Assertion passed. immediate_s is %b ", $time,immediate_s); 
        else $error("%0t : Assertion failed. immediate_s is %b should be %b", $time,immediate_s, 64'b0);
        
        #1;
        $display ("Test of I-Type Instruction: LD positiv immediate");
        nxt_pc_s = nxt_pc_s + 4;
        immediate_I_Typ = 'b001001000101;
        rs1 = 'b11000;
        rd = 'b00011;
        opcode = I_TYPE;
        #1;
        instruction_s = {immediate_I_Typ, rs1, funct3, rd, opcode};
        #1;
        // 0010 0100 0101 11000 110 00011 0000011
        assert(instruction_s == 'b00100100010111000110000110000011) 
        $display("%0t : Assertion passed. Current Instruction is %b ", $time, instruction_s); 
        else $error("%0t : Assertion failed. Current Instruction is %b ", $time, instruction_s);
        
        assert(Register_Source_1_s == rs1) 
        $display("%0t : Assertion passed. rs1 is %b", $time,rs1); 
        else $error("%0t : Assertion failed. rs1 is %b should be %b", $time,rs1, Register_Source_1_s); 
        
        assert(Register_Dest_s == rd) 
        $display("%0t : Assertion passed. rd is %b", $time,rd); 
        else $error("%0t : Assertion failed. rs1 is %b should be %b", $time,rd, Register_Dest_s);
        
        imm_calc = {{52{immediate_I_Typ[11]}}, immediate_I_Typ[11:0]};
        assert(immediate_s == imm_calc) 
        $display("%0t : Assertion passed. immediate_s is %b", $time,immediate_s); 
        else $error("%0t : Assertion failed. immediate_s is %b should be %b", $time,immediate_s, imm_calc);
        
        assert(Alu_OP_s == alu_op_i_typ) 
        $display("%0t : Assertion passed. Alu_OP_s is %b ", $time,Alu_OP_s); 
        else $error("%0t : Assertion failed. Alu_OP_s is %b should be %b", $time,Alu_OP_s, alu_op_r_typ); 
        
        assert(Alu_Control_s == funct3) 
        $display("%0t : Assertion passed. Alu_Control_s is %b ", $time,Alu_Control_s); 
        else $error("%0t : Assertion failed. Alu_Control_s is %b should be %b", $time,Alu_Control_s, alu_control_add);
        
        assert(MemtoReg_s == 'b1) 
        $display("%0t : Assertion passed. MemtoReg_s is %b ", $time,MemtoReg_s); 
        else $error("%0t : Assertion failed. MemtoReg_s is %b should be %b", $time,MemtoReg_s, 'b0);
        
        assert(MemWrite_s == 'b0) 
        $display("%0t : Assertion passed. MemWrite_s is %b ", $time,MemWrite_s); 
        else $error("%0t : Assertion failed. MemWrite_s is %b should be %b", $time,MemWrite_s, 'b0);
        
        assert(MemRead_s == 'b1) 
        $display("%0t : Assertion passed. MemRead_s is %b ", $time,MemRead_s); 
        else $error("%0t : Assertion failed. MemRead_s is %b should be %b", $time,MemRead_s, 'b0);
        
        assert(RegWrite_s == 'b1) 
        $display("%0t : Assertion passed. RegWrite_s is %b ", $time,RegWrite_s); 
        else $error("%0t : Assertion failed. RegWrite_s is %b should be %b", $time,RegWrite_s, 'b1);
        
        assert(AluSrc_s == 'b1) 
        $display("%0t : Assertion passed. AluSrc_s is %b ", $time,AluSrc_s); 
        else $error("%0t : Assertion failed. AluSrc_s is %b should be %b", $time,AluSrc_s, 'b0);
        
        assert(pc_out_s == nxt_pc_s) 
        $display("%0t : Assertion passed. pc_out_s is %b ", $time,pc_out_s); 
        else $error("%0t : Assertion failed. pc_out_s is %b should be %b", $time,pc_out_s, nxt_pc_s);
        
        #1;
        $display ("Test of I-Type Instruction: LD negativ immediate");
        nxt_pc_s = nxt_pc_s + 4;
        immediate_I_Typ = 'b101001000101;
        rs1 = 'b11000;
        rd = 'b00011;
        opcode = I_TYPE;
        #1;
        instruction_s = {immediate_I_Typ, rs1, funct3, rd, opcode};
        #1;
        // 0010 0100 0101 11000 110 00011 0000011
        assert(instruction_s == 'b10100100010111000110000110000011) 
        $display("%0t : Assertion passed. Current Instruction is %b ", $time, instruction_s); 
        else $error("%0t : Assertion failed. Current Instruction is %b ", $time, instruction_s);
        
        assert(Register_Source_1_s == rs1) 
        $display("%0t : Assertion passed. rs1 is %b", $time,rs1); 
        else $error("%0t : Assertion failed. rs1 is %b should be %b", $time,rs1, Register_Source_1_s); 
        
        assert(Register_Dest_s == rd) 
        $display("%0t : Assertion passed. rd is %b", $time,rd); 
        else $error("%0t : Assertion failed. rs1 is %b should be %b", $time,rd, Register_Dest_s);
        
        imm_calc = {{52{immediate_I_Typ[11]}}, immediate_I_Typ[11:0]};
        assert(immediate_s == imm_calc) 
        $display("%0t : Assertion passed. immediate_s is %b", $time,immediate_s); 
        else $error("%0t : Assertion failed. immediate_s is %b should be %b", $time,immediate_s, imm_calc);
        
        assert(Alu_OP_s == alu_op_i_typ) 
        $display("%0t : Assertion passed. Alu_OP_s is %b ", $time,Alu_OP_s); 
        else $error("%0t : Assertion failed. Alu_OP_s is %b should be %b", $time,Alu_OP_s, alu_op_i_typ); 
        
        assert(Alu_Control_s == funct3) 
        $display("%0t : Assertion passed. Alu_Control_s is %b ", $time,Alu_Control_s); 
        else $error("%0t : Assertion failed. Alu_Control_s is %b should be %b", $time,Alu_Control_s, alu_control_add);
        
        assert(MemtoReg_s == 'b1) 
        $display("%0t : Assertion passed. MemtoReg_s is %b ", $time,MemtoReg_s); 
        else $error("%0t : Assertion failed. MemtoReg_s is %b should be %b", $time,MemtoReg_s, 'b0);
        
        assert(MemWrite_s == 'b0) 
        $display("%0t : Assertion passed. MemWrite_s is %b ", $time,MemWrite_s); 
        else $error("%0t : Assertion failed. MemWrite_s is %b should be %b", $time,MemWrite_s, 'b0);
        
        assert(MemRead_s == 'b1) 
        $display("%0t : Assertion passed. MemRead_s is %b ", $time,MemRead_s); 
        else $error("%0t : Assertion failed. MemRead_s is %b should be %b", $time,MemRead_s, 'b0);
        
        assert(RegWrite_s == 'b1) 
        $display("%0t : Assertion passed. RegWrite_s is %b ", $time,RegWrite_s); 
        else $error("%0t : Assertion failed. RegWrite_s is %b should be %b", $time,RegWrite_s, 'b1);
        
        assert(AluSrc_s == 'b1) 
        $display("%0t : Assertion passed. AluSrc_s is %b ", $time,AluSrc_s); 
        else $error("%0t : Assertion failed. AluSrc_s is %b should be %b", $time,AluSrc_s, 'b0);
        
        assert(pc_out_s == nxt_pc_s) 
        $display("%0t : Assertion passed. pc_out_s is %b ", $time,pc_out_s); 
        else $error("%0t : Assertion failed. pc_out_s is %b should be %b", $time,pc_out_s, nxt_pc_s);
        
        #1;
        $display ("Test of S-Type Instruction: SD positiv immediate");
        nxt_pc_s = nxt_pc_s + 4;
        immediate_SB_Typ_1 = 'b0011111;
        immediate_SB_Typ_2 = 'b00111;
        rs1 = 'b11000;
        rs2 = 'b10001;
        opcode = S_TYPE;
        #1;
        instruction_s = {immediate_SB_Typ_1, rs2, rs1, funct3, immediate_SB_Typ_2, opcode};
        #1;
        // 0011 111 10001 11000 110 00111 0100011
        assert(instruction_s == 'b00111111000111000110001110100011) 
        $display("%0t : Assertion passed. Current Instruction is %b ", $time, instruction_s); 
        else $error("%0t : Assertion failed. Current Instruction is %b ", $time, instruction_s);
        
        assert(Register_Source_1_s == rs1) 
        $display("%0t : Assertion passed. rs1 is %b", $time,rs1); 
        else $error("%0t : Assertion failed. rs1 is %b should be %b", $time,rs1, Register_Source_1_s); 
        
        assert(Register_Source_2_s == rs2) 
        $display("%0t : Assertion passed. rd is %b", $time,rs2); 
        else $error("%0t : Assertion failed. rs1 is %b should be %b", $time,rs2, Register_Source_2_s);
        
        imm_calc = {{52{immediate_SB_Typ_1[6]}}, immediate_SB_Typ_1[6:0], immediate_SB_Typ_2[4:0]};
        assert(immediate_s == imm_calc) 
        $display("%0t : Assertion passed. immediate_s is %b", $time,immediate_s); 
        else $error("%0t : Assertion failed. immediate_s is %b should be %b", $time,immediate_s, imm_calc);
        
        assert(Alu_OP_s == alu_op_s_typ) 
        $display("%0t : Assertion passed. Alu_OP_s is %b ", $time,Alu_OP_s); 
        else $error("%0t : Assertion failed. Alu_OP_s is %b should be %b", $time,Alu_OP_s, alu_op_s_typ); 
        
        assert(Alu_Control_s == funct3) 
        $display("%0t : Assertion passed. Alu_Control_s is %b ", $time,Alu_Control_s); 
        else $error("%0t : Assertion failed. Alu_Control_s is %b should be %b", $time,Alu_Control_s, alu_control_add);
        
        assert(MemtoReg_s == 'b0) 
        $display("%0t : Assertion passed. MemtoReg_s is %b ", $time,MemtoReg_s); 
        else $error("%0t : Assertion failed. MemtoReg_s is %b should be %b", $time,MemtoReg_s, 'b0);
        
        assert(MemWrite_s == 'b1) 
        $display("%0t : Assertion passed. MemWrite_s is %b ", $time,MemWrite_s); 
        else $error("%0t : Assertion failed. MemWrite_s is %b should be %b", $time,MemWrite_s, 'b0);
        
        assert(MemRead_s == 'b0) 
        $display("%0t : Assertion passed. MemRead_s is %b ", $time,MemRead_s); 
        else $error("%0t : Assertion failed. MemRead_s is %b should be %b", $time,MemRead_s, 'b0);
        
        assert(RegWrite_s == 'b0) 
        $display("%0t : Assertion passed. RegWrite_s is %b ", $time,RegWrite_s); 
        else $error("%0t : Assertion failed. RegWrite_s is %b should be %b", $time,RegWrite_s, 'b1);
        
        assert(AluSrc_s == 'b1) 
        $display("%0t : Assertion passed. AluSrc_s is %b ", $time,AluSrc_s); 
        else $error("%0t : Assertion failed. AluSrc_s is %b should be %b", $time,AluSrc_s, 'b1);
        
        assert(pc_out_s == nxt_pc_s) 
        $display("%0t : Assertion passed. pc_out_s is %b ", $time,pc_out_s); 
        else $error("%0t : Assertion failed. pc_out_s is %b should be %b", $time,pc_out_s, nxt_pc_s);
        
        #1;
        $display ("Test of S-Type Instruction: SD negativ immediate");
        nxt_pc_s = nxt_pc_s + 4;
        immediate_SB_Typ_1 = 'b1011111;
        immediate_SB_Typ_2 = 'b00111;
        rs1 = 'b11000;
        rs2 = 'b10001;
        opcode = S_TYPE;
        #1;
        instruction_s = {immediate_SB_Typ_1, rs2, rs1, funct3, immediate_SB_Typ_2, opcode};
        #1;
        // 0011 111 10001 11000 110 00111 0100011
        assert(instruction_s == 'b00111111000111000110001110100011) 
        $display("%0t : Assertion passed. Current Instruction is %b ", $time, instruction_s); 
        else $error("%0t : Assertion failed. Current Instruction is %b ", $time, instruction_s);
        
        assert(Register_Source_1_s == rs1) 
        $display("%0t : Assertion passed. rs1 is %b", $time,rs1); 
        else $error("%0t : Assertion failed. rs1 is %b should be %b", $time,rs1, Register_Source_1_s); 
        
        assert(Register_Source_2_s == rs2) 
        $display("%0t : Assertion passed. rd is %b", $time,rs2); 
        else $error("%0t : Assertion failed. rs1 is %b should be %b", $time,rs2, Register_Source_2_s);
        
        imm_calc = {{52{immediate_SB_Typ_1[6]}}, immediate_SB_Typ_1[6:0], immediate_SB_Typ_2[4:0]};
        assert(immediate_s == imm_calc) 
        $display("%0t : Assertion passed. immediate_s is %b", $time,immediate_s); 
        else $error("%0t : Assertion failed. immediate_s is %b should be %b", $time,immediate_s, imm_calc);
        
        assert(Alu_OP_s == alu_op_s_typ) 
        $display("%0t : Assertion passed. Alu_OP_s is %b ", $time,Alu_OP_s); 
        else $error("%0t : Assertion failed. Alu_OP_s is %b should be %b", $time,Alu_OP_s, alu_op_s_typ); 
        
        assert(Alu_Control_s == funct3) 
        $display("%0t : Assertion passed. Alu_Control_s is %b ", $time,Alu_Control_s); 
        else $error("%0t : Assertion failed. Alu_Control_s is %b should be %b", $time,Alu_Control_s, alu_control_add);
        
        assert(MemtoReg_s == 'b0) 
        $display("%0t : Assertion passed. MemtoReg_s is %b ", $time,MemtoReg_s); 
        else $error("%0t : Assertion failed. MemtoReg_s is %b should be %b", $time,MemtoReg_s, 'b0);
        
        assert(MemWrite_s == 'b1) 
        $display("%0t : Assertion passed. MemWrite_s is %b ", $time,MemWrite_s); 
        else $error("%0t : Assertion failed. MemWrite_s is %b should be %b", $time,MemWrite_s, 'b0);
        
        assert(MemRead_s == 'b0) 
        $display("%0t : Assertion passed. MemRead_s is %b ", $time,MemRead_s); 
        else $error("%0t : Assertion failed. MemRead_s is %b should be %b", $time,MemRead_s, 'b0);
        
        assert(RegWrite_s == 'b0) 
        $display("%0t : Assertion passed. RegWrite_s is %b ", $time,RegWrite_s); 
        else $error("%0t : Assertion failed. RegWrite_s is %b should be %b", $time,RegWrite_s, 'b1);
        
        assert(AluSrc_s == 'b1) 
        $display("%0t : Assertion passed. AluSrc_s is %b ", $time,AluSrc_s); 
        else $error("%0t : Assertion failed. AluSrc_s is %b should be %b", $time,AluSrc_s, 'b1);
        
        assert(pc_out_s == nxt_pc_s) 
        $display("%0t : Assertion passed. pc_out_s is %b ", $time,pc_out_s); 
        else $error("%0t : Assertion failed. pc_out_s is %b should be %b", $time,pc_out_s, nxt_pc_s);
        
        #1;
        $display ("Test of B-Type Instruction: Branch taken");
        nxt_pc_s = nxt_pc_s + 4;
        pc_in_s = nxt_pc_s;
        zero_s = 'b1;
        immediate_SB_Typ_1 = 'b0011111;
        immediate_SB_Typ_2 = 'b00111;
        rs1 = 'b11000;
        rs2 = 'b10001;
        opcode = B_TYPE;
        #1;
        instruction_s = {immediate_SB_Typ_1, rs2, rs1, funct3, immediate_SB_Typ_2, opcode};
        #1;
        // 0011 111 10001 11000 110 00111 0100011
        assert(instruction_s == 'b00111111000111000110001111100011) 
        $display("%0t : Assertion passed. Current Instruction is %b ", $time, instruction_s); 
        else $error("%0t : Assertion failed. Current Instruction is %b ", $time, instruction_s);
        
        assert(Register_Source_1_s == rs1) 
        $display("%0t : Assertion passed. rs1 is %b", $time,rs1); 
        else $error("%0t : Assertion failed. rs1 is %b should be %b", $time,rs1, Register_Source_1_s); 
        
        assert(Register_Source_2_s == rs2) 
        $display("%0t : Assertion passed. rd is %b", $time,rs2); 
        else $error("%0t : Assertion failed. rs1 is %b should be %b", $time,rs2, Register_Source_2_s);
        
        imm_calc = {{51{immediate_SB_Typ_1[6]}}, immediate_SB_Typ_1[6:0], immediate_SB_Typ_2[4:0], 1'b0};
        assert(immediate_s == imm_calc) 
        $display("%0t : Assertion passed. immediate_s is %b", $time,immediate_s); 
        else $error("%0t : Assertion failed. immediate_s is %b should be %b", $time,immediate_s, imm_calc);
        
        assert(pc_out_s == (imm_calc + pc_in_s)) 
        $display("%0t : Assertion passed. pc_out_s is %b ", $time,pc_out_s); 
        else $error("%0t : Assertion failed. pc_out_s is %b should be %b", $time,pc_out_s, (imm_calc + pc_in_s));
        
        assert(Alu_OP_s == alu_op_b_typ) 
        $display("%0t : Assertion passed. Alu_OP_s is %b ", $time,Alu_OP_s); 
        else $error("%0t : Assertion failed. Alu_OP_s is %b should be %b", $time,Alu_OP_s, alu_op_s_typ); 
        
        assert(Alu_Control_s == funct3) 
        $display("%0t : Assertion passed. Alu_Control_s is %b ", $time,Alu_Control_s); 
        else $error("%0t : Assertion failed. Alu_Control_s is %b should be %b", $time,Alu_Control_s, alu_control_add);
        
        assert(MemtoReg_s == 'b0) 
        $display("%0t : Assertion passed. MemtoReg_s is %b ", $time,MemtoReg_s); 
        else $error("%0t : Assertion failed. MemtoReg_s is %b should be %b", $time,MemtoReg_s, 'b0);
        
        assert(MemWrite_s == 'b0) 
        $display("%0t : Assertion passed. MemWrite_s is %b ", $time,MemWrite_s); 
        else $error("%0t : Assertion failed. MemWrite_s is %b should be %b", $time,MemWrite_s, 'b0);
        
        assert(MemRead_s == 'b0) 
        $display("%0t : Assertion passed. MemRead_s is %b ", $time,MemRead_s); 
        else $error("%0t : Assertion failed. MemRead_s is %b should be %b", $time,MemRead_s, 'b0);
        
        assert(RegWrite_s == 'b0) 
        $display("%0t : Assertion passed. RegWrite_s is %b ", $time,RegWrite_s); 
        else $error("%0t : Assertion failed. RegWrite_s is %b should be %b", $time,RegWrite_s, 'b1);
        
        assert(AluSrc_s == 'b0) 
        $display("%0t : Assertion passed. AluSrc_s is %b ", $time,AluSrc_s); 
        else $error("%0t : Assertion failed. AluSrc_s is %b should be %b", $time,AluSrc_s, 'b1);
        
        #1;
        $display ("Test of B-Type Instruction: Branch not taken");
        nxt_pc_s = nxt_pc_s + 4;
        pc_in_s = nxt_pc_s;
        zero_s = 'b0;
        immediate_SB_Typ_1 = 'b0011111;
        immediate_SB_Typ_2 = 'b00111;
        rs1 = 'b11000;
        rs2 = 'b10001;
        opcode = B_TYPE;
        #1;
        instruction_s = {immediate_SB_Typ_1, rs2, rs1, funct3, immediate_SB_Typ_2, opcode};
        #1;
        // 0011 111 10001 11000 110 00111 0100011
        assert(instruction_s == 'b00111111000111000110001111100011) 
        $display("%0t : Assertion passed. Current Instruction is %b ", $time, instruction_s); 
        else $error("%0t : Assertion failed. Current Instruction is %b ", $time, instruction_s);
        
        assert(Register_Source_1_s == rs1) 
        $display("%0t : Assertion passed. rs1 is %b", $time,rs1); 
        else $error("%0t : Assertion failed. rs1 is %b should be %b", $time,rs1, Register_Source_1_s); 
        
        assert(Register_Source_2_s == rs2) 
        $display("%0t : Assertion passed. rd is %b", $time,rs2); 
        else $error("%0t : Assertion failed. rs1 is %b should be %b", $time,rs2, Register_Source_2_s);
        
        imm_calc = {{51{immediate_SB_Typ_1[6]}}, immediate_SB_Typ_1[6:0], immediate_SB_Typ_2[4:0], 1'b0};
        assert(immediate_s == imm_calc) 
        $display("%0t : Assertion passed. immediate_s is %b", $time,immediate_s); 
        else $error("%0t : Assertion failed. immediate_s is %b should be %b", $time,immediate_s, imm_calc);
        
        assert(pc_out_s == (nxt_pc_s)) 
        $display("%0t : Assertion passed. pc_out_s is %b ", $time,pc_out_s); 
        else $error("%0t : Assertion failed. pc_out_s is %b should be %b", $time,pc_out_s, nxt_pc_s);
        
        assert(Alu_OP_s == alu_op_b_typ) 
        $display("%0t : Assertion passed. Alu_OP_s is %b ", $time,Alu_OP_s); 
        else $error("%0t : Assertion failed. Alu_OP_s is %b should be %b", $time,Alu_OP_s, alu_op_s_typ); 
        
        assert(Alu_Control_s == funct3) 
        $display("%0t : Assertion passed. Alu_Control_s is %b ", $time,Alu_Control_s); 
        else $error("%0t : Assertion failed. Alu_Control_s is %b should be %b", $time,Alu_Control_s, alu_control_add);
        
        assert(MemtoReg_s == 'b0) 
        $display("%0t : Assertion passed. MemtoReg_s is %b ", $time,MemtoReg_s); 
        else $error("%0t : Assertion failed. MemtoReg_s is %b should be %b", $time,MemtoReg_s, 'b0);
        
        assert(MemWrite_s == 'b0) 
        $display("%0t : Assertion passed. MemWrite_s is %b ", $time,MemWrite_s); 
        else $error("%0t : Assertion failed. MemWrite_s is %b should be %b", $time,MemWrite_s, 'b0);
        
        assert(MemRead_s == 'b0) 
        $display("%0t : Assertion passed. MemRead_s is %b ", $time,MemRead_s); 
        else $error("%0t : Assertion failed. MemRead_s is %b should be %b", $time,MemRead_s, 'b0);
        
        assert(RegWrite_s == 'b0) 
        $display("%0t : Assertion passed. RegWrite_s is %b ", $time,RegWrite_s); 
        else $error("%0t : Assertion failed. RegWrite_s is %b should be %b", $time,RegWrite_s, 'b1);
        
        assert(AluSrc_s == 'b0) 
        $display("%0t : Assertion passed. AluSrc_s is %b ", $time,AluSrc_s); 
        else $error("%0t : Assertion failed. AluSrc_s is %b should be %b", $time,AluSrc_s, 'b1);
        
    end
    
endmodule
