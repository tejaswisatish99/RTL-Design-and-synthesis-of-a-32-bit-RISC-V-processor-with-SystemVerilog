`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.05.2024 22:37:42
// Design Name: 
// Module Name: se-four_adder-tb
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


module se_four_adder_tb;
    logic [63:0] pco;
    logic [63:0] nextAddr;
    logic c;
    
    se_four_adder DUT (.pco_i(pco), .nextAddr_o(nextAddr), .c_o(c));
    
    initial begin
    $timeformat(-9, 2, " ns", 20);
    
        pco = 0;
        #10;
        assert(nextAddr == 64'd4 && c == 0) $display("%0t : Assertion passed. Next Address is %h, carry is %b", $time, nextAddr, c);
            else $error("%0t : Assertion failed. Wrong address or carry. Next Address is %h, carry is %b", $time, nextAddr, c);
        
        pco = 64'd100;
        #10;
        assert(nextAddr == 64'd104 && c == 0) $display("%0t : Assertion passed. Next Address is %h, carry is %b", $time, nextAddr, c); 
            else $error("%0t : Assertion failed. Wrong address or carry. Next Address is %h, carry is %b", $time, nextAddr, c);
       
        
        pco = 64'hFFFF_FFFF_FFFF_FFFB;
        #10;
        assert(nextAddr == 64'hFFFF_FFFF_FFFF_FFFF && c == 0) $display("%0t : Assertion passed. Next Address is %h, carry is %b", $time, nextAddr, c); 
            else $error("%0t : Assertion failed. Wrong address or carry. Next Address is %h, carry is %b", $time, nextAddr, c);
        
        pco = 64'hFFFF_FFFF_FFFF_FFFD;
        #10;
        assert(nextAddr == 64'h1 && c == 1) $display("%0t : Assertion passed. Next Address is %h, carry is %b", $realtime, nextAddr, c); 
            else $error("%0t : Assertion failed. Wrong address or carry. Next Address is %h, carry is %b", $realtime, nextAddr, c);
            
        pco = 64'd100;
        #10;
        assert(nextAddr == 64'd104 && c == 0) $display("%0t : Assertion passed. Next Address is %h, carry is %b", $time, nextAddr, c); 
            else $error("%0t : Assertion failed. Wrong address or carry. Next Address is %h, carry is %b", $time, nextAddr, c);
    
    end
endmodule
