`timescale 1ns / 1ps

//��λ�źŵ͵�ƽ��Ч
module linebuffer(
rst_n,clk,datain,dataout,
in_en,out_en
    );
parameter Width = 12;
parameter IMG_width = 640;
input rst_n;
input clk;
input [Width-1:0]datain;
output [Width-1:0]dataout;
input in_en;//�������ź�
output out_en;//��һ��������

reg [9:0]cnt;//������Χ����ͼ���������� Ϊ��ȷ����ǰ��ȫ����ȡ��
wire rd_en;//�ж���һ���Ƿ���Կ�ʼ

assign rd_en=((cnt==IMG_width)&&(in_en))?1'b1:1'b0;
assign out_en=rd_en;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt<=0;
    else if(in_en)
        if(cnt==IMG_width)
        cnt<= IMG_width;
        else
        cnt<=cnt+1'b1;
    else
    cnt<=cnt;
end
//FIFO�и�λ�źŸߵ�ƽ��Ч �첽�ź� ͬ����λ
FIFO quene(
.clk(clk),
.rst(!rst_n),
.din(datain),
.dout(dataout),
.wr_en(in_en),
.rd_en(rd_en)

);
endmodule
