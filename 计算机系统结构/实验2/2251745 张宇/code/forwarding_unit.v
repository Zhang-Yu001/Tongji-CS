`include "mips_def.vh"
`timescale 1ns / 1ps

module data_forwarding_unit (
    input               clock,
    input               reset,
    input [5:0]         opcode,
    input [5:0]         function_code,
    input               rs_read_enable,
    input               rt_read_enable,
    input [4:0]         rs_code,
    input [4:0]         rt_code,

    input [5:0]         exe_opcode,
    input [5:0]         exe_function_code,
    input [31:0]        exe_hi_data,
    input [31:0]        exe_lo_data,
    input [31:0]        exe_rd_data,
    input               exe_hi_write_enable,
    input               exe_lo_write_enable,
    input               exe_rd_write_enable,
    input [4:0]         exe_rd_code,

    input [31:0]        mem_hi_data,
    input [31:0]        mem_lo_data,
    input [31:0]        mem_rd_data,
    input               mem_hi_write_enable,
    input               mem_lo_write_enable,
    input               mem_rd_write_enable,
    input [4:0]         mem_rd_code,

    output reg          stall_signal,
    output reg          forwarding_enabled,
    output reg          forwarding_rs,
    output reg          forwarding_rt,
    output reg [31:0]   rs_data_out,
    output reg [31:0]   rt_data_out,
    output reg [31:0]   hi_data_out,
    output reg [31:0]   lo_data_out
);

    always @(negedge clock or posedge reset) 
    begin
        if (reset) 
        begin
            stall_signal       <= 1'b0;
            rs_data_out        <= 32'b0;
            rt_data_out        <= 32'b0;
            hi_data_out        <= 32'b0;
            lo_data_out        <= 32'b0;
            forwarding_enabled <= 1'b0;
            forwarding_rs      <= 1'b0;
            forwarding_rt      <= 1'b0;
        end 
        else if (stall_signal) 
        begin
            stall_signal <= 1'b0;
            if (forwarding_rs) 
                rs_data_out <= mem_rd_data;
            else if (forwarding_rt)
                rt_data_out <= mem_rd_data;
        end 
        else 
        begin
            forwarding_enabled = 0;
            forwarding_rs = 0;
            forwarding_rt = 0;

            // Forward HI data
            if (opcode == `OP_MFHI && function_code == `FUNC_MFHI) 
            begin
                if (exe_hi_write_enable) 
                begin
                    hi_data_out      <= exe_hi_data;
                    forwarding_enabled <= 1'b1;
                end 
                else if (mem_hi_write_enable) 
                begin
                    hi_data_out      <= mem_hi_data;
                    forwarding_enabled <= 1'b1;
                end
            end 

            // Forward LO data
            else if (opcode == `OP_MFLO && function_code == `FUNC_MFLO) 
            begin
                if (exe_lo_write_enable) 
                begin
                    lo_data_out      <= exe_lo_data;
                    forwarding_enabled <= 1'b1;
                end 
                else if (mem_lo_write_enable) 
                begin
                    lo_data_out      <= mem_lo_data;
                    forwarding_enabled <= 1'b1;
                end
            end 

            // Forward RS data
            else 
            begin
                if (exe_rd_write_enable && rs_read_enable && exe_rd_code == rs_code) 
                begin
                    if (exe_opcode == `OP_LW || exe_opcode == `OP_LH || exe_opcode == `OP_LHU || exe_opcode == `OP_LB || exe_opcode == `OP_LBU) 
                    begin
                        forwarding_rs  <= 1'b1;
                        stall_signal   <= 1'b1;
                        forwarding_enabled <= 1'b1;
                    end 
                    else 
                    begin
                        forwarding_rs  <= 1'b1;
                        rs_data_out    <= exe_rd_data;
                        forwarding_enabled <= 1'b1;
                    end
                end 
                else if (mem_rd_write_enable && rs_read_enable && mem_rd_code == rs_code) 
                begin
                    forwarding_rs  <= 1'b1;
                    rs_data_out    <= mem_rd_data;
                    forwarding_enabled <= 1'b1;
                end

                // Forward RT data
                if (exe_rd_write_enable && rt_read_enable && exe_rd_code == rt_code) 
                begin
                    if (exe_opcode == `OP_LW || exe_opcode == `OP_LH || exe_opcode == `OP_LHU || exe_opcode == `OP_LB || exe_opcode == `OP_LBU) 
                    begin
                        forwarding_rt  <= 1'b1;
                        stall_signal   <= 1'b1;
                        forwarding_enabled <= 1'b1;
                    end 
                    else 
                    begin
                        forwarding_rt  <= 1'b1;
                        rt_data_out    <= exe_rd_data;
                        forwarding_enabled <= 1'b1;
                    end
                end 
                else if (mem_rd_write_enable && rt_read_enable && mem_rd_code == rt_code) 
                begin
                    forwarding_rt  <= 1'b1;
                    rt_data_out    <= mem_rd_data;
                    forwarding_enabled <= 1'b1;
                end
            end
        end
    end      

endmodule
