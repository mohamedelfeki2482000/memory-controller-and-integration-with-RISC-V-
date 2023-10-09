module control_unit (
    input   wire        Zero,
    input   wire [6:0]  op,
    input   wire [2:0]  funct3,
    input   wire        funct7_5,
    
    output  wire        PCSrc,
    output  wire  [1:0] ResultSrc,
    output  wire        MemWrite,
    output  wire        MemRead,
    output  wire        ALUSrc,
    output  wire  [1:0] ImmSrc,
    output  wire        RegWrite,
    output  wire  [2:0] ALUControl              
);
/************************ ALU Decoder ******************/
wire   [1:0] ALUOp;
wire         Branch;
wire         Jump;

alu_decoder u0(
    .ALUOP(ALUOp),
    .funct3(funct3),
    .funct7_5(funct7_5),
    .op_5(op[5]),
    .ALUControl(ALUControl)      
);

/*********************** Main Decoder *******************/
main_decoder u1(
        .op(op),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .ImmSrc(ImmSrc),
        .ALUOp(ALUOp),   
        .Jump(Jump)            
);

assign PCSrc = (Branch & Zero) | Jump;

endmodule
