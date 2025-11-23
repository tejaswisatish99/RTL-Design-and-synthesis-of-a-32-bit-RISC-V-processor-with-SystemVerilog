`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.05.2024 22:30:02
// Design Name: 
// Module Name: se_top
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


module se_InstrMem_top(
    input logic [63:0] pci_i,
    input logic [31:0] loadData_i,
    input logic [63:0] loadAddr_i,
    input logic wrEn_i,
    input logic rst_n_i,
    input logic clk_i,
    output logic [31:0] instr_o,
    output logic [63:0] pco_o,
    output logic [63:0] nextAddr_o
    );
    
    logic [64:0] pco_w;
    
    se_pc pc (  .pci_i(pci_i), 
                .pco_o(pco_w), 
                .rst_n_i(rst_n_i), 
                .clk_i(clk_i));
                
    se_four_adder adder (   .pco_i(pco_w), 
                            .nextAddr_o(nextAddr_o));
                            
    se_instr_mem memory (   .loadData_i(loadData_i), 
                            .loadAddr_i(loadAddr_i), 
                            .wrEn_i(wrEn_i), 
                            .pco_i(pco_w), 
                            .instr_o(instr_o), 
                            .rst_n_i(rst_n_i), 
                            .clk_i(clk_i));

    assign pco_o = pco_w;    
endmodule
