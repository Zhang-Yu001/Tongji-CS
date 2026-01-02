`timescale 1ns / 1ps

module pipeline_if_id_register(
    input               clock,
    input               reset,
    input               pause,
    input               branch_signal,
    input       [31:0]  npc_in,
    input       [31:0]  instruction_in,
    output reg  [31:0]  npc_out,
    output reg  [31:0]  instruction_out
    );

    always @(posedge clock or posedge reset) 
    begin
        if(reset) 
        begin
            npc_out         <= 32'b0;
            instruction_out <= 32'b0;
        end
        else if(~pause) 
        begin
            if(branch_signal) 
            begin
                npc_out         <= 32'b0;
                instruction_out <= 32'b0;
            end
            else 
            begin
                npc_out         <= npc_in;
                instruction_out <= instruction_in;
            end
        end
        else
        begin
            npc_out         <= npc_out;
            instruction_out <= instruction_out;
        end
    end
    
endmodule
