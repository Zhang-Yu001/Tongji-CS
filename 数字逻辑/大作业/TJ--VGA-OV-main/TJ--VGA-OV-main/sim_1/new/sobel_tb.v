`timescale 1ns/1ps
`define CLK_PERIOD 20//50MHZ

module matrix_3x3_tb ();
reg clk;
reg [9:0] din;
reg rst_n;
reg valid_in;
//wires
wire [9:0] dout;
wire [9:0] dout_r0;
wire [9:0] dout_r1;
wire [9:0] dout_r2;
wire mat_flag;

Matrix Matri_inst(
    .clk (clk),
    .datain (din),
    .dout(dout),
    .dout_0(dout_r0),
    .dout_1(dout_r1),
    .dout_2(dout_r2),
    .rst_n(rst_n),
    .valid_in(valid_in),
    .can_cout(mat_flag)
);
initial begin
    clk = 0;
    rst_n = 0;
    valid_in = 0;
    #(`CLK_PERIOD * 10);
    rst_n=1;
    #(`CLK_PERIOD*10);
    valid_in = 1;
    #(`CLK_PERIOD*480*5);
    valid_in = 0;
    #(`CLK_PERIOD*20);

end

always #(`CLK_PERIOD/2) clk = ~clk;

/*
    ����din����0-479֮�󣬷���0���ٴδ�0-479��
    ���ԣ�ģ���ÿһ�����ݶ��Ǵ�0-479������ڷ���ʱ�������ݶ���ʱ���ǵ����ݲŻ���һ���ġ�

    ��������din����ʵ��ͼ�����ݣ���ô����һ֡ͼ������ÿһ���ǲ�һ���ģ����Զ������������Ҳ����ͬ��
*/
always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)
        din <= 0;
    else if(din == 479)
        din <= 0;
    else if (valid_in == 1'b1)
        din <= din + 1'b1;
end

endmodule
