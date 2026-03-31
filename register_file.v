`timescale 1ns / 1ps
 
module register_file(
input clk ,
input rst , 
input reg_write ,
input[4:0] read_reg_num1,
input [4:0] read_reg_num2,
input [4:0] write_reg_num ,
input [31:0] write_data,//the single data value to write 
output [31:0] read_data1 ,
output [31:0] read_data2 
    );
     reg [31:0] reg_mem[31:0] ;
    
    integer i ;
    
    
    assign read_data1= (read_reg_num1==0 )? 32'd0 : reg_mem[read_reg_num1] ;
    assign read_data2= (read_reg_num2==0 )? 32'd0 : reg_mem[read_reg_num2] ;
        
        always @(posedge clk ) begin 
        if(rst ) begin 
        for(i= 0 ; i<32; i=i+1) 
        reg_mem[i]<= 0 ;
        end 
        
        else if (reg_write && write_reg_num != 0) begin 
        reg_mem[write_reg_num] <= write_data ;
        end 
        
        end

endmodule
