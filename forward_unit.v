`timescale 1ns / 1ps
 
module forward_unit(
input [4:0] id_ex_rs1,
input [4:0] id_ex_rs2,
input [4:0] ex_mem_rd,
input ex_mem_reg_write ,
input [4:0] mem_wb_reg,
input mem_wb_reg_write,
output reg [1:0] forward_a ,
output reg [1:0] forward_b
    );
    
    always @(*) begin 
    forward_a = 2'b00;
    forward_b= 2'b00;
    
    if(ex_mem_reg_write && (ex_mem_rd!=5'b00000) && (id_ex_rs1==ex_mem_rd))begin 
    forward_a = 2'b10; 
     end 
     
    else   if(mem_wb_reg_write && (mem_wb_reg!=5'b00000) && (id_ex_rs1==mem_wb_reg))begin 
    forward_a = 2'b01;
     end 
     
     
     
    if(ex_mem_reg_write && (ex_mem_rd!=5'b00000) && (id_ex_rs2==ex_mem_rd)) begin 
    forward_b= 2'b10;
    end 
    
   else     if(mem_wb_reg_write && (mem_wb_reg!=5'b00000) && (id_ex_rs2==mem_wb_reg)) begin 
    forward_b= 2'b01;
    end
    
    end 
endmodule
