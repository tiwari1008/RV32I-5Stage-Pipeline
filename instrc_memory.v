`timescale 1ns / 1ps
  
module instrc_memory(
input [31:0] pc ,
output [31:0] instruction_out
     );    
     
    reg [7:0] memory[1023:0]; 
 assign instruction_out = {memory[pc+3], memory[pc+2] , memory[pc+1] , memory[pc]};
        integer i ;
        
   initial begin 
        for(i= 0; i<1023; i = i+1) begin
            memory[i] = 8'b0; // Changed to blocking assignment
        end
    
    // -------- RV32I R-TYPE INSTRUCTIONS --------

        // add x1, x2, x3      -> 0x003100B3
        memory[3]  = 8'h00; 
        memory[2]  = 8'h31; 
        memory[1]  = 8'h00;
         memory[0]  = 8'hB3;

        // sub x5, x6, x7      -> 0x407302B3
        memory[7]  = 8'h40; 
        memory[6]  = 8'h73;
         memory[5]  = 8'h02;
          memory[4]  = 8'hB3;

        // and x8, x9, x10     -> 0x00A4F433
        memory[11] = 8'h00;
         memory[10] = 8'hA4;
          memory[9]  = 8'hF4;
           memory[8]  = 8'h33;

        // or x11, x12, x13    -> 0x00D665B3
        memory[15] = 8'h00;
         memory[14] = 8'hD6;
          memory[13] = 8'h65;
           memory[12] = 8'hB3;

        // xor x14, x15, x16   -> 0x0107C733
        memory[19] = 8'h01; 
        memory[18] = 8'h07;
         memory[17] = 8'hC7;
          memory[16] = 8'h33;

        // sll x17, x18, x19   -> 0x013918B3
        memory[23] = 8'h01;
         memory[22] = 8'h39;
          memory[21] = 8'h18;
           memory[20] = 8'hB3;

        // srl x20, x21, x22   -> 0x016ADA33
        memory[27] = 8'h01;
         memory[26] = 8'h6A;
          memory[25] = 8'hDA; 
          memory[24] = 8'h33;

        // sra x23, x24, x25   -> 0x419C5BB3
        memory[31] = 8'h41;
         memory[30] = 8'h9C;
          memory[29] = 8'h5B;
           memory[28] = 8'hB3;

        // slt x26, x27, x28   -> 0x01CDAD33
        memory[35] = 8'h01;
         memory[34] = 8'hCD;
          memory[33] = 8'hAD; 
          memory[32] = 8'h33;

        // sltu x29, x30, x31  -> 0x01FF3EB3
        memory[39] = 8'h01;
         memory[38] = 8'hFF;
          memory[37] = 8'h3E;
           memory[36] = 8'hB3;

        // -------- I-TYPE INSTRUCTIONS --------

        // addi x1, x2, 10     -> 0x00A10113
        memory[43] = 8'h00; 
        memory[42] = 8'hA1;
         memory[41] = 8'h01;
          memory[40] = 8'h13;

        // xori x3, x4, 7      -> 0x00724193
        memory[47] = 8'h00; 
        memory[46] = 8'h72;
         memory[45] = 8'h41;
          memory[44] = 8'h93;

        // andi x5, x6, 15     -> 0x00F37293
        memory[51] = 8'h00;
         memory[50] = 8'hF3;
          memory[49] = 8'h72;
           memory[48] = 8'h93;

        // ori x7, x8, 3       -> 0x00346393
        memory[55] = 8'h00;
         memory[54] = 8'h34;
          memory[53] = 8'h63; 
          memory[52] = 8'h93;

        // slti x9, x10, 4     -> 0x00452493
        memory[59] = 8'h00;
         memory[58] = 8'h45;
          memory[57] = 8'h24;
           memory[56] = 8'h93;

        // -------- LOAD (LUI) -------- 
        // LUI x1, 0x00002 -> 0x000020B7 (Note: your original hex 0x000283 was actually a LOAD instruction, not LUI. LUI opcode is 0110111)
        // Correcting based on your comment "Load upper immediate":
        memory[63]= 8'h00;
         memory[62]= 8'h00;
          memory[61]= 8'h20;
           memory[60]= 8'hB7; 


        // -------- STORE --------
        // sw x1, 40(x2)
        memory[67]= 8'h00;
         memory[66]= 8'h73;
          memory[65]= 8'h28;
           memory[64]= 8'h23;


        // -------- BRANCHES --------
        
        // beq
        memory[71] = 8'h00;
         memory[70] = 8'h41;
          memory[69] = 8'h00; 
          memory[68] = 8'h63;

        // bne
        memory[75] = 8'h00;
         memory[74] = 8'h20;
          memory[73] = 8'h94;
           memory[72] = 8'h63;
        
        // bge
        memory[83] = 8'h00;
         memory[82] = 8'h41; 
         memory[81] = 8'hA4;
          memory[80] = 8'h63;

        // blt
        memory[87] = 8'h00;
         memory[86] = 8'h20;
          memory[85] = 8'hC1;
           memory[84] = 8'h63;

        // -------- JUMP --------
        // jal x1, offset
        memory[91] = 8'h00;
         memory[90] = 8'h00;
          memory[89] = 8'h00;
           memory[88] = 8'hEF;
        
        // slli instruction (placed later in memory)
        memory[95] = 8'h00; 
        memory[94] = 8'h22;
         memory[93] = 8'h11;
          memory[92] = 8'h13;
    
    end 
endmodule

