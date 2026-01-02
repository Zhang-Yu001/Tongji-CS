`timescale 1ns / 1ps

module pc_register(
    input               clock,
    input               enable,
    input               reset,
    input               pause,
    input      [31:0]   pc_input,
    output reg [31:0]   pc_output
    );
    
    always@(posedge clock or posedge reset)
    begin
        if(reset)
        begin
            pc_output <= 32'h00400000;
        end
        else if(enable)
        begin
            if(pause)
            begin
                pc_output <= pc_output;
            end
            else
            begin
                pc_output <= pc_input;
            end
        end
        else
        begin
            pc_output <= 32'bz;
        end
    end
    
endmodule
