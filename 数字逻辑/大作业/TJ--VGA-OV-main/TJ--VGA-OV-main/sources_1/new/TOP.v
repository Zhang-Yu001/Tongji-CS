`timescale 1ns / 1ps

//����ͷ����ҵ���������ģ��
module TOP(sioc, siod, vsync, herf, pclk, xclk, ca_data, ca_rst, pwdn, vsync_s, hsync_s, red_d, green_d, blue_d, is_ack, pix, rst_n, clk, is_read, is_write
,model_1,model_3,model_2);
    //����ͷ�ӿ�
    output sioc;//SCCBʱ��
    inout siod;//SCCB���ݣ�˫��
    input vsync;//��ͬ���ź�
    input herf;//����Ч�ź����
    input pclk;//����ʱ��
    output xclk;//������ʱ��
    input [7:0]ca_data;//8bit����
    output ca_rst;//��λ
    output pwdn;
    

    output vsync_s;//��ͬ���ź�
    output hsync_s;//��ͬ���ź�
    output [3:0]red_d;//����ɫ�ź�
    output [3:0]green_d;//����ɫ�ź�
    output [3:0]blue_d;//����ɫ�ź�

    output is_ack;//����ͷӦ�������͵�ƽ��Ч��
    output [7:0]pix;
    output is_write;//д������ʹ���ź�
    output is_read;//���ڷ������̬�����
    //ģ��ȫ�ֽӿ�
    input rst_n;//��λ

    input clk;//������ϵͳʱ�ӣ�100MHz
    input model_1;
  input model_2;
    input model_3;
    //�ڲ�ģ�����
    //RAM�ӿ�
    wire [11 : 0]Frame_data; //output
    wire [18 : 0]Frame_addr; //output
    
    //�ڲ�����
    wire [18:0]w_read_addr;//VGA��ȡ��ַ
    wire [7:0]w_Read_ID;//��ȡ����ͷ��ID���������ͷ�Ĺ��������д���������
    wire [11:0]w_out_pix_data;//�������������
    wire w_clk_10MHz, w_clk_24MHz, w_clk_25MHz;//��Ƶ���ʱ����
    
    assign pix = ca_data;//w_out_pix_data[15:8]
    //ʱ�ӷ�Ƶ��
     clk_wiz_0 div(.clk_in1(clk), .clk_out2(w_clk_10MHz), .clk_out3(w_clk_24MHz), .clk_out1(w_clk_25MHz));
    camera_Driver came_inst(
        .SIOC(sioc), 
        .SIOD(siod), 
        .VSYNC(vsync), 
        .HREF(herf),
        .PCLK(pclk), 
        .XCLK(xclk), 
        .CA_DATA(ca_data), 
        .CA_RST(ca_rst), 
        .PWDN(pwdn), 
        .f_data(Frame_data), 
        .f_addr(Frame_addr),
        .out_en(is_write),
        .rst_n(rst_n), 
        .clk_sioc(w_clk_10MHz), 
        .clk_xclk(w_clk_25MHz),
        .is_ack(is_ack),
        .is_read(is_read), 
        .reg_data_read(w_Read_ID)
    );
    
    //ʵ������˫��RAM
    RAM ram_inst(
        .wea(is_write ), 
        .clka(pclk), //Frame_clken  clk
        .clkb(w_clk_25MHz), 
        .addra(Frame_addr), 
        .addrb(w_read_addr), 
        .dina(Frame_data), 
        .doutb(w_out_pix_data)
    );
    

    wire [11:0]deal_color;

    process_picture pro(.clk(clk),.in_rgb(w_out_pix_data),.out_rgb(deal_color));
    wire [11:0]deal_ed_color;
    wire have_end;
  sobel sobel_inst(    .clk(w_clk_25MHz),.rst(rst_n),.datain(deal_color),.datain_en(1),
    .dataout(deal_ed_color),.dataout_en(have_end));
    wire [11:0]deal_deal_data;
    MidLv mid_opt(    .clk(clk),.rst(rst_n),.datain(deal_ed_color),.datain_en(1),
.dataout(deal_deal_data),.dataout_en(),.clk_in(w_clk_25MHz));
    //ʵ����VGA��ʾģ��
    VGA vga_inst(
        .I_clk(w_clk_25MHz), 
        .I_rst(rst_n), 
        .PixAdd(w_read_addr),
        .PixData(w_out_pix_data),// Frame_data w_out_pix_data
        .VS(vsync_s), 
        .HS(hsync_s), 
        .R(red_d), 
        .G(green_d), 
        .B(blue_d),
        .model1(model_1),
         .model2(model_2),
          .model3(model_3),
        .Pixdata_2(deal_color),
        .Pixdata_3(deal_deal_data)
    );
endmodule