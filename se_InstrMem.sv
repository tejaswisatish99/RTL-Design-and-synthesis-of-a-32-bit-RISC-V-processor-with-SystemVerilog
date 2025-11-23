`timescale 1ns / 1ps

module se_instr_mem(
    input logic [31:0] loadData_i,
    input logic [63:0] loadAddr_i,
    input logic wrEn_i,
    input logic [63:0] pco_i,
    output logic [31:0] instr_o,
    input logic rst_n_i,
    input logic clk_i
    );

logic [7:0] registers [4095:0]; // Instruction Memory with 4KB

initial
    begin
        $readmemh("pb_instructions.txt", registers);
    end
    
/*always_ff @(negedge rst_n_i or posedge clk_i) begin
        if (!rst_n_i)                   // rst_n_i = 0
            foreach (registers[i]) begin
                registers[i] <= 8'h0;  // Reset to zero 
            end
        else if (clk_i && wrEn_i)
            registers[loadAddr_i] <= loadData_i[7:0];
            registers[loadAddr_i+1] <= loadData_i[15:8];
            registers[loadAddr_i+2] <= loadData_i[23:16];
            registers[loadAddr_i+3] <= loadData_i[31:24];
end*/ 
        
assign instr_o = {registers[pco_i], registers[pco_i+1], registers[pco_i+2], registers[pco_i+3]}; // Output one word (4Byte) instruction

endmodule