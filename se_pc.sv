`timescale 1ns / 1ps

module se_pc (
    input logic [63:0] pci_i,
    output logic [63:0] pco_o,
    input logic rst_n_i,
    input logic clk_i
);
    
    logic [63:0] addr;  // stored address
    
    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i)       // rst_n_i = 0 (active-low reset)
            addr <= 64'h0;  // Reset to zero 
        else 
            addr <= pci_i;  // store input address in addr 
    end
     
    assign pco_o = addr;  
    
endmodule
