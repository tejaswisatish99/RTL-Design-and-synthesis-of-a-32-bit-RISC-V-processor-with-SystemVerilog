`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.05.2024 00:57:43
// Design Name: 
// Module Name: se-pc-tb
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


module se_pc_tb;

logic rst_n;
logic clk;
logic [63:0] pci;
logic [63:0] pco;

se_pc DUT (.pci_i(pci), .pco_o(pco), .rst_n_i(rst_n), .clk_i(clk));

always #5 clk = ~clk; // Clock Generation

// Reset and End of Simulation  
initial begin
    $timeformat(-9, 2, " ns", 20);
    rst_n = 0;  // perform a reset in the beginning
    $display("%0t : Performing Reset...", $time);
    #10;        // wait 10 time units
    rst_n = 1;  // start execution
    #100;       // wait 100 time units before next reset
    $display("%0t : Performing Reset...", $time);
    rst_n = 0;  // another reset
    #10;        // wait 10 time units 
    rst_n = 1;  // another reset
    #100;       // wait 100 time units...
    $display("%0t : Exiting Simulation", $time);
    $finish;    // ... before finishing the simulation
end

// Signal Generation
initial begin
    clk = 0;    //initialize clock
    pci = 64'hDEAD_BEEF_C001_CAFE;
    #20;
    pci = 64'hC001_BEEF_DEAD_CAFE;
    #15;
    pci = 64'hCAFE_BEEF_C001_DEAD;
    #50;
    pci = 64'hBEEF_CAFE_DEAD_C001;
    #30;
    pci = 64'hBEEF_DEAD_C001_CAFE;
    #15;
    pci = 64'hDEAD_CAFE_C001_BEEF;
end

always @(posedge clk or negedge rst_n) begin
    $timeformat(-9, 2, " ns", 20);
    #1;
    if(!rst_n)
        assert(pco == 64'h0) $display("%0t : Assertion passed. Current Program Counter is %h ", $time, pco); 
            else $error("%0t : Assertion failed. Wrong Program Counter Current Program Counter is is %h ", $time, pco);
    else 
        assert(pco == pci) $display("%0t : Assertion passed. Current Program Counter is %h ", $time, pco); 
            else $error("%0t : Assertion failed. Wrong Program Counter Current Program Counter is is %h ", $time, pco);
end
endmodule
