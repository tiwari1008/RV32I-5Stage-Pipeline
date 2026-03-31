`timescale 1ns / 1ps
 
module instrc_fetch_unit(
input clk ,
input rst , 
input [31:0]  next_pc , 
output reg [31:0] pc ,
input pc_write_en
     );
 
     always @(posedge clk ) begin 
     if(rst) begin 
     pc<= 0 ;
     end 
     
     else if(pc_write_en ) begin 
     pc<= next_pc ;
     end 
     end 
endmodule
