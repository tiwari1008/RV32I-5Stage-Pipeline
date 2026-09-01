`timescale 1ns / 1ps

module tb_riscv_top;

    // 1. Testbench Signals
    reg clk;
    reg rst;

    // 2. Instantiate the Unit Under Test (UUT)
    riscv_top uut (
        .clk(clk),
        .rst(rst)
    );

    // 3. Clock Generation (100MHz -> 10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    // 4. Generate Machine Code (program.hex) dynamically
    // This tests: addi x1, x0, 5 -> addi x2, x0, 10 -> add x3, x1, x2 -> sw x3, 0(x0)
          integer fd ;

  
    initial begin
         fd = $fopen("program.hex", "w");
        
    $fdisplay(fd, "00000000000100000000000010010011"); // PC 00: addi x1, x0, 1
        $fdisplay(fd, "00000000000000001000000100110011"); // PC 04: add x2, x1, x0   [HAZARD 1: EX/MEM Fwd]
        $fdisplay(fd, "00000000001000001000000110110011"); // PC 08: add x3, x1, x2   [HAZARD 2: MEM/WB Fwd]
        $fdisplay(fd, "00000000000000000010001000000011"); // PC 12: lw x4, 0(x0)     
        $fdisplay(fd, "00000000000000100000001010110011"); // PC 16: add x5, x4, x0   [HAZARD 3: Load-Use Stall]
        $fdisplay(fd, "00000000000000000000010001100011"); // PC 20: beq x0, x0, 8    [HAZARD 4: Branch Flush]
        $fdisplay(fd, "00000110001100000000001100010011"); // PC 24: addi x6, x0, 99  (Flushed by Branch)
        $fdisplay(fd, "00000000100000000000001111101111"); // PC 28: jal x7, 8        [HAZARD 5: Jump Flush]
        $fdisplay(fd, "00000110001100000000010000010011"); // PC 32: addi x8, x0, 99  (Flushed by Jump)
        $fdisplay(fd, "00000000000000000000010010110011"); // PC 36: add x9, x0, x0   (Safe landing)
        
//     $fdisplay(fd, "00000000010100000000000100010011"); // PC 00: addi x2, x0, 5
//$fdisplay(fd, "00000000001100000000000110010011"); // PC 04: addi x3, x0, 3
//$fdisplay(fd, "00000000001100010000001000110011"); // PC 08: add x4, x2, x3
        $fclose(fd);
    end

    // 5. VCD Waveform Generation for Debugging
    initial begin
        $dumpfile("riscv_pipeline.vcd");
        $dumpvars(0, tb_riscv_top); // Dumps all variables in the testbench and UUT
    end

    // 6. Stimulus and Verification Process
    initial begin
        // Apply Reset
        rst = 1;
        #20;      // Hold reset for a few cycles
        rst = 0;  // Release reset

        // Wait for the pipeline to process all instructions.
        // 5 stages + a few instructions = ~100ns is plenty for this short program.
        #250;

        // ---------------------------------------------------------
        // SELF-CHECKING & PROBING
        // We peek directly inside the processor's Data Path (DP) 
        // to check Register File (RF) and Data Memory (DM)
        // ---------------------------------------------------------
        $display("\n========================================");
        $display("          SIMULATION RESULTS            ");
        $display("========================================");
        
        $display("--- Register File ---");
        $display("x1 (Expected: 5)  = %0d", uut.DP.RF.reg_mem[1]);
        $display("x2 (Expected: 10) = %0d", uut.DP.RF.reg_mem[2]);
        $display("x3 (Expected: 15) = %0d", uut.DP.RF.reg_mem[3]);
        
        $display("\n--- Data Memory ---");
        $display("Mem[0] (Expected: 15) = %0d", uut.DP.DM.memory[0]);
        $display("========================================\n");

        // End simulation
        $finish;
    end

    // 7. Cycle-by-Cycle Pipeline Monitor
    integer cycle = 0;
    always @(posedge clk) begin
        if (!rst) begin
            cycle = cycle + 1;
            // Print the current time, cycle number, Program Counter, and fetched instruction
            $display("Time: %4t | Cycle: %3d | PC: %h | Fetched Inst: %b", 
                      $time, cycle, uut.DP.pc_current, uut.DP.instruction_out);
        end
    end

endmodule