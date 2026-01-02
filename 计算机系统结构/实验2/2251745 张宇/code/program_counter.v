`timescale 1ns / 1ps

module program_counter (
    input               clock,
    input               reset,
    input               enable,
    input               stall_signal,
    input  [31:0]       next_pc,
    output reg [31:0]   current_pc
);

    always @(posedge clock or posedge reset)
    begin
        if (reset) 
            current_pc <= 32'h00400000; // 初始PC值
        else if (~stall_signal) 
        begin
            if (enable) 
                current_pc <= next_pc;
        end
    end

endmodule
