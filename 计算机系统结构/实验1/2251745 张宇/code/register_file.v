`timescale 1ns / 1ps

module register_block(
    input               clock,
    input               reset,

    input               rs_read_enable,
    input               rt_read_enable,
    input               rd_write_enable,
    input   [4:0]       rd_address,
    input   [4:0]       rs_address,
    input   [4:0]       rt_address,
    input   [31:0]      rd_data,

    input   [31:0]      initial_floors,
    input   [31:0]      initial_resistance,

    output reg [31:0]   rs_data_out,
    output reg [31:0]   rt_data_out,

    output  [31:0]      attempt_count,
    output  [31:0]      broken_count,
    output              is_last_broken
);
    reg [31:0] array_reg[31:0];
    
    assign attempt_count     = array_reg[4];
    assign broken_count      = array_reg[5];
    assign is_last_broken    = array_reg[6][0];



    always @(posedge clock or posedge reset)
    begin
        if (reset)
            begin
                array_reg[0]  <= 32'b0;
                array_reg[1]  <= 32'b0;
                array_reg[2]  <= initial_floors;
                array_reg[3]  <= initial_resistance;
                array_reg[4]  <= 32'b0;
                array_reg[5]  <= 32'b0;
                array_reg[6]  <= 32'b0;
                array_reg[7]  <= 32'b0;
                array_reg[8]  <= 32'b0;
                array_reg[9]  <= 32'b0;
                array_reg[10] <= 32'b0;
                array_reg[11] <= 32'b0;
                array_reg[12] <= 32'b0;
                array_reg[13] <= 32'b0;
                array_reg[14] <= 32'b0;
                array_reg[15] <= 32'b0;
                array_reg[16] <= 32'b0;
                array_reg[17] <= 32'b0;
                array_reg[18] <= 32'b0;
                array_reg[19] <= 32'b0;
                array_reg[20] <= 32'b0;
                array_reg[21] <= 32'b0;
                array_reg[22] <= 32'b0;
                array_reg[23] <= 32'b0;
                array_reg[24] <= 32'b0;
                array_reg[25] <= 32'b0;
                array_reg[26] <= 32'b0;
                array_reg[27] <= 32'b0;
                array_reg[28] <= 32'b0;
                array_reg[29] <= 32'b0;
                array_reg[30] <= 32'b0;
                array_reg[31] <= 32'b0;
            end
        else if(rd_write_enable && rd_address != 0)
        begin
            array_reg[rd_address] <= rd_data;
        end
    end

    always @(negedge clock)
    begin
        if(reset) 
        begin
            rs_data_out <= 0;
            rt_data_out <= 0;
        end
        else 
        begin
            if(rs_read_enable)
            begin
                rs_data_out <= ((rd_write_enable && (rd_address == rs_address)) ? rd_data : array_reg[rs_address]);
            end
            else
            begin
                rs_data_out <= 32'b0;
            end

            if(rt_read_enable)
            begin
                rt_data_out <= ((rd_write_enable && (rd_address == rt_address)) ? rd_data : array_reg[rt_address]);
            end
            else
            begin
                rt_data_out <= 32'b0;
            end
        end
    end

endmodule
