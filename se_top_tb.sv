`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.05.2024 23:00:01
// Design Name: 
// Module Name: se_top_tb
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


module se_top_tb();

logic rst_n;
logic clk;
logic [63:0] pci;
logic [31:0] loadData;
logic [63:0] loadAddr;
logic wrEn;
logic [63:0] nextAddr;
logic [63:0] pco;
logic [31:0] instr;

logic [31:0] tmpData [1023:0];
logic [63:0] tmpAddr = 0;
integer k = 0;
integer i = 0;
integer randomAddr = 0;
logic done = 0;


se_InstrMem_top DUT (.pci_i(pci), .pco_o(pco), .rst_n_i(rst_n), .clk_i(clk), .loadData_i(loadData), .loadAddr_i(loadAddr), .wrEn_i(wrEn), .nextAddr_o(nextAddr), .instr_o(instr));

always #5 clk = ~clk; // Clock Generation

// Initialization
initial begin
    $timeformat(-9, 0, " ns", 20);
    $readmemh("instructions.txt", tmpData);
    rst_n = 0;  // perform a reset in the beginning
    clk = 0;    // initializing clock
    $display("%0t : Performing Reset...", $time);
    $display(" ");
    #10;                // wait 10 time units
    $display("%0t : Loading Program / Writing Registers.", $time);
    rst_n = 1;          // start execution
    wrEn = 1;           // enable writing
    pci = 0;            // initialize pci
    loadAddr = 64'h0;   // initalize loadAddr
    loadData = tmpData[0];  // initalize loadData
end

// Load Program
always @(posedge clk)  begin
    if (wrEn == 1 && k<=1024) begin
        loadData <= tmpData[k];
        loadAddr <= tmpAddr;
        k <= k + 1;
        tmpAddr <= tmpAddr + 4;
            if (k==1024) begin
                $display("%0t : Program loading completed.", $time);
                $display(" ");
                k <= 0;
                wrEn <= 0;
            end
    end
end

// Next PC becomes current PC
always @(nextAddr or negedge wrEn) begin
    if (wrEn == 0 && nextAddr < 64'h1000 && done == 0) begin
        pci = nextAddr;
        assert(instr == tmpData[pco>>2]) $display("%0t : Assertion passed. Instruction at Byte %d is %h", $time, pco,instr); 
            else $fatal("%0t : Assertion failed. Instruction at Byte %d is %h when it should be %h", $time, pco,instr, tmpData[pco>>2]);
        assert(nextAddr == pco + 4) $display("%0t : Assertion passed. Next Address (Byte) is %d", $time, nextAddr); 
            else $fatal("%0t : Assertion failed. Next Address (Byte) is %d when it should be %d", $time, nextAddr, pco + 4);
    end
    else if (nextAddr >= 64'h1000 || done == 1) begin
        randomAddr = $urandom_range(0,1023)*4;
        done = 1;
        assert(instr == tmpData[pco>>2]) $display("%0t : Assertion passed. Instruction at Byte %d is %h", $time, pco,instr); 
            else $fatal("%0t : Assertion failed. Instruction at Byte %d is %h when it should be %h", $time, pco,instr, tmpData[pco>>2]);
        assert(nextAddr == pco + 4) $display("%0t : Assertion passed. Next Address (Byte) is %d", $time, nextAddr); 
            else $fatal("%0t : Assertion failed. Next Address (Byte) is %d when it should be %d", $time, nextAddr, pco + 4);
        i = i + 1;
        
        $display(" ");
        if (i == 5) begin
            $display("%0t : Simulation completed without Error. Exiting Simulation.", $time);
            $finish;
        end
        
        $display("%0t : Simulating Branch to Byte %d / Instruction %d.", $time, randomAddr, randomAddr >> 2);
        pci =  randomAddr;
    end
end

endmodule
