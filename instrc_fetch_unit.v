`timescale 1ns/1ps

module if_id_regs(
input clk ,
input rst,
input [31:0] pc_in ,
input [31:0] instruction_in ,
output reg [31:0] pc_out ,
output reg [31:0] instruction_out 
);

always @(posedge clk ) begin
if(rst) begin 
pc_out<= 0 ;
instruction_out<= 0 ;
end 

else begin 
pc_out<= pc_in ;
instruction_out<= instruction_in ;
end 
end 
endmodule