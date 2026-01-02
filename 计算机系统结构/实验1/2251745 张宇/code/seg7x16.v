`timescale 1ns / 1ps

module seven_segment_display(
     input clock,
     input rst,
     input chip_select,
     input [31:0] input_data,
     output [7:0] segment_output,
     output [7:0] select_output
    );

    reg [14:0] counter;
    always @ (posedge clock, posedge rst)
      if (rst)
        counter <= 0;
      else
        counter <= counter + 1'b1;
 
    wire seg_clock = counter[14]; 
     
    reg [2:0] segment_address;
     
    always @ (posedge seg_clock, posedge rst)
       if(rst)
          segment_address <= 0;
        else
          segment_address <= segment_address + 1'b1;
          
    reg [7:0] select_register;
     
    always @ (*)
       case(segment_address)
          7 : select_register = 8'b01111111;
          6 : select_register = 8'b10111111;
          5 : select_register = 8'b11011111;
          4 : select_register = 8'b11101111;
          3 : select_register = 8'b11110111;
          2 : select_register = 8'b11111011;
          1 : select_register = 8'b11111101;
          0 : select_register = 8'b11111110;
        endcase
    
    reg [31:0] data_store;
    always @ (posedge clock, posedge rst)
       if(rst)
          data_store <= 0;
        else if(chip_select)
          data_store <= input_data;
          
    reg [7:0] segment_data;
    always @ (*)
       case(segment_address)
          0 : segment_data = data_store[3:0];
          1 : segment_data = data_store[7:4];
          2 : segment_data = data_store[11:8];
          3 : segment_data = data_store[15:12];
          4 : segment_data = data_store[19:16];
          5 : segment_data = data_store[23:20];
          6 : segment_data = data_store[27:24];
          7 : segment_data = data_store[31:28];
        endcase
     
    reg [7:0] segment_register;
    always @ (posedge clock, posedge rst)
       if(rst)
          segment_register <= 8'hff;
        else
          case(segment_data)
            4'h0 : segment_register <= 8'hC0;
            4'h1 : segment_register <= 8'hF9;
            4'h2 : segment_register <= 8'hA4;
            4'h3 : segment_register <= 8'hB0;
            4'h4 : segment_register <= 8'h99;
            4'h5 : segment_register <= 8'h92;
            4'h6 : segment_register <= 8'h82;
            4'h7 : segment_register <= 8'hF8;
            4'h8 : segment_register <= 8'h80;
            4'h9 : segment_register <= 8'h90;
            4'hA : segment_register <= 8'h88;
            4'hB : segment_register <= 8'h83;
            4'hC : segment_register <= 8'hC6;
            4'hD : segment_register <= 8'hA1;
            4'hE : segment_register <= 8'h86;
            4'hF : segment_register <= 8'h8E;
          endcase
          
    assign select_output = select_register;
    assign segment_output = segment_register;

endmodule
