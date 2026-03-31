`timescale 1ns / 1ps
 

module ex_mem_regs(
input clk ,
input rst , 
input [31:0] alu_result_in,
input [31:0] branch_target_in,
input take_branch_in ,
input [31:0] read_data_2_in ,
input [31:0] pc_plus_4_in ,
input [31:0] imm_val_in , 
input [4:0] write_reg_num_in ,
input mem_write_in ,
input mem_to_reg_in,
input reg_write_in ,
input jump_in ,
input lui_operation_in,


output reg [31:0] alu_result_out ,
output reg [31:0] branch_target_out ,
 output reg  take_branch_out,
output reg  [31:0] read_data_2_out,
output reg  [31:0] pc_plus_4_out ,
output reg  [31:0] imm_val_out , 
output reg  [4:0] write_reg_num_out ,
output reg  mem_write_out ,
output reg  mem_to_reg_out,
output reg  reg_write_out ,
output reg  jump_out ,
output reg  lui_operation_out
    );
    
    always @(posedge clk ) begin 
    if(rst) begin 
    alu_result_out <=0;
  branch_target_out<=0;
  take_branch_out<=0;
  read_data_2_out<=0;
  pc_plus_4_out<=0;
  imm_val_out<=0;
  write_reg_num_out<=0;
  mem_write_out<=0;
  mem_to_reg_out<=0;
  reg_write_out<=0;
  jump_out<=0;
  lui_operation_out<=0;
     end 
    
    else begin 
        alu_result_out <=alu_result_in;
  branch_target_out<=branch_target_in;
  take_branch_out<=take_branch_in;
  read_data_2_out<=read_data_2_in;
  pc_plus_4_out<=pc_plus_4_in;
  imm_val_out<=imm_val_in;
  write_reg_num_out<=write_reg_num_in;
  mem_write_out<=mem_write_in;
  mem_to_reg_out<=mem_to_reg_in ;
  reg_write_out<=reg_write_in;
  jump_out<=jump_in;
  lui_operation_out<=lui_operation_in;
     end
     end
     endmodule