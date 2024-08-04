`timescale 1ns / 1ps
module SCCB (
    clk,rst,SCCB_CLK,
    SCCB_can_read,REG_size,
    SCCB_data,REG_Index,
    REG_done,REG_rdata,
    ACK,read_en
);
input clk;
input rst;
output SCCB_CLK;//������ͷ��Ӧ��ʱ��
inout SCCB_can_read;//�ж��Ƕ�����д
input [7:0]REG_size;
//SCCB�������3��  ID+��ַ+����
input [23:0]SCCB_data;
output reg [7:0]REG_Index;//��Ӧ�ļĴ�����ַ
output REG_done;//����ͷ�������
output reg[7:0]REG_rdata;//��ȡ�Ĵ�������
output reg ACK;
output read_en;//ʹ���ź�

parameter SCCB_IDLE = 0;//��ͣ״̬ �޲���
//д������3�� 1��
parameter  SCCB_W_START=1 ;
parameter  SCCB_W_id_addr=2 ;
parameter  SCCB_W_ack1=3 ;
parameter  SCCB_W_reg_addr=4 ;
parameter  SCCB_W_ack2=5 ;
parameter  SCCB_W_reg_data=6 ;
parameter  SCCB_W_ack3=7 ;
parameter  SCCB_W_stop=8 ;
//������������  ������
parameter  SCCB_R_START1=9 ;
parameter  SCCB_R_id_addr1=10 ;
parameter  SCCB_R_ack1=11 ;
parameter  SCCB_R_reg_addr=12 ;
parameter  SCCB_R_ack2=13 ;
parameter  SCCB_R_stop1=14 ;
parameter  SCCB_R_temp=15 ;

parameter  SCCB_R_START2=16 ;
parameter  SCCB_R_id_addr2= 17;
parameter  SCCB_R_ack3=18 ;
parameter  SCCB_R_reg_data=19 ;//��ȡ�Ĵ���
parameter  SCCB_R_NA=20 ;
parameter  SCCB_R_stop2=21 ;

parameter p_SCCB_CLK = 1000;
parameter delay_num = 100000;
reg[18:0] r_delay_cnt;
reg[18:0]r_clk_cnt;//��¼ʱ��
reg r_sccb_clk;
reg[4:0]r_now_state;
reg[4:0]r_next_state;
reg[3:0]r_bit_cnt;
reg r_sccb_out;//�������


wire w_sccb_in=SCCB_can_read;
wire w_delay_done=(r_delay_cnt==delay_num)?1:0;
wire w_transfer_en=(r_clk_cnt==17'd0)?1:0;//���ݷ���ʹ��
wire w_capture_en = (r_clk_cnt==(2*p_SCCB_CLK/4)-1)?1:0;
wire w_write_done;
//�ϵ��ӳ�
always @(posedge clk or negedge rst) begin
begin
    if(!rst)
        r_delay_cnt<=0;
    else if(r_delay_cnt<delay_num)
        r_delay_cnt<=r_delay_cnt+1;
    else
        r_delay_cnt<=r_delay_cnt;
end
end

//��ʼSCCBʱ��
always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        r_clk_cnt<=0;
        r_sccb_clk<=0;
    end
    else if(w_delay_done)
    begin
        if(r_clk_cnt<(p_SCCB_CLK-1))
            r_clk_cnt <= (r_clk_cnt + 1);
        else
            r_clk_cnt <= 0;
         r_sccb_clk <= (r_clk_cnt >= (p_SCCB_CLK/4 + 1'b1))&&(r_clk_cnt  < (3*p_SCCB_CLK/4) + 1'b1) ? 1'b1 : 1'b0;
    end
    else
        begin
        r_clk_cnt <= 0;
        r_sccb_clk <= 0;
        end
end
//��ȡʹ���ź�
wire w_read_en = (r_now_state == SCCB_W_ack1 || r_now_state == SCCB_W_ack2
                    || r_now_state == SCCB_W_ack3 || r_now_state == SCCB_R_ack1
                    || r_now_state == SCCB_R_ack2 || r_now_state == SCCB_R_ack3
                    || r_now_state == SCCB_R_reg_data) ? 1'b1 : 1'b0;
assign Read_en =  w_read_en;

//sccb�ź�
assign SCCB_CLK = (r_now_state >= SCCB_W_id_addr && r_now_state <= SCCB_W_ack3 
                    || r_now_state >= SCCB_R_id_addr1 && r_now_state <= SCCB_R_ack2
                    || r_now_state >= SCCB_R_id_addr2 && r_now_state <= SCCB_R_NA) ? r_sccb_clk : 1'b1;
//��̬�Ž�����������ж�
assign SCCB_can_read = (~w_read_en) ? r_sccb_out : 1'bz;
//��SCCBʱ�����ź�ʱ  ��ʼ���ݴ洢
//���Ƚ���λ����
always @(posedge r_sccb_clk or negedge rst) begin
    if(!rst)
    begin
        r_bit_cnt<=0;
    end
    else
    begin
        //���Դ����ݵļ���״̬
        case(r_next_state)
        SCCB_W_id_addr:
        r_bit_cnt <= r_bit_cnt + 1'b1;
        SCCB_W_reg_addr:
        r_bit_cnt <= r_bit_cnt + 1'b1;
        SCCB_W_reg_data:
        r_bit_cnt <= r_bit_cnt + 1'b1;
        SCCB_R_id_addr1:
        r_bit_cnt <= r_bit_cnt + 1'b1;
        SCCB_R_reg_addr:
        r_bit_cnt <= r_bit_cnt + 1'b1;
        SCCB_R_id_addr2:
        r_bit_cnt <= r_bit_cnt + 1'b1;
        SCCB_R_reg_data:
        r_bit_cnt <= r_bit_cnt + 1'b1;
        default:
        r_bit_cnt <= 0;
        endcase
    end
end
//��󽫽��ж�Ӧλ�õĴ洢��������ȥ������cntλ�� 
//�����Ƚ���״̬ת��
//ע���еĲ�����Ҫ�ظ�8�� ����8λ���ݴ������
//��ʼ��״̬��
//ÿһ��ʱ���źŵĵ��� ״̬����Ҫ���̬�ı�
always @(posedge clk or negedge rst) begin
    if(!rst)
    r_now_state = SCCB_IDLE;
    else
    r_now_state=r_next_state;
end
always @(*) begin
    r_next_state =SCCB_IDLE;
    case(r_now_state)
    SCCB_IDLE://�޲�����Ҫ�ȴ��ӳ��źŽ���
    if(w_delay_done)
        r_next_state=SCCB_W_START;
    else
        r_next_state=SCCB_IDLE;
    SCCB_W_START:
    if(w_transfer_en)
        r_next_state=SCCB_W_id_addr;
    else
        r_next_state=SCCB_W_START;
    SCCB_W_id_addr:
    if(w_transfer_en&&r_bit_cnt==4'h8)
        r_next_state=SCCB_W_ack1;
    else
        r_next_state=SCCB_W_id_addr;
    SCCB_W_ack1:
    if(w_transfer_en)
        r_next_state=SCCB_W_reg_addr;
    else
        r_next_state=SCCB_W_ack1;
    SCCB_W_reg_addr:
    if(w_transfer_en&&r_bit_cnt==4'h8)
        r_next_state=SCCB_W_ack2;
    else
        r_next_state=SCCB_W_reg_addr;
    SCCB_W_ack2:
    if(w_transfer_en)
        r_next_state=SCCB_W_reg_data;
    else
        r_next_state=SCCB_W_ack2;
    SCCB_W_reg_data:
    if(w_transfer_en&&r_bit_cnt==4'h8)
        r_next_state=SCCB_W_ack3;
    else
        r_next_state=SCCB_W_reg_data;
    SCCB_W_ack3:
    if(w_transfer_en)
        r_next_state=SCCB_W_stop;
    else
        r_next_state=SCCB_W_ack3;
    SCCB_W_stop:
        if(w_transfer_en)
            if(w_write_done)
                r_next_state=SCCB_R_START1;
            else
                r_next_state=SCCB_W_START;
        else
        r_next_state=SCCB_W_stop;
//������������  ������
    SCCB_R_START1:
    if(w_transfer_en)
        r_next_state=SCCB_R_id_addr1;
    else
        r_next_state=SCCB_R_START1;
    SCCB_R_id_addr1:
    if(w_transfer_en&&r_bit_cnt==4'h8)
        r_next_state=SCCB_R_ack1;
    else
        r_next_state=SCCB_R_id_addr1;
    SCCB_R_ack1:
    if(w_transfer_en)
        r_next_state=SCCB_R_reg_addr;
    else
        r_next_state=SCCB_R_ack1;
    SCCB_R_reg_addr:
    if(w_transfer_en&&r_bit_cnt==4'h8)
        r_next_state=SCCB_R_ack2;
    else
        r_next_state=SCCB_R_reg_addr;
    SCCB_R_ack2:
    if(w_transfer_en)
        r_next_state=SCCB_R_stop1;
    else
        r_next_state=SCCB_R_ack2;
    SCCB_R_stop1:
    if(w_transfer_en)
        r_next_state=SCCB_R_temp;
    else
        r_next_state=SCCB_R_stop1;
    SCCB_R_temp:
    if(w_transfer_en)
        r_next_state=SCCB_R_START2;
    else
        r_next_state=SCCB_R_temp;
    SCCB_R_START2:
    if(w_transfer_en)
        r_next_state=SCCB_R_id_addr2;
    else
        r_next_state=SCCB_R_START2;
    SCCB_R_id_addr2:
    if(w_transfer_en&&r_bit_cnt==4'h8)
        r_next_state=SCCB_R_ack3;
    else
        r_next_state=SCCB_R_id_addr2;
    SCCB_R_ack3:
    if(w_transfer_en)
        r_next_state=SCCB_R_reg_data;
    else
        r_next_state=SCCB_R_ack3;
    SCCB_R_reg_data:
    if(w_transfer_en&&r_bit_cnt==4'h8)
        r_next_state=SCCB_R_NA;
    else
        r_next_state=SCCB_R_reg_data;
    SCCB_R_NA:
    if(w_transfer_en)
        r_next_state=SCCB_R_stop2;
    else
        r_next_state=SCCB_R_NA;
    SCCB_R_stop2:
        r_next_state=SCCB_R_stop2;
    endcase
end
//��ʼ������ϸ�Ĵ���
reg r_sccb_clk_default;
reg [7:0]r_sccb_temp_data;//��ʱ�洢sccb��;Э������

//�͵�ƽ��ʼ��¼����
//�Դ�̬���д���  �������̬����clk������ʱ�����޷���ʱ����ǰ������ô��� ��Ϊ ��̬��Ӧ�Ĳ����� ������++�����̬�ı� 
//����̬��Ϊ��Ҫ��״̬������Ҫ

//�ӼĴ����������
always @(negedge clk or negedge rst) begin
    if(!rst)
    r_sccb_out<=0;
    else if(w_transfer_en)
        case(r_next_state)
        SCCB_R_START1: 
            begin
            r_sccb_clk_default <= 1'b1;
            r_sccb_out <= 1'b0;
            r_sccb_temp_data <= SCCB_data[23:16];//���λ��ID��ַ
            end
        SCCB_R_START2: 
            begin
            r_sccb_clk_default <= 1'b1;
            r_sccb_out <= 1'b0;
            r_sccb_temp_data <= SCCB_data[7:0];//��λ��ID��ַ
            end
        SCCB_R_id_addr1: 
            begin
            r_sccb_clk_default <= 1'b0;
            r_sccb_out <= r_sccb_temp_data[3'd7 - r_bit_cnt];
            end
        SCCB_R_id_addr2: 
            begin
            r_sccb_clk_default <= 1'b0;
            if (r_bit_cnt < 4'd7)
                r_sccb_out <= r_sccb_temp_data[3'd7 - r_bit_cnt];
            else
                r_sccb_out <= 1'b1;
                //����λ���� ȡ����ȡ״̬
            end
        SCCB_R_reg_addr: 
                begin
                r_sccb_clk_default <= 1'b0;
                r_sccb_out <= r_sccb_temp_data[3'd7 - r_bit_cnt];
                end
        SCCB_R_NA: 
                begin
                r_sccb_clk_default <= 1'b1;
                r_sccb_out <= 1'b1;
                end
        SCCB_W_START: 
                begin
                r_sccb_clk_default <= 1'b1;
                r_sccb_out <= 1'b0;
                r_sccb_temp_data <= SCCB_data[23:16];//���λ��ID��ַ
                end
        SCCB_W_id_addr: 
                begin
                r_sccb_clk_default <= 1'b0;
                r_sccb_out <= r_sccb_temp_data[3'd7 - r_bit_cnt];
                end
        SCCB_W_reg_data: 
                begin
                r_sccb_clk_default <= 1'b0;
                r_sccb_out <= r_sccb_temp_data[3'd7 - r_bit_cnt];
                end
        SCCB_W_reg_addr: 
                begin
                r_sccb_clk_default <= 1'b0;
                r_sccb_out <= r_sccb_temp_data[3'd7 - r_bit_cnt];
                end
        SCCB_W_ack1: //д��Ӧ��1
                begin
                r_sccb_clk_default <= 1'b0;
                r_sccb_temp_data <= SCCB_data[15:8];//�м�λ�ļĴ�����ַ
                end
        SCCB_W_ack2: //д��Ӧ��2
                begin
                r_sccb_clk_default <= 1'b0;
                r_sccb_temp_data <= SCCB_data[7:0];//��λ��д������
                end
        SCCB_R_stop1: //ֹͣ���
                begin
                 r_sccb_clk_default <= 1'b1;
                r_sccb_out <= 1'b0;
                end
        SCCB_R_stop2:
                begin
                 r_sccb_clk_default <= 1'b1;
                r_sccb_out <= 1'b0;
                end
        SCCB_R_temp: //�����м�ת��״̬
                begin
                 r_sccb_clk_default <= 1'b1;
                r_sccb_out <= 1'b1;
                end
            
        SCCB_R_ack1: //����Ӧ��1
                begin
                 r_sccb_clk_default <= 1'b0;
                r_sccb_temp_data <= SCCB_data[15:8];//�м�λ�ļĴ�����ַ
                end
        SCCB_R_ack2://����Ӧ��2
                begin
                 r_sccb_clk_default <= 1'b0;
                end
        SCCB_R_ack3:
                begin
                 r_sccb_clk_default <= 1'b0;
                end
        SCCB_R_reg_data: //�����Ĵ�������
                begin
                 r_sccb_clk_default <= 1'b0;
                end
            
        SCCB_W_ack3: //д��Ӧ��3
                begin
                 r_sccb_clk_default <= 1'b0;
                end
        SCCB_W_stop: //д��ֹͣ
                begin
                 r_sccb_clk_default <= 1'b1;
                r_sccb_out <= 1'b0;
                end
        default: ;
        endcase
end
//��Ĵ�����д���� ��������·��
wire w_transfer_end = (r_now_state == SCCB_W_stop 
                         || r_now_state == SCCB_R_stop2) ? 1'b1 : 1'b0;
always @ (negedge clk or negedge rst)
    begin
        if (!rst)//����
            REG_Index <= 0;
        else if (w_transfer_en)
            begin
            if (w_transfer_end && ACK == 1'b0)
                begin
                if (REG_Index < REG_size)
                    REG_Index <= REG_Index + 1'b1;
                else
                    REG_Index <= REG_size;
                end
            else
                REG_Index <= REG_Index;
            end
        else
            REG_Index <= REG_Index;
    end
assign REG_done = (REG_Index == REG_size) ? 1 : 0;
assign w_write_done = (REG_Index == (REG_size - 1)) ? 1 : 0;
always @ (negedge clk or negedge rst)
    begin
        if (!rst)//���� 
            REG_rdata <= 0;//REG_rdata
        else if (w_capture_en)
            case (r_next_state)
            SCCB_R_reg_data: //���Ĵ�������
                REG_rdata <= {REG_rdata[6:0], w_sccb_in};
            default:  ;
            endcase
    end

    //Ӧ���źŴ���
reg [2:0]r_ack;//3��Ӧ���źŵļ�¼
always @ (posedge clk or negedge rst)
    begin
        if (!rst)//����
            begin
            r_ack <= 3'b111;
            ACK <= 1'b1;
            end
        else if(w_capture_en)
            begin
            case(r_next_state)
            SCCB_IDLE: //����̬
                begin
                r_ack <= 3'b111;
                ACK <= 1'b1;
                end
            SCCB_R_ack1:
                r_ack[0] <= w_sccb_in;
            SCCB_R_ack2:
                r_ack[1] <= w_sccb_in;
            SCCB_R_ack3:
                r_ack[2] <= w_sccb_in;
            SCCB_R_stop2:
                ACK <= (r_ack[0] | r_ack[1] | r_ack[2]);
            SCCB_W_ack1:
                r_ack[0] <= w_sccb_in;
            SCCB_W_ack2:
                r_ack[1] <= w_sccb_in;
            SCCB_W_ack3:
                r_ack[2] <= w_sccb_in;
            SCCB_W_stop:
                ACK <= (r_ack[0] | r_ack[1] | r_ack[2]); 
            default: ;
            endcase
            end
        else
            begin
            r_ack <= r_ack;//����
            ACK <= ACK;
            end
    end
endmodule
