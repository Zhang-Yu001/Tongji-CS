`timescale 1ns / 1ps

module register_file (
    input               clock, 
    input               reset, 
    input               write_enable, 
    input   [4:0]       rs_address, 
    input   [4:0]       rt_address, 
    input               rs_enable,
    input               rt_enable,
    input   [4:0]       rd_address, 
    input   [31:0]      rd_data, 
    output reg [31:0]   rs_data_out, 
    output reg [31:0]   rt_data_out,
    output [31:0]       reg28_output
);
    
    reg [31:0] registers [31:0];
    integer idx;

    always @(posedge clock or posedge reset) 
    begin
        if (reset) 
        begin
            for (idx = 0; idx < 32; idx = idx + 1)
                registers[idx] <= 32'b0;
        end 
        else 
        begin
            if (write_enable && (rd_address != 5'b0))
                registers[rd_address] = rd_data;
        end
    end

    always @(*) 
    begin
        if (reset) 
            rs_data_out <= 32'b0;
        else if (rs_address == 5'b0) 
            rs_data_out <= 32'b0;
        else if ((rs_address == rd_address) && write_enable && rs_enable) 
            rs_data_out <= rd_data;
        else if (rs_enable) 
            rs_data_out <= registers[rs_address];
        else 
            rs_data_out <= 32'bz;
    end

    always @(*) 
    begin
        if (reset) 
            rt_data_out <= 32'b0;
        else if (rt_address == 5'b0) 
            rt_data_out <= 32'b0;
        else if ((rt_address == rd_address) && write_enable && rt_enable) 
            rt_data_out <= rd_data;
        else if (rt_enable) 
            rt_data_out <= registers[rt_address];
        else 
            rt_data_out <= 32'bz;
    end

    assign reg28_output = registers[28];

endmodule
