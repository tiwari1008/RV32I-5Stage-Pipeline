 #🚀 32-bit Pipelined RISC-V Processor (RV32I)
📌 Overview

This project implements a 32-bit RISC-V (RV32I) pipelined processor in Verilog, designed by upgrading a single-cycle architecture to a 5-stage pipeline. The processor improves performance by executing multiple instructions in parallel while handling pipeline hazards efficiently.

🧠 Pipeline Architecture

The processor is divided into the following 5 stages:

IF (Instruction Fetch)
ID (Instruction Decode)
EX (Execute)
MEM (Memory Access)
WB (Write Back)

Pipeline registers used:

IF/ID
ID/EX
EX/MEM
MEM/WB
⚡ Hazard Handling
Data Hazards
Resolved using forwarding unit
Pipeline stalling for load-use hazards
Control Hazards
Handled using pipeline flushing
🧩 Key Modules
alu_unit.v → Arithmetic Logic Unit
control_unit.v → Control Unit
register_file.v → Register File
instrc_memory.v → Instruction Memory
data_memory.v → Data Memory
imm_gen.v → Immediate Generator
data_path.v → Datapath
Pipeline Registers:
if_id_reg.v
id_ex_regs.v
ex_mem_reg.v
mem_wb_regs.v
Hazard Handling:
forward_unit.v → Data Forwarding
stall.v → Stall Control
Top Module:
riscv_pipelind_top.v
🔄 Design Flow
Converted single-cycle processor to pipelined architecture
Added pipeline registers between stages
Implemented hazard detection and resolution
Verified through simulation
🎯 Features
32-bit RV32I architecture
5-stage pipeline design
Forwarding and stalling support
Modular Verilog implementation
🧪 Simulation

Simulation performed to verify correct pipeline execution and hazard handling.

📈 Future Work
Branch prediction
Cache integration
FPGA implementation
👨‍💻 Author

Kartikey Tiwari
