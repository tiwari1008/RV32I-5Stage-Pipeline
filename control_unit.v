`timescale 1ns / 1ps
  

module control_unit(
 
    input [6:0] opcode , 
   input [2:0] funct3 ,
   input [6:0] funct7,
   output reg [5:0] alu_control ,
   output reg mem_to_reg ,
   output reg mem_write ,//sw
   output reg alu_src,// if from reg then = 0 and if 1 then immidiate 
   output reg reg_write ,//enable to writting to regsiter file
   output reg lui_operation ,
   output reg jump ,
   output reg  beq_control ,
   output reg bneq_control ,
   output reg bgeq_control ,
   output reg blt_control 
    );
    
    always @(*) begin 
    alu_control = 6'b000000;
    mem_to_reg = 0;
    mem_write =0 ;
    alu_src= 0 ;
    reg_write = 0 ;
    lui_operation = 0 ;
    jump = 0 ;
    beq_control = 0 ;
    bneq_control = 0 ;
    bgeq_control = 0 ;
    blt_control = 0 ;
        
         case(opcode) 
        7'b0110011:begin 
        reg_write = 1 ;
        alu_src= 0 ;//use register for 2nd input also not immmidiate 
        if (funct7 == 0) begin
                        case (funct3)
                            3'b000: alu_control = 6'b000001; // ADD
                            3'b001: alu_control = 6'b000010; // SLL
                            3'b010: alu_control = 6'b000011; // SLT
                            3'b011: alu_control = 6'b000100; // SLTU
                            3'b100: alu_control = 6'b000101; // XOR
                            3'b101: alu_control = 6'b000110; // SRL
                            3'b110: alu_control = 6'b000111; // OR
                            3'b111: alu_control = 6'b001000; // AND
                        endcase
                    end
                    else if (funct7 == 7'b0100000) begin
                        case (funct3)
                            3'b000: alu_control = 6'b001001; // SUB
                            3'b101: alu_control = 6'b001010; // SRA
                        endcase
                    end
         end 
         
           // ---------------- I-TYPE ----------------
                7'b0010011: begin
                    reg_write = 1;
                    alu_src   = 1;  // Use Immediate
                    
                    case (funct3)
                        3'b000: alu_control = 6'b000001; // ADDI
                        3'b100: alu_control = 6'b000101; // XORI
                        3'b111: alu_control = 6'b001000; // ANDI
                        3'b110: alu_control = 6'b000111; // ORI
                        3'b010: alu_control = 6'b000011; // SLTI
                        3'b001: alu_control = 6'b000010; // SLLI
                        3'b101: begin                    // SRLI and SRAI
                            if (funct7 == 7'b0100000)
                                alu_control = 6'b001010; // SRAI
                            else
                                alu_control = 6'b000110; // SRLI
                        end
                        default: alu_control = 6'b000000;
                    endcase
                end
          // ---------------- LOAD (I-Type) ----------------
                7'b0000011: begin
                    reg_write  = 1;
                    mem_to_reg = 1; // Load from Memory
                    alu_src    = 1; // Addr = rs1 + imm
                    alu_control = 6'b000001; // ADD
                end

                // ---------------- STORE (S-Type) ----------------
                7'b0100011: begin
                    mem_write  = 1;
                    alu_src    = 1; // Addr = rs1 + imm
                    alu_control = 6'b000001; // ADD
                end

                // ---------------- BRANCH (B-Type) ----------------
                7'b1100011: begin
                    alu_src = 0; // Compare two registers
                    case (funct3)
                        3'b000: begin beq_control = 1;  alu_control = 6'b010000; end
                        3'b001: begin bneq_control = 1; alu_control = 6'b010001; end
                        3'b100: begin blt_control = 1;  alu_control = 6'b010011; end // Fixed mapping
                        3'b101: begin bgeq_control = 1; alu_control = 6'b010010; end // Fixed mapping
                    endcase
                end

                // ---------------- LUI (U-Type) ----------------
                7'b0110111: begin
                    reg_write     = 1;
                    lui_operation = 1;
                    // ALU not really used if handled in Datapath, or pass through
                end

                // ---------------- JAL (J-Type) ----------------
                7'b1101111: begin
                    reg_write = 1;
                    jump      = 1;
                end
          
     endcase
    end 
     
endmodule
