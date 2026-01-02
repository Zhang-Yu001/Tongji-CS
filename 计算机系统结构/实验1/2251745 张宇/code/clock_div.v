`timescale 1ns / 1ps

module clock_div(
    input      clk_in,
    output reg clk_out = 0
);

    parameter DIVISOR = 20;
    integer   counter = 0;
    always @(posedge clk_in)
    begin
        counter = (counter + 1) % (DIVISOR / 2);
        if(counter == 0)
            clk_out <= ~clk_out;
    end

endmodule
