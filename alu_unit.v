`timescale 1ns / 1ps
 
module alu(
input [31:0] src1 ,
input [31:0] src2 , 
input [5:0] alu_control ,
 output reg [31:0] result ,
output reg zero //high if result is 0 
    );
    always @(*) begin 
    zero =0 ;
    
    case(alu_control) 
             6'b000001: result = src1 + src2;                  // ADD
            6'b001001: result = src1 - src2;                  // SUB
            6'b000010: result = src1 << src2[4:0];                // SLL
            6'b000011: result = ($signed(src1) < $signed(src2)) ? 32'd1 : 32'd0; // SLT
            6'b000100: result = (src1 < src2) ? 32'd1 : 32'd0; // SLTU
            6'b000101: result = src1 ^ src2;                  // XOR
            6'b000110: result = src1 >> src2[4:0];                // SRL
            6'b001010: result = $signed(src1) >>> src2[4:0];      // SRA (Arithmetic Shift)
            6'b000111: result = src1 | src2;                  // OR
            6'b001000: result = src1 & src2;                  // AND

            // --- Branch Comparisons ---
            // These return 1 (True) or 0 (False) to the datapath
            6'b010000: result = (src1 == src2) ? 32'd1 : 32'd0;                   // BEQ
            6'b010001: result = (src1 != src2) ? 32'd1 : 32'd0;                   // BNE
            6'b010010: result = ($signed(src1) >= $signed(src2)) ? 32'd1 : 32'd0; // BGE
            6'b010011: result = ($signed(src1) < $signed(src2)) ? 32'd1 : 32'd0;  // BLT

            default: result = 32'd0;
        endcase

        // Update Zero Flag (useful for standard BEQ logic if needed later)
        if (result == 0) zero = 1;
        end
endmodule
