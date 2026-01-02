`timescale 1ns / 1ps

module system_controller_top(
    input           clock,
    input           reset,
    input           enable,
    input  [1:0]    mode_switch,
    output [7:0]    segment_output,
    output [7:0]    segment_select
    );

    wire [31:0] display_value;
    wire [31:0] program_counter, instruction;
    wire [31:0] register28;

    wire        cpu_clock;
    reg [20:0]  clock_divider;

    always@(posedge clock)
        clock_divider = clock_divider + 1;
    
    // assign cpu_clock = clock_divider[19];  // For hardware clock division
    assign cpu_clock = clock;                // For simulation

    mux4_32 display_mux(register28, program_counter, instruction, 32'b0, mode_switch, display_value);

    segment_driver seg_driver_instance(clock, reset, 1'b1, display_value, segment_output, segment_select);

    processor_core cpu_instance(cpu_clock, reset, enable, program_counter, instruction, register28);

endmodule
