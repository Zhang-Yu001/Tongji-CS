`timescale 1ns / 1ps

module dmem(
    input           clock,
    input           enable,
    input           write_enable,
    input   [31:0]  address,
    input   [1:0]   data_type,
    input   [31:0]  input_data,
    output  [31:0]  output_data
);

    reg [31:0] memory[0:2047];

    always @(negedge clock)
    begin
        if(enable && write_enable)
            if(data_type == 2'b10)
                memory[address][7:0]  <= input_data[7:0];
            else if(data_type == 2'b01)
                memory[address][15:0] <= input_data[15:0];
            else if(data_type == 2'b00)
                memory[address]       <= input_data;
            else
                memory[address]       <= 32'bz;
    end

    assign output_data = enable ? memory[address] : 32'bz;

endmodule
