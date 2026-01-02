`timescale 1ns / 1ps

module controller(
    input           branch_taken,
    input [31:0]    instruction,
    
    output          rs_read_enable,
    output          rt_read_enable,
    output          rd_write_enable,
    output [4:0]    rd_address,
    output          rd_select,

    output          dmem_enable,
    output          dmem_write_enable,
    output [1:0]    dmem_type,

    output          extend_signed, 
    output          alu_a_select,
    output          alu_b_select,
    output [3:0]    alu_operation,
    output [1:0]    pc_select
    );

    wire [5:0] opcode        = instruction[31:26];
    wire [5:0] function_code = instruction[5:0];
    wire [4:0] rs_address    = instruction[25:21];
    wire [4:0] rt_address    = instruction[20:16];
    wire [4:0] rd_address    = instruction[15:11];

    // R-type
    wire Add    = (opcode == 6'b000000 && function_code == 6'b100000);
    wire Addu   = (opcode == 6'b000000 && function_code == 6'b100001);
    wire Sub    = (opcode == 6'b000000 && function_code == 6'b100010);
    wire Subu   = (opcode == 6'b000000 && function_code == 6'b100011);
    wire And    = (opcode == 6'b000000 && function_code == 6'b100100);
    wire Or     = (opcode == 6'b000000 && function_code == 6'b100101);
    wire Xor    = (opcode == 6'b000000 && function_code == 6'b100110);
    wire Nor    = (opcode == 6'b000000 && function_code == 6'b100111);
    wire Slt    = (opcode == 6'b000000 && function_code == 6'b101010);
    wire Sltu   = (opcode == 6'b000000 && function_code == 6'b101011);
    wire Sll    = (opcode == 6'b000000 && function_code == 6'b000000);
    wire Srl    = (opcode == 6'b000000 && function_code == 6'b000010);
    wire Sra    = (opcode == 6'b000000 && function_code == 6'b000011);
    wire Sllv   = (opcode == 6'b000000 && function_code == 6'b000100);
    wire Srlv   = (opcode == 6'b000000 && function_code == 6'b000110);
    wire Srav   = (opcode == 6'b000000 && function_code == 6'b000111);
    wire Jr     = (opcode == 6'b000000 && function_code == 6'b001000);
    wire Rtype  = (opcode == 6'b000000);
        
    // I-type
    wire Addi   = (opcode == 6'b001000);
    wire Addiu  = (opcode == 6'b001001);
    wire Andi   = (opcode == 6'b001100);
    wire Ori    = (opcode == 6'b001101);
    wire Xori   = (opcode == 6'b001110);
    wire Lw     = (opcode == 6'b100011);
    wire Sw     = (opcode == 6'b101011);
    wire Beq    = (opcode == 6'b000100);
    wire Bne    = (opcode == 6'b000101);
    wire Slti   = (opcode == 6'b001010);
    wire Sltiu  = (opcode == 6'b001011);
    wire Lui    = (opcode == 6'b001111);
    wire Itype  = Addi | Addiu | Andi | Ori | Xori | Lw | Sw | Beq | Bne | Slti | Sltiu | Lui;
    
    // J-type
    wire J      = (opcode == 6'b000010);
    wire Jal    = (opcode == 6'b000011);
    wire Jtype  = J | Jal;

    assign rs_read_enable = Add | Addu | Sub | Subu | And | Or | Xor | Nor | Slt | Sltu | Sllv | Srlv | Jr | Addi | Addiu | Andi | Ori | Xori | Lw | Sw | Beq | Bne | Slti | Sltiu;
    assign rt_read_enable = Add | Addu | Sub | Subu | And | Or | Xor | Nor | Slt | Sltu | Sll | Srl | Sra | Sllv | Srlv | Srav | Beq | Bne | Sw;
    assign rd_write_enable = Add | Addu | Sub | Subu | And | Or | Xor | Nor | Slt | Sltu | Sll | Srl | Sra | Sllv | Srlv | Srav | Addi | Addiu | Andi | Ori | Xori | Lw | Slti | Sltiu | Lui | Jal;
    assign rd_select  = ~Lw;

    assign dmem_enable  = Sw | Lw;
    assign dmem_write_enable = Sw;
    assign dmem_type = 2'b00;

    assign extend_signed = Addi | Addiu | Lw | Sw | Slti | Sltiu;

    assign alu_a_select = Sll | Srl | Sra;
    assign alu_b_select = Addi | Addiu | Andi | Ori | Xori | Lw | Sw | Slti | Sltiu | Lui;

    assign pc_select[1] = J;
    assign pc_select[0] = (Beq | Bne) & branch_taken;

    assign alu_operation[3] = Slt | Sltu | Sll | Srl | Sra | Sllv | Srlv | Srav | Slti | Sltiu | Lui;
    assign alu_operation[2] = And | Or | Xor | Nor | Sra | Srav | Andi | Ori | Xori | Lui;
    assign alu_operation[1] = Sub | Subu | Xor | Nor | Sll | Srl | Sllv | Srlv | Xori | Beq | Bne;
    assign alu_operation[0] = Addu | Subu | Or | Nor | Sltu | Srl | Srlv | Addiu | Ori | Sltiu | Lui;

    mux4to1_5bit mux_rd_address(
        .d0(5'bz),
        .d1(rt_address),
        .d2(rd_address),
        .d3(5'bz),
        .s({Rtype, Itype}),
        .y(rd_address)
    );

endmodule
