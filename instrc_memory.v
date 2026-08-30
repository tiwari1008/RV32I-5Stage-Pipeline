`timescale 1ns / 1ps

module instrc_memory (
    input    [31:0] pc,
    output    [31:0] instruction_out
);

     reg [31:0] memory [0:255];

    initial begin
        $readmemb("program.hex", memory);
    end

    assign instruction_out = memory[pc[9:2]];

endmodule
