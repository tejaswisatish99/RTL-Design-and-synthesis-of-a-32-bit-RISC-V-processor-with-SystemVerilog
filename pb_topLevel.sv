module pb_topLevel(
    input [31:0] loadData_i,
    input [63:0] loadAddr_i,
    input wrEn_i,
    input clk_i,
    input rst_n_i
    //output reg addrBus, dataBus
    );
    
wire [63:0] currentPc_s;
wire [63:0] nextPc_s;
wire [63:0] newPc_s;
wire clk_s, rst_n_s;
wire [31:0] instr_s;

wire regwrite_s, alusrc_s, zero_s, memtoreg_s, ren_s, wen_s;
wire [4:0] waddr_s, raddr1_s, raddr2_s;
wire [3:0] aluinstr_s;
wire [1:0] aluop_s;
wire [63:0] wdata_s, imm_s, rdata1_s, rdata2_s, rdata2x_s, aluresult_s;

    assign 
    clk_s = clk_i,
    rst_n_s = rst_n_i;
    
     // Instantiate the Instruction Memory Top module
    se_InstrMem_top instr_mem_top (
        .pci_i(newPc_s),
        .loadData_i(loadData_i),
        .loadAddr_i(loadAddr_i),
        .wrEn_i(wrEn_i),
        .rst_n_i(rst_n_s),
        .clk_i(clk_s),
        .instr_o(instr_s),
        .pco_o(currentPc_s),
        .nextAddr_o(nextPc_s)
    );

    // Instantiate the Instruction Decoder module
   hr_instr_decoder instr_decoder (
        .instruction_i(instr_s),
        .pc_i(currentPc_s),
        .nxt_pc_i(nextPc_s),
        .zero_flag_i(zero_s),
        .Register_Source_1_o(raddr1_s),
        .Register_Source_2_o(raddr2_s),
        .Register_Dest_o(waddr_s),
        .pc_o(newPc_s),
        .Alu_OP_o(aluop_s),
        .Alu_Control_o(aluinstr_s),
        .MemtoReg_o(memtoreg_s),
        .MemWrite_o(wen_s),
        .MemRead_o(ren_s),
        .RegWrite_o(regwrite_s),
        .AluSrc_o(alusrc_s),
        .immediate_o(imm_s)
    );

    
    te_regFile regfile(
        .clk_i(clk_s), 
        .wEn_i(regwrite_s), 
        .selMux_i(alusrc_s), 
        .wAddr01_i(waddr_s), 
        .wData_i(wdata_s), 
        .rAddr01_i(raddr1_s), 
        .rAddr02_i(raddr2_s),
        .imm_i(imm_s),
        .rData01_o(rdata1_s), 
        .rData02_o(rdata2_s),
        .rData02x_o(rdata2x_s)
    );
    
    rd_ALU_top alu(
        .A_i(rdata1_s),
        .B_i(rdata2x_s),
        .instruction_i(aluinstr_s),
        .ALUop_i(aluop_s),
        .C_o(aluresult_s),
        .zero_o(zero_s)
	);
	
	ni_DataMemory dmem(
    .clk_i(clk_s),
    .address_i(aluresult_s), // where does this one come From??? <-<--<-?
    .write_data_i(rdata2_s), //Data from RegFile?
    .write_enable_i(wen_s), //wEn 
    .read_enable_i(ren_s), //rEn
    .memtoreg_i(memtoreg_s), //mem2reg
    .alu_result_i(aluresult_s),  //aluResult
    .read_data_o(wdata_s) //rData
);

    
endmodule: pb_topLevel
