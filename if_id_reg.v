`timescale 1ns/1ps

module if_id_regs(
input clk ,
input rst,
input [31:0] pc_in ,
input [31:0] instruction_in ,
output reg [31:0] pc_out ,
output reg [31:0] instruction_out ,
input if_id_write_en ,
input flush 
);

always @(posedge clk ) begin
if(rst) begin 
pc_out<= 0 ;
instruction_out<= 0 ;
end 

else if(flush) begin 
pc_out<= 0 ;
instruction_out<= 0 ;
end

else if(if_id_write_en)   begin 
pc_out<= pc_in ;
instruction_out<= instruction_in ;
end 
 
end 
endmodule