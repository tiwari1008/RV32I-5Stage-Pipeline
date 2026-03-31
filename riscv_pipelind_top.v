`timescale 1ns / 1ps

module riscv_top(
    input clk,
    input rst
);
 
    wire [31:0] instruction_wire;
    
      wire [5:0] alu_control;
    wire       mem_to_reg;
    wire       mem_write;
    wire       alu_src;
    wire       reg_write;
    wire       lui_operation;
    wire       jump;
    wire       beq, bneq, bgeq, blt;

 
    // 1. The Control Unit (The Brain)
    control_unit CU (
        .opcode(instruction_wire[6:0]),     // Opcode from instruction
        .funct3(instruction_wire[14:12]),   // Funct3 from instruction
        .funct7(instruction_wire[31:25]),   // Funct7 from instruction
         
        // Outputs (Commands)
        .alu_control(alu_control),
        .mem_to_reg(mem_to_reg),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write),
        .lui_operation(lui_operation),
        .jump(jump),
        .beq_control(beq),
        .bneq_control(bneq),
        .bgeq_control(bgeq),
        .blt_control(blt)
    );

    // 2. The Data Path (The Body)
    data_path DP (
        .clk(clk),
        .rst(rst),
        
        // Inputs (Commands from CU)
        .alu_control(alu_control),
        .mem_to_reg(mem_to_reg),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write),
        .lui_operation(lui_operation),
        .jump(jump),
        .beq_control(beq),
        .bneq_control(bneq),
        .bgeq_control(bgeq),
        .blt_control(blt),
         // Output (Instruction to CU)
        .instruction_out(instruction_wire)
    );

endmodule