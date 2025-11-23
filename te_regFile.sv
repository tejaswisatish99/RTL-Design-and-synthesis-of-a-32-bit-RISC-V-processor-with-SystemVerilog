`timescale 1ns / 1ps

module te_regFile( input clk_i, 
input wEn_i, 
input selMux_i, 
input [4:0] wAddr01_i, 
input [63:0] wData_i, 
input [4:0] rAddr01_i, 
input [4:0] rAddr02_i,
input [63:0] imm_i,
output reg [63:0] rData01_o, 
output reg [63:0] rData02_o,
output reg [63:0] rData02x_o );

logic [63:0] reg_array [31:0];

integer i;
initial begin
    for(i=0;i<32;i=i+1)
        reg_array[i] <= 64'd0;
end
 
always @ (posedge clk_i ) begin
    if(wEn_i)
        reg_array[wAddr01_i] <= wData_i;
end

always_comb begin
    rData01_o <= reg_array[rAddr01_i];
    rData02_o <= reg_array[rAddr02_i];
    rData02x_o <= (selMux_i==1'b1)? imm_i : reg_array[rAddr02_i];
    end

endmodule