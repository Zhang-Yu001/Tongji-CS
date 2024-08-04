`timescale 1ns / 1ps
module get_pic(rst, CFG_done, pclk,  vsync, herf, data_in, data_out, we_en, out_addr);
    input rst;//��λ�ź�
    input CFG_done;//�������

    input pclk;//����ʱ��

    input vsync;//��ͬ���ź�
    input herf;//����Ч�ź�
    input [7:0]data_in;//���ݽ���
    output reg[11:0]data_out;//ƴ�ӵ�12bit����
    output reg we_en;//���ʹ��
    output [18:0]out_addr;//д��RAM�ĵ�ַ    
    parameter p_real_y = 11'd600;//������ʵ�ʱ߽�
    parameter p_real_x = 11'd800;//������ʵ�ʱ߽�
    parameter p_true_y = 11'd480;//��������Ч�߽�
    parameter p_true_x = 11'd640;//��������Ч�߽�

    reg[15:0]RGB_565=0;    
    //��ַ��ʱ�ӵĸ�ֵ
    reg [18:0]r_addr;//��ַ�Ĵ���
    assign out_addr = r_addr;

    reg [1:0]r_detect_border;    //����������½���
    reg r_vysnc_valid;//֡��Ч�ź�
    wire w_negedge;//�½���
    wire w_posedge;//������
    always @ (posedge pclk or negedge rst)
    begin
        if(!rst)
            r_detect_border <= 0;
        else if (CFG_done)
            r_detect_border <= {r_detect_border[0], vsync};
    end
    assign w_negedge = r_detect_border[1] && !r_detect_border[0] ;//�½���
    assign w_posedge = !r_detect_border[1] && r_detect_border[0] ;//������
    

    
    always @(posedge pclk or negedge rst)
    begin
        if (!rst) 
        r_vysnc_valid<=0;
        else if (CFG_done)
            begin
            if(w_posedge) 
            //������
                r_vysnc_valid <= 1; 
            else if(w_negedge) 
            //�½���
                r_vysnc_valid <= 0;
            else 
                r_vysnc_valid <= r_vysnc_valid;
            end
    end
    
    //ƴ������
    reg [11:0]r_cnt;//���������
    reg [1:0]r_temp;//�м�ֵ��ת��

    always @ (posedge pclk or negedge rst)
    begin
        if (!rst) //��λ
            begin 
            r_cnt <= 0;
            r_temp <= 0;
            data_out  <= 0;
            we_en <= 1'b0;
            r_addr <= 0;
            end
     else if (CFG_done)//�������
                       begin
                       if (r_vysnc_valid)
                           begin
                           if ((herf == 1'b1) && (vsync == 1'b1) && (r_cnt < p_true_x)) //��һ��֡���д���
                               begin   
                               if (r_temp < 1'b1) 
                                   begin                                    
                                   r_temp <= r_temp + 1'b1;
                                   data_out[11:5] = {data_in[7:4], data_in[2:0]};
                                   we_en <= 1'b0;
                                   end
                               else 
                                   begin                                                 
                                   r_cnt <= r_cnt+ 1'b1;
                                   r_temp <= 0;
                                   data_out[4:0] <= {data_in[7], data_in[4:1]};
                                    r_addr <= r_addr + 1'b1;
                                    we_en <= 1'b1;
                                   end
                               end
                else if ((herf == 1'b0) && (vsync == 1'b1)) //һ�н���
                    begin   
                    r_cnt <= 0;
                    r_temp <= 0;
                    we_en <= 1'b0;
                    r_addr <= r_addr;
                    end
                else 
                    begin
                    r_cnt <= r_cnt;//��ȡһ�к�ȴ�
                    r_temp <= 0;
                    we_en <= 1'b0;
                    r_addr <= r_addr;
                    end
            end
        else 
            begin
            r_cnt <= 0;
            r_temp <= 0;
            we_en <= 1'b0;
            r_addr <= 0;
            end   
        end 
    end    
    
endmodule