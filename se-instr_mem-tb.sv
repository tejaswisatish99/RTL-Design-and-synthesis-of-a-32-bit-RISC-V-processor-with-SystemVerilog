`timescale 1ns / 1ps

module se_instr_mem_tb();

logic [31:0] loadData;
logic [63:0] loadAddr;
logic wrEn;
logic [63:0] pco;
logic [31:0] instr;
logic rst_n;
logic clk;

logic [31:0] tmpData [1023:0];
logic [63:0] tmpAddr = 0;
integer k = 0;
logic [63:0] i = 0;


se_instr_mem DUT (.loadData_i(loadData), .loadAddr_i(loadAddr), .wrEn_i(wrEn), .pco_i(pco), .instr_o(instr), .rst_n_i(rst_n), .clk_i(clk));

always #5 clk = ~clk; // Clock Generation

// Reset and End of Simulation  
initial begin
    $timeformat(-9, 2, " ns", 20);
    $readmemh("/home/sarah/Dokumente/se-instruction_memory/se-instruction_memory.srcs/sim_1/new/instructions.txt", tmpData);
    rst_n = 0;  // perform a reset in the beginning
    $display("%0t : Performing Reset...", $time);
    #10;        // wait 10 time units
    rst_n = 1;  // start execution
    wrEn = 1;   // enable writing
    loadAddr = 64'h0;
    loadData = tmpData[0];
    #30000;     // wait for program to be loaded and "executed"
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
    clk = 0;
    pco = 64'h0;    // PC at address 0x0
    #11000
    
    for (i = 0; i < 4096; i = i + 4) begin
        pco = i;
        #1;
        
        #10;
    end
end
        
endmodule      
        
