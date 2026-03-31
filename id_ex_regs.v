`timescale 1ns / 1ps

module id_ex_regs(
    input clk,
    input rst,

     // INPUTS (From the ID stage)
 
    // --- Data & Addresses ---
    input [31:0] pc_in,
    input [31:0] read_data1_in,
    input [31:0] read_data2_in,
    input [31:0] imm_val_in,
    input [4:0]  write_reg_num_in, // The rd... destination address

//control_signal 

     input [5:0] alu_control_in,
    input       alu_src_in,
    input       lui_operation_in,
    input       jump_in,
    input       beq_control_in,
    input       bneq_control_in,
    input       bgeq_control_in,
    input       blt_control_in,
    input       mem_write_in,
    input       mem_to_reg_in, 
    input       reg_write_in,
    input [4:0] rs1_num_in,
    input [4:0] rs2_num_in,

    // ==========================================
    // OUTPUTS (To the EX stage and beyond)
    // ==========================================
      output reg [31:0] pc_out,
    output reg [31:0] read_data1_out,
    output reg [31:0] read_data2_out,
    output reg [31:0] imm_val_out,
    output reg [4:0]  write_reg_num_out,
 
 
      output reg [5:0] alu_control_out,
    output reg       alu_src_out,
    output reg       lui_operation_out,
    output reg       jump_out,
    output reg       beq_control_out,
    output reg       bneq_control_out,
    output reg       bgeq_control_out,
    output reg       blt_control_out,
    output reg       mem_write_out,
    output reg       mem_to_reg_out,
    output reg       reg_write_out,
    output reg [4:0] rs1_num_out,
    output reg [4:0] rs2_num_out,
    
    input flush
);

    always @(posedge clk) begin
        if (rst || flush) begin
             pc_out            <= 0;
            read_data1_out    <= 0;
            read_data2_out    <= 0;
            imm_val_out       <= 0;
            write_reg_num_out <= 0;
            
            alu_control_out   <= 0;
            alu_src_out       <= 0;
            lui_operation_out <= 0;
            jump_out          <= 0;
            beq_control_out   <= 0;
            bneq_control_out  <= 0;
            bgeq_control_out  <= 0;
            blt_control_out   <= 0;
            mem_write_out     <= 0;
            mem_to_reg_out    <= 0;
            reg_write_out     <= 0;
            rs1_num_out   <= 5'b00000;
            rs2_num_out  <= 5'b00000 ;
            
        end else  begin
             pc_out            <= pc_in;
            read_data1_out    <= read_data1_in;
            read_data2_out    <= read_data2_in;
            imm_val_out       <= imm_val_in;
            write_reg_num_out <= write_reg_num_in;
            
            alu_control_out   <= alu_control_in;
            alu_src_out       <= alu_src_in;
            lui_operation_out <= lui_operation_in;
            jump_out          <= jump_in;
            beq_control_out   <= beq_control_in;
            bneq_control_out  <= bneq_control_in;
            bgeq_control_out  <= bgeq_control_in;
            blt_control_out   <= blt_control_in;
            mem_write_out     <= mem_write_in;
            mem_to_reg_out    <= mem_to_reg_in;
            reg_write_out     <= reg_write_in;
            rs1_num_out <= rs1_num_in;
           rs2_num_out <= rs2_num_in;

            
        end
    end

endmodule