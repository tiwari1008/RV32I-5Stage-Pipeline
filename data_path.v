`timescale 1ns / 1ps

  module data_path(
  input clk ,
  input rst , 
  input[5:0] alu_control ,
  input mem_to_reg ,
  input mem_write,
  input alu_src,
  input reg_write ,
  input lui_operation,
  input jump ,
  input beq_control,
  input bneq_control,
  input bgeq_control,
  input blt_control ,
   output [31:0] instruction_out
     );
     //internal wires 
     
     wire[31:0] pc_current ;
     wire[31:0] pc_next ; 
     wire[31:0] pc_plus_4;
     wire[31:0] imm_val;
     wire[31:0] read_data1;
     wire[31:0] read_data2;
     wire[31:0] alu_src_b;
     wire[31:0] alu_result ;
     wire[31:0] mem_read_data;
     wire[31:0] write_back_data;
     
     //////IFID__///////////
wire[31:0] instruction_wire;
  wire [31:0] if_id_pc;
wire [31:0] if_id_instruction;


/////IDEX////////////////////
wire [31:0] id_ex_pc;
wire [31:0] id_ex_read_data1;
wire [31:0] id_ex_read_data2;
wire [31:0] id_ex_imm_val;
wire [4:0]  id_ex_write_reg_num;
wire [5:0]  id_ex_alu_control;
wire        id_ex_alu_src;
wire        id_ex_lui_operation;
wire        id_ex_jump;
wire        id_ex_beq_control;
wire        id_ex_bneq_control;
wire        id_ex_bgeq_control;
wire        id_ex_blt_control;
wire        id_ex_mem_write;
wire        id_ex_mem_to_reg;
wire        id_ex_reg_write;

/////////EXMEM///////////////////
  wire [31:0] ex_mem_alu_result;
  wire [31:0] ex_mem_branch_target;
  wire ex_mem_take_branch;
  wire [31:0] ex_mem_read_data_2;
  wire [31:0] ex_mem_pc_plus_4;
  wire [31:0] ex_mem_imm_val;
  wire [4:0] ex_mem_write_reg_num;
  wire ex_mem_mem_write;
  wire ex_mem_mem_to_reg;
  wire ex_mem_reg_write;
  wire ex_mem_jump;
  wire ex_mem_lui_operation;
  
  
  
  /////////MEMWB///////////////////
 wire [31:0] mem_wb_alu_result;
 wire [31:0] mem_wb_mem_read_data;
 wire [31:0] mem_wb_pc_plus_4;
 wire [31:0] mem_wb_imm_val;
 wire [4:0]  mem_wb_write_reg_num; // Our final destination 'rd' !
 
 wire        mem_wb_reg_write;
 wire        mem_wb_mem_to_reg;
 wire        mem_wb_jump;
 wire        mem_wb_lui_operation;
  
  
  /////////forwarding_unit //////////////////
  wire [31:0] forward_alu_src_a;
  wire [31:0] forward_alu_src_b ;
wire [1:0] forward_a;
wire [1:0] forward_b;
wire [4:0] id_ex_rs1_num;
wire [4:0] id_ex_rs2_num;

 assign forward_alu_src_a = (forward_a==2'b10)?ex_mem_alu_result:
  (forward_a==2'b01)?write_back_data:id_ex_read_data1;
  
  
assign forward_alu_src_b = (forward_b==2'b10)?ex_mem_alu_result:
  (forward_b==2'b01)?write_back_data:id_ex_read_data2;  
  
  
 
 forward_unit FUT(
.id_ex_rs1(id_ex_rs1_num),
.id_ex_rs2(id_ex_rs2_num),
 .ex_mem_rd(ex_mem_write_reg_num),
 .ex_mem_reg_write(ex_mem_reg_write),
 .mem_wb_reg(mem_wb_write_reg_num),
  
   
.mem_wb_reg_write(mem_wb_reg_write),
.forward_a(forward_a),
.forward_b(forward_b)
);

//////////stallll////////

wire pc_write_en ;
wire if_id_write_en ;
wire control_mux_en ; 

stall STL(
.if_id_rs1_num(if_id_instruction[19:15]),
.if_id_rs2_num(if_id_instruction[24:20]),
.id_ex_mem_to_reg(id_ex_mem_to_reg),
.id_ex_write_reg_num(id_ex_write_reg_num ),
.pc_write(pc_write_en),
.if_id_write(if_id_write_en),
.control_mux(control_mux_en)
);
     
wire [5:0] bubble_alu_control = (control_mux_en) ? alu_control : 6'b000000;
wire bubble_alu_src = (control_mux_en) ? alu_src : 1'b0;
wire bubble_lui_operation = (control_mux_en) ? lui_operation : 1'b0;
wire bubble_jump = (control_mux_en) ? jump : 1'b0;
wire bubble_beq_control = (control_mux_en) ? beq_control : 1'b0;
wire bubble_bneq_control = (control_mux_en) ? bneq_control : 1'b0;
wire bubble_bgeq_control = (control_mux_en) ? bgeq_control : 1'b0;
wire bubble_blt_control = (control_mux_en) ? blt_control : 1'b0;
wire bubble_mem_write = (control_mux_en) ? mem_write : 1'b0;
wire bubble_mem_to_reg = (control_mux_en) ? mem_to_reg : 1'b0;
wire bubble_reg_write = (control_mux_en) ? reg_write : 1'b0;     

 


assign instruction_out = if_id_instruction ;

assign pc_plus_4= pc_current+4;

instrc_fetch_unit PC_unit(
.clk(clk) ,
.rst(rst) ,
.next_pc(pc_next) ,
.pc(pc_current) ,
.pc_write_en(pc_write_en)
);

  instrc_memory IM(
  .pc(pc_current) ,
  .instruction_out(instruction_wire) 
  ) ; 
  
  register_file RF(
  .clk(clk) ,
  .rst(rst) ,
  .reg_write(mem_wb_reg_write) ,
  .read_reg_num1(if_id_instruction[19:15]),
    .read_reg_num2(if_id_instruction[24:20]),
    .write_reg_num(mem_wb_write_reg_num) ,
    .write_data(write_back_data) ,
    .read_data1(read_data1) ,
        .read_data2(read_data2) 
        );

    imm_gen IMGEN(
    .instruction(if_id_instruction) ,
    .imm_val(imm_val) 
    );
    
    
    assign alu_src_b = (id_ex_alu_src)?id_ex_imm_val: forward_alu_src_b;
    
    alu ALU_UNIT (
     .src1(forward_alu_src_a) ,
    .src2(alu_src_b) ,
    .alu_control(id_ex_alu_control),
     .result(alu_result),
    .zero(zero_flag) 
        ) ;
        
    
    data_memory DM(
    .clk(clk) ,
    .rst(rst) ,
    .addr(ex_mem_alu_result) ,
    .write_data(ex_mem_read_data_2),
    .memory_write(ex_mem_mem_write),
    .mem_read(ex_mem_mem_to_reg) ,
    .read_data(mem_read_data)
    );
    
    //////////write _back_mux 
    
    
     
    wire take_branch = (id_ex_beq_control && alu_result[0]) ||

(id_ex_bneq_control && alu_result[0]) ||

(id_ex_bgeq_control && alu_result[0]) ||

(id_ex_blt_control && alu_result[0]);

assign pc_next = (take_branch || id_ex_jump) ? (id_ex_pc + id_ex_imm_val) : pc_plus_4;




////////////////////////////////control hazard ///////////////////////////
wire pipeline_flush = take_branch || id_ex_jump;


if_id_regs IFID(
.clk(clk),
.rst(rst),
.pc_in(pc_current),
.instruction_in(instruction_wire),
.pc_out(if_id_pc),
.instruction_out(if_id_instruction),
.if_id_write_en(if_id_write_en),
.flush(pipeline_flush)
);



id_ex_regs IDEX(
.clk(clk) ,
.rst(rst),
.pc_in(if_id_pc),
.read_data1_in(read_data1),
.read_data2_in(read_data2),
.imm_val_in(imm_val),
.write_reg_num_in(if_id_instruction[11:7]), 
.alu_control_in(bubble_alu_control),
.alu_src_in(bubble_alu_src),
.lui_operation_in(bubble_lui_operation),
.jump_in(bubble_jump),
.beq_control_in(bubble_beq_control),
.bneq_control_in(bubble_bneq_control),
.bgeq_control_in(bubble_bgeq_control),
.blt_control_in(bubble_blt_control),
.mem_write_in(bubble_mem_write),
.mem_to_reg_in(bubble_mem_to_reg),
.reg_write_in(bubble_reg_write),
.rs1_num_in(if_id_instruction[19:15]),  // CORRECT: Pass the instruction slice
    .rs2_num_in(if_id_instruction[24:20]),
    
//____________________________________outputs__________________________________________________________________________________
 
    .pc_out(id_ex_pc),
    .read_data1_out(id_ex_read_data1),
    .read_data2_out(id_ex_read_data2),
    .imm_val_out(id_ex_imm_val),
    .write_reg_num_out(id_ex_write_reg_num),
    
    .alu_control_out(id_ex_alu_control),
    .alu_src_out(id_ex_alu_src),
    .lui_operation_out(id_ex_lui_operation),
    .jump_out(id_ex_jump),
    .beq_control_out(id_ex_beq_control),
    .bneq_control_out(id_ex_bneq_control),
    .bgeq_control_out(id_ex_bgeq_control),
    .blt_control_out(id_ex_blt_control),
    .mem_write_out(id_ex_mem_write),
    .mem_to_reg_out(id_ex_mem_to_reg),
    .reg_write_out(id_ex_reg_write),
    .rs1_num_out(id_ex_rs1_num),
    .rs2_num_out(id_ex_rs2_num),
    .flush(pipeline_flush)
 );


  
 wire [31:0] calculated_branch_target = id_ex_pc + id_ex_imm_val;
  
ex_mem_regs EXMEM (
.clk(clk) ,
.rst(rst),
.alu_result_in(alu_result),
.branch_target_in(calculated_branch_target),
.take_branch_in(take_branch),
.read_data_2_in(id_ex_read_data2),
.pc_plus_4_in(id_ex_pc + 4),
.imm_val_in(id_ex_imm_val),
.write_reg_num_in(id_ex_write_reg_num),
.mem_write_in(id_ex_mem_write),
.mem_to_reg_in(id_ex_mem_to_reg),
.reg_write_in(id_ex_reg_write),
.jump_in(id_ex_jump),
.lui_operation_in(id_ex_lui_operation),



///_____________________________________________________oUTPUTS______________________________________________________


  
     .alu_result_out(ex_mem_alu_result),
     .branch_target_out(ex_mem_branch_target),
     .take_branch_out(ex_mem_take_branch),
     .read_data_2_out(ex_mem_read_data_2),
     .pc_plus_4_out(ex_mem_pc_plus_4),
     .imm_val_out(ex_mem_imm_val),
     .write_reg_num_out(ex_mem_write_reg_num),
     .mem_write_out(ex_mem_mem_write),
     .mem_to_reg_out(ex_mem_mem_to_reg),
     .reg_write_out(ex_mem_reg_write),
     .jump_out(ex_mem_jump),
     .lui_operation_out(ex_mem_lui_operation)
     );
     
     
     
     
     mem_wb_regs MEMWB(
     .clk(clk),
     .rst(rst),
     .alu_result_in(ex_mem_alu_result),
     .mem_read_data_in(mem_read_data ),
     .imm_val_in(ex_mem_imm_val),
     .pc_plus_4_in(ex_mem_pc_plus_4),
     .write_reg_num_in (ex_mem_write_reg_num),
     .reg_write_in(ex_mem_reg_write),
     .mem_to_reg_in (ex_mem_mem_to_reg),
     .jump_in(ex_mem_jump),
.lui_operation_in(ex_mem_lui_operation),     


     // --- OUTPUTS (To WB Stage) ---
     
     
    .alu_result_out(mem_wb_alu_result),
    .mem_read_data_out(mem_wb_mem_read_data),
    .pc_plus_4_out(mem_wb_pc_plus_4),
    .imm_val_out(mem_wb_imm_val),
    .write_reg_num_out(mem_wb_write_reg_num),
    
    .reg_write_out(mem_wb_reg_write),
    .mem_to_reg_out(mem_wb_mem_to_reg),
    .jump_out(mem_wb_jump),
    .lui_operation_out(mem_wb_lui_operation)
     );
     
         assign write_back_data= (mem_wb_mem_to_reg)?mem_wb_mem_read_data: (mem_wb_jump)?mem_wb_pc_plus_4:(mem_wb_lui_operation)?mem_wb_imm_val:mem_wb_alu_result;


  

 
     
     
endmodule
