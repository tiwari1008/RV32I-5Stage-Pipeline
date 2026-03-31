`timescale 1ns / 1ps
 

module imm_gen(
input [31:0] instruction ,
output reg [31:0] imm_val 

    );
    wire[6:0] opcode = instruction[6:0];
    
    always @(*) begin
    case(opcode) 
 7'b0000011,7'b0010011 ://i type ,     , lui type as same immedisate value in [31:20]
imm_val = {{20{instruction[31]}}, instruction[31:20]};

//store type instruction 

7'b0100011: 
imm_val = {{20{instruction[31]}},instruction[31:25],instruction[11:7]};
//branch type 
 7'b1100011:
 imm_val={{20{instruction[31]}},instruction[7],instruction[30:25],instruction[11:8],1'b0};
 //jump type 
 
 7'b1101111:
 imm_val = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
 
 // u type 
 7'b0110111:
 imm_val= {instruction[31:12],12'b0};
 
 default : imm_val= 32'd0 ;
  
 
     endcase 
     end 
endmodule
