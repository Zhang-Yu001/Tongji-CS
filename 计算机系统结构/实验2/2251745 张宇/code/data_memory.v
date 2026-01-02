`timescale 1ns / 1ps

module data_memory (
    input               clock,
    input               enable,
    input               write_enable,
    input [1:0]         write_select,
    input [1:0]         read_select, 
    input [31:0]        input_data,
    input [31:0]        address,
    output reg [31:0]   output_data
);

    reg [31:0] memory_array [2047:0];
	
    wire [9:0] high_address = (address - 32'h10010000) >> 2;
    wire [1:0] low_address = (address - 32'h10010000) & 2'b11;

    always @(*) 
    begin
        if (enable && ~write_enable) 
        begin
            case (read_select)
                2'b01: output_data <= memory_array[high_address];
                2'b10:
                begin
                    case (low_address)
                        2'b00: output_data <= memory_array[high_address][15:0];
                        2'b10: output_data <= memory_array[high_address][31:16];
                    endcase
                end
                2'b11:
                begin
                    case (low_address)
                        2'b00: output_data <= memory_array[high_address][7:0];
                        2'b01: output_data <= memory_array[high_address][15:8];
                        2'b10: output_data <= memory_array[high_address][23:16];
                        2'b11: output_data <= memory_array[high_address][31:24];
                    endcase
                end
            endcase
        end
    end

    always @(posedge clock) 
    begin
        if (enable) 
        begin
            if (write_enable)
            begin
                case (write_select)
                    2'b01: memory_array[high_address] <= input_data; 
                    2'b10:
                    begin
                        case (low_address)
                            2'b00: memory_array[high_address][15:0] <= input_data[15:0];
                            2'b11: memory_array[high_address][31:16] <= input_data[15:0];
                        endcase
                    end
                    2'b11:
                    begin
                        case (low_address)
                            2'b00: memory_array[high_address][7:0] <= input_data[7:0];
                            2'b01: memory_array[high_address][15:8] <= input_data[7:0];
                            2'b10: memory_array[high_address][23:16] <= input_data[7:0];
                            2'b11: memory_array[high_address][31:24] <= input_data[7:0];
                        endcase
                    end
                endcase
            end
        end
    end
endmodule

module data_cutter (
    input [31:0]        data_input,
    input [2:0]         select,
    input               sign_extend,
    output reg [31:0]   data_output
);
    
    always @(*) 
    begin
        case (select)
            3'b010: data_output <= { {24{ sign_extend & data_input[7] }}, data_input[7:0] };
            3'b011: data_output <= { 24'b0, data_input[7:0] };
            3'b001: data_output <= { {16{ sign_extend & data_input[15] }}, data_input[15:0] };
            3'b100: data_output <= { 16'b0, data_input[15:0] };
            default: data_output <= data_input;
        endcase
    end
endmodule
