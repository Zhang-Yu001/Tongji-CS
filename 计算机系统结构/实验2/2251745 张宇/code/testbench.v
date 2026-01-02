`timescale 1ns / 1ps

module system_testbench();
    reg           clock_signal, reset_signal, enable_signal;
    wire [7:0]    segment_output, select_output;

    initial 
    begin
        clock_signal = 1'b0;
        reset_signal = 1'b1;
        enable_signal = 1'b1;
        #1 
        reset_signal = 1'b0;
    end

    always 
    begin
        #1 
        clock_signal = ~clock_signal;
    end

    wire [31:0] program_counter = system_testbench.system_top_instance.processor_core_instance.program_counter;
    wire [31:0] instruction = system_testbench.system_top_instance.processor_core_instance.instruction;
    wire [31:0] reg0 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[0];
    wire [31:0] reg1 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[1];
    wire [31:0] reg2 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[2];
    wire [31:0] reg3 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[3];
    wire [31:0] reg4 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[4];
    wire [31:0] reg5 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[5];
    wire [31:0] reg6 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[6];
    wire [31:0] reg7 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[7];
    wire [31:0] reg8 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[8];
    wire [31:0] reg9 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[9];
    wire [31:0] reg10 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[10];
    wire [31:0] reg11 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[11];
    wire [31:0] reg12 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[12];
    wire [31:0] reg13 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[13];
    wire [31:0] reg14 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[14];
    wire [31:0] reg15 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[15];
    wire [31:0] reg16 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[16];
    wire [31:0] reg17 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[17];
    wire [31:0] reg18 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[18];
    wire [31:0] reg19 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[19];
    wire [31:0] reg20 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[20];
    wire [31:0] reg21 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[21];
    wire [31:0] reg22 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[22];
    wire [31:0] reg23 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[23];
    wire [31:0] reg24 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[24];
    wire [31:0] reg25 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[25];
    wire [31:0] reg26 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[26];
    wire [31:0] reg27 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[27];
    wire [31:0] reg28 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[28];
    wire [31:0] reg29 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[29];
    wire [31:0] reg30 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[30];
    wire [31:0] reg31 = system_testbench.system_top_instance.processor_core_instance.register_file_instance.registers[31];

    system_top system_top_instance(
        .clk(clock_signal), 
        .rst(reset_signal), 
        .ena(enable_signal), 
        .o_seg(segment_output), 
        .o_sel(select_output)
    );

endmodule
