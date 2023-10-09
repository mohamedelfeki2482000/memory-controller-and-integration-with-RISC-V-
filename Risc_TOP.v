module RISC_V #(parameter DATA_WIDTH = 32 ) 
(
        input  wire                clk,rst
);


//** Signals of interface
wire                    Zero_top;
wire                    PCSrc_top;
wire  [1:0]             ResultSrc_top;
wire                    MemWrite_top;
wire                    MemRead_top;
wire                    ALUSrc_top;
wire  [1:0]             ImmSrc_top;
wire                    RegWrite_top;
wire  [2:0]             ALUControl_top;
wire  [DATA_WIDTH-1:0]  instr_top;



/**************** DataPath ****************/
DATA_PATH #(.DATA_WIDTH(DATA_WIDTH) ) 
      u0(
        .clk(clk),
        .rst(rst),
        .PCSrc_datapath(PCSrc_top),
        .MemWrite_datapath(MemWrite_top),
        .MemRead_datapath(MemRead_top),
        .ALUSrc_datapath(ALUSrc_top),
        .RegWrite_datapath(RegWrite_top), 
        .ResultSrc_datapath(ResultSrc_top),
        .ImmSrc_datapath(ImmSrc_top),
        .ALUControl_datapath(ALUControl_top),
        .Zero_datapath(Zero_top),
        .instr_datapath(instr_top)  
        );


/***************** Control path *************/
control_unit u1 (
    .Zero(Zero_top),
    .op(instr_top[6:0]),
    .funct3(instr_top[14:12]),
    .funct7_5(instr_top[30]),
    
    .PCSrc(PCSrc_top),
    .ResultSrc(ResultSrc_top),
    .MemWrite(MemWrite_top),
    .MemRead(MemRead_top),
    .ALUSrc(ALUSrc_top),
    .ImmSrc(ImmSrc_top),
    .RegWrite(RegWrite_top),
    .ALUControl(ALUControl_top)              
);

endmodule
