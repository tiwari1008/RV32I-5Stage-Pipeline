`timescale 1ns / 1ps
  
module stall(
input [4:0] if_id_rs1_num,
input [4:0] if_id_rs2_num,
input id_ex_mem_to_reg,
input [4:0] id_ex_write_reg_num,

output   pc_write ,
output   if_id_write ,
output   control_mux
    );
    
    wire stall ;
    assign stall = (id_ex_mem_to_reg)&&(id_ex_write_reg_num!=5'b00000) && 
    ((if_id_rs1_num==id_ex_write_reg_num) ||(if_id_rs2_num==id_ex_write_reg_num));
    
    assign pc_write= ~stall;
        assign if_id_write = ~stall;
    assign control_mux= ~stall;


    
endmodule
