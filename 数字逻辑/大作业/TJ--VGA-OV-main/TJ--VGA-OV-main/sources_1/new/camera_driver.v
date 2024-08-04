`timescale 1ps / 1ps
module camera_Driver(SIOC, SIOD, VSYNC, HREF, PCLK, XCLK, CA_DATA, CA_RST, PWDN, f_data, f_addr, out_en, rst_n, clk_sioc, clk_xclk, is_ack, is_read, reg_data_read);
    //����ͷ�ӿ�
    output SIOC;//SCCBʱ��
    inout SIOD;//SCCB����
    input VSYNC;//��ͬ��
    input HREF;//����Ч
    input PCLK;//����ʱ��
    output XCLK;//������ʱ��
    input [7:0]CA_DATA;//8bit����
    output CA_RST;
    output PWDN;
    
    output [11:0]f_data; 
    output [18:0]f_addr;
    output out_en;//����ź�
    input rst_n;//��λ
    input clk_sioc;//SCCBʱ��
    input clk_xclk;//XCLKʱ��
    output is_ack;//Ӧ���ź�
    output is_read;//��̬��
    output [7:0]reg_data_read;//�Ĵ�������
    

    wire [7:0]sccb_size;
    wire [7:0]sccb_index;
    wire [15:0]write_data;//��ȡ����������
    wire w_xclk, w_sioc;//ʱ���м���
    wire sccb_end;//��������ź�
    

    assign CA_RST  = 1;//�ߵ�ƽ
    assign PWDN = 0;//�͵�ƽ
    parameter IDaddr = 8'h60;//д�Ĵ�����ַ
    //SCCBʱ��ʵ����
    SCCB sccn_inst(
        .clk(clk_sioc),.rst(rst_n),.SCCB_CLK(SIOC),
    .SCCB_can_read(SIOD),.REG_size(sccb_size),.SCCB_data({IDaddr, write_data[15:0]}),.REG_Index(sccb_index),
    .REG_done(sccb_end),.REG_rdata(reg_data_read),.ACK(is_ack),.read_en(is_read)
    );
    
    //����ʵ����
    Config config_inst(.data_index(sccb_index), .data_out(write_data), .reg_size(sccb_size));
    assign XCLK=clk_xclk;
    //��ȡ����
    get_pic pic_inst(
    .rst(rst_n), .CFG_done(sccb_end), .pclk(PCLK), .vsync(VSYNC), .herf(HREF), .data_in(CA_DATA), .data_out(f_data), .we_en(out_en), .out_addr(f_addr)
    );

endmodule