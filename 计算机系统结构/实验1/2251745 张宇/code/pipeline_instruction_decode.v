`timescale 1ns / 1ps

module pipeline_id_stage(
    input           clock,
    input           reset,

    input   [31:0]  npc_input,
    input   [31:0]  instruction,
 
    input   [4:0]   ex_write_address,
    input   [4:0]   mem_write_address,
    input           ex_write_enable,
    input           mem_write_enable,

    input   [4:0]   wb_reg_address,
    input           wb_reg_enable,
    input   [31:0]  wb_reg_data,

    input   [31:0]  initial_floors,
    input   [31:0]  initial_resistance,

    output  [31:0]      rs_data_out,
    output  [31:0]      rt_data_out,
    output  [4:0]       rd_write_address,
    output              rd_select,
    output              rd_write_enable,
    output  [31:0]      immediate,
    output  [31:0]      shift_amount,

    output              dmem_enable,
    output              dmem_write_enable,
    output  [1:0]       dmem_type,

    output  [31:0]      branch_address,
    output  [31:0]      jump_address,
    output  [1:0]       pc_select,

    output              alu_a_select,
    output              alu_b_select,
    output [3:0]        alu_operation,

    output              stall_signal,
    output              branch_signal,

    output  [31:0]      attempt_count,
    output  [31:0]      broken_count,
    output              is_last_broken
    );

    // ����ָ��ĸ�������
    wire [5:0] inst_op   = instruction[31:26];
    wire [5:0] inst_func = instruction[5:0];
    wire [4:0] rs_addr   = instruction[25:21];
    wire [4:0] rt_addr   = instruction[20:16];
    wire [4:0] rd_addr   = instruction[15:11];

    wire rs_rena, rt_rena;
    wire ext_signed;

    assign immediate = { { 16{ ext_signed & instruction[15] } }, instruction[15:0] };
    assign shift_amount = { 27'b0, instruction[10:6] };

    assign branch_address = npc_input + { { 14{ instruction[15] }}, instruction[15:0], 2'b0 };
    assign jump_address = { npc_input[31:28], instruction[25:0], 2'b0 };

    assign branch_signal = (((inst_op == 6'b000100) && (rs_data_out == rt_data_out)) || ((inst_op == 6'b000101) && (rs_data_out != rt_data_out)) || (inst_op == 6'b000010));

    // �Ĵ�����
    register_block register_file_inst(
        .clock(clock),
        .reset(reset),

        .rs_read_enable(rs_rena),
        .rt_read_enable(rt_rena),
        .rd_write_enable(wb_reg_enable),
        .rs_address(rs_addr),
        .rt_address(rt_addr),
        .rd_address(wb_reg_address),
        .rd_data(wb_reg_data),

        .initial_floors(initial_floors),
        .initial_resistance(initial_resistance),

        .rs_data_out(rs_data_out),
        .rt_data_out(rt_data_out),

        .attempt_count(attempt_count),
        .broken_count(broken_count),
        .is_last_broken(is_last_broken)
    );

    // ������ ����ָ����������ź�
    controller controller_inst( 
        .in_branch(branch_signal),
        .in_instruction(instruction),

        .out_rs_rena(rs_rena),
        .out_rt_rena(rt_rena),
        .out_rd_wena(rd_write_enable),
        .out_rd_sel(rd_select),
        .out_rd_addr(rd_write_address),

        .out_dmem_ena(dmem_enable),
        .out_dmem_wena(dmem_write_enable),
        .out_dmem_type(dmem_type),

        .out_ext_signed(ext_signed),
        .out_alu_a_sel(alu_a_select),
        .out_alu_b_sel(alu_b_select),
        .out_alu_sel(alu_operation),
        .out_pc_sel(pc_select)
    );

    // �ж����ݳ�ͻ��������stall�ź�
    stall stall_inst(
        .in_clk(clock),
        .in_rst(reset),
        .in_rs_addr(rs_addr),
        .in_rt_addr(rt_addr),
        .in_rs_rena(rs_rena),
        .in_rt_rena(rt_rena),
        .in_ex_waddr(ex_write_address),
        .in_mem_waddr(mem_write_address),
        .in_ex_wena(ex_write_enable),
        .in_mem_wena(mem_write_enable),
        .out_stall(stall_signal)
    );

endmodule
