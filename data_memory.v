`timescale 1ns / 1ps
 

module data_memory(
input clk, 
input rst ,
input [31:0] addr,
input [31:0] write_data,
input memory_write,
input mem_read ,//sw
output [31:0] read_data
     );
     
     reg[31:0] memory [63:0] ; 
     integer i ;
     
     assign read_data=(mem_read)? memory[addr[31:2] ] : 32'd0 ;
     
     always @( posedge clk ) begin 
     
     if(rst) 
   begin 
   for(i=0 ; i<64 ; i=i+1) 
   memory[i] <= 32'd0 ; 
   end 
   else if(memory_write) begin 
     memory[addr[31:2]]<= write_data;
     end 
     end 
endmodule
