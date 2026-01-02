`timescale 1ns / 1ps

module stall(
    input           clock,
    input           reset,

    input   [4:0]   rs_address_in,
    input   [4:0]   rt_address_in,
    input           rs_read_enable_in,
    input           rt_read_enable_in,

    input           ex_write_enable_in,
    input           mem_write_enable_in,
    input   [4:0]   ex_write_address_in,
    input   [4:0]   mem_write_address_in,

    output  reg     stall_out
    );

    reg stall_latency;

    always @ (negedge clock or posedge reset) 
    begin
        if(reset) 
        begin
            stall_out       <= 1'b1;
            stall_latency   <= 1'b0;
        end
        else if (stall_latency == 0) 
        begin
            // �����ǰ����stall״̬
            if(stall_out) 
            begin
                stall_out <= 1'b0;
            end
            // ���ݳ�ͻ���
            else
            begin
                // ex�׶ε�д����id�׶εĶ�����������ͻ��stall 2������
                if(ex_write_enable_in && ((rs_read_enable_in && (ex_write_address_in == rs_address_in)) || (rt_read_enable_in && (ex_write_address_in == rt_address_in)))) 
                begin
                    stall_latency <= 1'b1;
                    stall_out     <= 1'b1;
                end
                // mem�׶ε�д����id�׶εĶ�����������ͻ��stall 1������
                else if(mem_write_enable_in && ((rs_read_enable_in && (mem_write_address_in == rs_address_in)) || (rt_read_enable_in && (mem_write_address_in == rt_address_in)))) 
                begin
                    stall_latency <= 1'b0;
                    stall_out     <= 1'b1;
                end
            end
        end
        else 
        begin
            stall_latency = stall_latency - 1;
        end
	end
endmodule
