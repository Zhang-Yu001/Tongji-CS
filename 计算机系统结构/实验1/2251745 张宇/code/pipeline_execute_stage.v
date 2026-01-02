`timescale 1ns / 1ps

module pipeline_ex_stage(
    input           reset,

    input           dmem_enable,
    input           dmem_write_enable,
    input   [1:0]   dmem_type,

    input   [31:0]  rs_data_in,
    input   [31:0]  rt_data_in,
    input   [4:0]   rd_write_address_in,
    input           rd_select_in,
    input           rd_write_enable_in,

    input   [31:0]  immediate,
    input   [31:0]  shift_amount,

    input           alu_a_select,
    input           alu_b_select,
    input   [3:0]   alu_operation,

    output          dmem_enable_out,
    output          dmem_write_enable_out,
    output  [1:0]   dmem_type_out,

    output  [31:0]  rs_data_out,
    output  [31:0]  rt_data_out,
    output  [4:0]   rd_write_address_out,
    output          rd_select_out,
    output          rd_write_enable_out,

    output  [31:0]  alu_result
    );
    
    wire [31:0] alu_a;
    wire [31:0] alu_b;
    wire zero, carry, negative, overflow;

    assign dmem_enable_out     = dmem_enable;
    assign dmem_write_enable_out = dmem_write_enable;
    assign dmem_type_out       = dmem_type;

    assign rs_data_out         = rs_data_in;
    assign rt_data_out         = rt_data_in;
    assign rd_write_address_out = rd_write_address_in;
    assign rd_select_out       = rd_select_in;
    assign rd_write_enable_out = rd_write_enable_in;

    assign alu_a = alu_a_select ? shift_amount : rs_data_in;
    assign alu_b = alu_b_select ? immediate : rt_data_in;

    alu_block alu_inst(
        .a(alu_a), 
        .b(alu_b), 
        .y(alu_result),
        .aluc(alu_operation), 
        .zero(zero),
        .carry(carry),
        .negative(negative),
        .overflow(overflow)
    );

endmodule
