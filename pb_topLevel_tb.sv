`timescale 1ns / 1ps

module pb_tb_topLevel();

        logic loadData_s;
        logic loadAddr_s;
        logic wrEn_s;
        logic rst_n_s;
        logic clk_s;

pb_topLevel top(
    .loadData_i(loadData_s),
    .loadAddr_i(loadAddr_s),
    .wrEn_i(wrEn_s),
    .clk_i(clk_s),
    .rst_n_i(rst_n_s)
    //output reg addrBus, dataBus
    );
    
        
    // Clock generation
    always begin
        #5 clk_s = ~clk_s;
    end
    
   // $display("Initializing");

    initial begin
        // Initialize inputs
        $display("Machine Code and Assemblerprogram");
        $display("0010b503		 ld x10, 1(x1)  	--> load h 211");
        $display("0020b583		 ld x11, 2(x1)		--> load h 522");
        $display("00b50633		 add x12, x10, x11 	--> add 211 + 522 =733");
        $display("00c0b2a3		 sd x12, 5(x1)		--> store 733 to fifth ");
        $display("40a587b3		 sub x15, x11, x10	--> Sub 522-211=311");
        $display("00f0b323		 sd x15, 6(x1)		--> store 311 to sixth ");
        $display("0030b803		 ld x16, 3(x1)		--> load h 5");
        $display("0040b883		 ld x17, 4(x1)		--> load h 3");
        $display("01187933		 and x18, x16, x17	--> 5 AND 3 = 1");
        $display("011869b3		 or x19, x16, x17	--> 5 OR 3 = 7");
        $display("0120b3a3		 sd x18, 7(x1)		--> STORE 1 to seventh");
        $display("0130b423		 sd x19, 8(x1)		--> STORE 7 to eigth");
        $display("");
        $display("Initial DMem Values for calculations");
        $display("");
        $display("Value at top.dmem.data_memory[1]: %h", top.dmem.data_memory[1]);
        $display("Value at top.dmem.data_memory[2]: %h", top.dmem.data_memory[2]);
        $display("Value at top.dmem.data_memory[3]: %h", top.dmem.data_memory[3]);
        $display("Value at top.dmem.data_memory[4]: %h", top.dmem.data_memory[4]);
        $display("");

        loadData_s = 0;
        loadAddr_s = 64'h0;
        wrEn_s = 0;
        rst_n_s = 1;
        clk_s = 0;
        //currentPc_s = 0;            // initialize pci
        rst_n_s = 0;
        #10
        rst_n_s = 1;
        #150
        

     
 // Check register values using assertions
        $display("DMem Values after calculations");
        $display("");
        assert(top.dmem.data_memory[1] == 'h211) 
        $display("DMem[1] : Assertion passed. Value is %h ", top.dmem.data_memory[1]); 
        else $error("DMem[1] : Assertion failed. value is %h ", top.dmem.data_memory[1]);
        assert(top.dmem.data_memory[2] == 'h522) 
        $display("DMem[2] : Assertion passed. Value is %h ", top.dmem.data_memory[2]); 
        else $error("DMem[2] : Assertion failed. value is %h ", top.dmem.data_memory[2]);
        assert(top.dmem.data_memory[3] == 'h3) 
        $display("DMem[3] : Assertion passed. Value is %h ", top.dmem.data_memory[3]); 
        else $error("DMem[3] : Assertion failed. value is %h ", top.dmem.data_memory[3]);
        assert(top.dmem.data_memory[4] == 'h5) 
        $display("DMem[4] : Assertion passed. Value is %h ",  top.dmem.data_memory[4]); 
        else $error("DMem[4] : Assertion failed. value is %h ", top.dmem.data_memory[4]);
        assert(top.dmem.data_memory[5] == 'h733) 
        $display("DMem[5] : Assertion passed. Value is %h (522+211) ", top.dmem.data_memory[5]); 
        else $error("DMem[5] : Assertion failed. value is %h ", top.dmem.data_memory[5]);
        assert(top.dmem.data_memory[6] == 'h311) 
        $display("DMem[6] : Assertion passed. Value is %h (522-211) ",  top.dmem.data_memory[6]); 
        else $error("DMem[6] : Assertion failed. value is %h ",  top.dmem.data_memory[6]);
        assert(top.dmem.data_memory[7] == 'h1) 
        $display("DMem[7] : Assertion passed. Value is %h (3 AND 5) ",  top.dmem.data_memory[7]); 
        else $error("DMem[7] : Assertion failed. value is %h ",  top.dmem.data_memory[7]);
        assert(top.dmem.data_memory[8] == 'h7) 
        $display("DMem[8] : Assertion passed. Value is %h (3 OR 5) ",  top.dmem.data_memory[8]); 
        else $error("DMem[8] : Assertion failed. value is %h ",  top.dmem.data_memory[8]);
        
        $display("");
        $display("RegFile Values after program");
        $display("");

for (int i = 0; i < 20; i++) begin
            $display("Value at top.regfile.reg_array[%0d]: %h", i, top.regfile.reg_array[i]);
           
        end        
            $finish;
end

endmodule

