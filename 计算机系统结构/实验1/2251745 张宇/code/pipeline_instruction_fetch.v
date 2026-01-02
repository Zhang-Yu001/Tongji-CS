`timescale 1ns / 1ps

module pipeline_if_stage(
    input           clock,
    input           reset,
    input           pause,
    input   [31:0]  jump_address,
    input   [31:0]  branch_address,
    input   [1:0]   pc_select,
    output  [31:0]  current_pc,
    output  [31:0]  next_pc,
    output  [31:0]  instruction_out
    );

    wire [31:0] pc_next;

    pc_register pc_register_inst(
        .clock(clock),
        .enable(1'b1),
        .reset(reset),
        .pause(pause),
        .pc_input(pc_next),
        .pc_output(current_pc)
    );
       
    mux4to1_32bit pc_mux_inst(
        .data0(next_pc),
        .data1(branch_address),
        .data2(jump_address),
        .data3(32'bz),
        .out_data(pc_next),
        .select(pc_select)
    );
    
    assign next_pc = current_pc + 4;

    instruction_memory instruction_memory_inst(current_pc >> 2, instruction_out);
    
endmodule
