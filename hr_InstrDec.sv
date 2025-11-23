module hr_instr_decoder(
    input logic [31:0] instruction_i,
    input logic [63:0] pc_i,
    input logic [63:0] nxt_pc_i,
    input logic zero_flag_i,
    output logic [4:0] Register_Source_1_o,
    output logic [4:0] Register_Source_2_o,
    output logic [4:0] Register_Dest_o,
    output logic [63:0] pc_o,
    output logic [1:0] Alu_OP_o,
    output logic [3:0] Alu_Control_o,
    output logic MemtoReg_o,
    output logic MemWrite_o,
    output logic MemRead_o,
    output logic RegWrite_o,
    output logic AluSrc_o,
    output logic [63:0] immediate_o
    );
    
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
    
    
    logic [6:0] opcode;
    logic [6:0] funct7;
    logic [2:0] funct3;
    logic [11:0] imm_I_Typ;
    logic [11:0] imm_S_Typ;
    logic [11:0] imm_B_Typ;
    logic branch_control;
    
    // Dekodieren des Opcodes (die niedrigsten 7 Bits der Instruktion)
    always @(*) 
    begin        
        opcode = instruction_i[6:0];
                // Register und Immediate-Felder basierend auf Opcode setzen
        case (opcode)            
            R_TYPE: 
                begin // R-Typ
                Register_Dest_o = instruction_i[11:7];        // rd are 5 Bits from instruction [11:7]      // connected to write adress of register             
                funct3 = instruction_i[14:12];                // funct3 are 3 bits from instruction [14:12] // used to differentiate function of R-Type
                Register_Source_1_o = instruction_i[19:15];   // rs1 are 5 bits from instruction[19:15]     // connected to Read Adress 1 from the Register    
                Register_Source_2_o = instruction_i[24:20];   // rs2 are 5 bits from instruction[24:10]     // connected ro Read Adress 2 from the Register
                funct7 = instruction_i[31:25];                // funct7 are 7 bits from instruction[31:25]  // used to differentiate function of R-Type
                                                              // Immediate Generator for accessing the Data Memory or to calculate the next adress if Branch occured
                immediate_o = 64'd0;                            // not used in R-Type instructions 
                // Writing the Control Signals to the Multiplexers, Alu, Register and Data Memory
                Alu_OP_o = alu_op_r_typ;
                MemtoReg_o = 'b0;
                MemWrite_o = 'b0;
                MemRead_o = 'b0;
                branch_control = 'b0;
                RegWrite_o = 'b1;
                AluSrc_o = 'b0;
                //Alu_Control_o = funct3;
                case (funct3) 
                      funct3_add_sub:
                          begin 
                          if (funct7 == funct7_add)
                               Alu_Control_o = alu_control_add;
                          else if (funct7 == funct7_sub)
                              Alu_Control_o = alu_control_sub;
                          end
                      funct3_and:
                          Alu_Control_o = alu_control_and;
                      funct3_or:
                         Alu_Control_o = alu_control_or;
                endcase
                pc_o = nxt_pc_i; 
                end           
            I_TYPE: 
                begin // I-Typ für Load Instruction
                Register_Dest_o = instruction_i[11:7];        // rd are 5 bits from instruction [11:7]      // connected to the write adress  of register       
                funct3 = instruction_i[14:12];                // funct3 are 3 bits from instruction [14:12] // used to differentiate function of I-Type
                                                              // only one I-Typ Instruction is used => funct3 field isn't used for further process
                Register_Source_1_o = instruction_i[19:15];   // rs1 are 5 bits from instruction[19:15]     // connected to Read Adress 1 from the Register             
                imm_I_Typ = instruction_i[31:20];             // imm_I_Typ are 12 bits from instruction [31:20] // Offset for wide adressing in Data Memory             
                immediate_o = {{52{imm_I_Typ[11]}}, imm_I_Typ}; // Sign-extended imm_I_Typ for 64 bit addition with ALU
                
                // Writing the Control Signals to the Multiplexers, Alu, Register and Data Memory
                Alu_OP_o = alu_op_i_typ;
                Alu_Control_o = funct3;
                MemtoReg_o = 'b1;
                MemWrite_o = 'b0;
                MemRead_o = 'b1;
                branch_control = 'b0;
                RegWrite_o = 'b1;
                AluSrc_o = 'b1;
                pc_o = nxt_pc_i;
                
                end            
            S_TYPE: 
                begin // S-Typ for Store Instruction             
                funct3 = instruction_i[14:12];                // funct3 are 3 bits from instruction [14:12] // used to differentiate function of S-Type
                                                              // only one S-Typ Instruction is used => funct3 field isn't used for further process
                Register_Source_1_o = instruction_i[19:15];   // rs1 are 5 bits from instruction[19:15]     // connected to Read Adress 1 from the Register             
                Register_Source_2_o = instruction_i[24:20];   // rs2 are 5 bits from instruction[24:120]     // connected to Write Adress of the Data Memory
                imm_S_Typ[11:5] = instruction_i[31:25];       // Part1 of imm_S_Typ from instruction [31:25] // part1 of Offset for wide adressing in Data Memory 
                imm_S_Typ[4:0] = instruction_i[11:7];         // Part2 of imm_S_Typ from instruction [11:7] // part2 of Offset for wide adressing in Data Memory   
                immediate_o = {{52{imm_S_Typ[11]}}, imm_S_Typ}; // Sign-extended imm_S_Typ for 64 bit addition with ALU
                
                // Writing the Control Signals to the Multiplexers, Alu, Register and Data Memory
                Alu_OP_o = alu_op_s_typ;
                Alu_Control_o = funct3;
                MemtoReg_o = 'b0;
                MemWrite_o = 'b1;
                MemRead_o = 'b0;
                branch_control = 'b0;
                RegWrite_o = 'b0;
                AluSrc_o = 'b1;
                pc_o = nxt_pc_i;
                end            
            B_TYPE: 
                begin // B-Typ for Branch Instruction                   
                funct3 = instruction_i[14:12];                // funct3 are 3 bits from instruction [14:12] // used to differentiate function of S-Type
                                                              // only one S-Typ Instruction is used => funct3 field isn't used for further process
                Register_Source_1_o = instruction_i[19:15];   // rs1 are 5 bits from instruction[19:15]     // connected to Read Adress 1 from the Register            
                Register_Source_2_o = instruction_i[24:20];   // rs2 are 5 bits from instruction[24:20]     // connected to connected ro Read Adress 2 from the Register
                imm_B_Typ[11:5] = instruction_i[31:25];       // Part1 of imm_B_Typ from instruction [31:25] // part1 of Offset for wide adressing in PC relative adressing
                imm_B_Typ[4:0] = instruction_i[11:7];         // Part2 of imm_B_Typ from instruction [11:7] // part2 of Offset for wide adressing in PC relative adressing
                immediate_o = {{51{imm_B_Typ[11]}}, imm_B_Typ[11:0], 1'b0}; // Sign-extended and shifted by 1 imm_B_Typ for 64 bit addition with PC 
                
                // Writing the Control Signals to the Multiplexers, Alu, Register and Data Memory
                Alu_OP_o = alu_op_b_typ;
                Alu_Control_o = funct3;
                MemtoReg_o = 'b0;
                MemWrite_o = 'b0;
                MemRead_o = 'b0;
                branch_control = 'b1;
                RegWrite_o = 'b0;
                AluSrc_o = 'b0;
                // Calculating the branch target adress
                if (branch_control & zero_flag_i) // Branch taken ?
                    pc_o = pc_i + ({{51{imm_B_Typ[11]}}, imm_B_Typ[11:0], 1'b0}); // calculate branch target adress
                else 
                    pc_o = nxt_pc_i; // Branch not taken 
                end            
            default: 
                begin
                // Für unbekannte oder nicht unterstützte Opcodes                
                Register_Dest_o = 5'b00101;
                funct3 = 3'b0;                
                Register_Source_1_o = 5'b0;
                Register_Source_2_o = 5'b0;                
                funct7 = 7'b0;
                immediate_o = 64'b0;            
                end
        
        endcase    
    end
endmodule
