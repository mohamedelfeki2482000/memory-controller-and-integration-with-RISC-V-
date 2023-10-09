module DATA_PATH #(parameter DATA_WIDTH = 32 ) 
(
        input  wire                  clk,rst,
        input  wire                  Zero_datapath,PCSrc_datapath,
        input  wire                  MemWrite_datapath,MemRead_datapath,ALUSrc_datapath,RegWrite_datapath, 
        input  wire [1:0]            ResultSrc_datapath,ImmSrc_datapath,
        input  wire [2:0]            ALUControl_datapath,

        output wire [DATA_WIDTH-1:0] instr_datapath  
        );

/**************** Program Counter ****************/
wire    [DATA_WIDTH-1:0]  PCNext_datapath;
wire    [DATA_WIDTH-1:0]  PC_datapath;
wire                      stall; 


program_counter #( .DATA_WIDTH(DATA_WIDTH))
   u0(
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .PCNext(PCNext_datapath),
        .PC(PC_datapath)  
     );

/***************** Instruction Memory *************/
instruction_memory #(.DATA_WIDTH(DATA_WIDTH) )
    u1(
    .pc(PC_datapath),
    .instr(instr_datapath)
    );

/********************** Register File ********************/
wire       [DATA_WIDTH-1:0] RD1_datapath;
wire       [DATA_WIDTH-1:0] RD2_datapath;
wire       [DATA_WIDTH-1:0] Result_datapath;

register_file #(.DATA_WIDTH(DATA_WIDTH))
  u3(
    .clk(clk),
    .rst(rst),
    .A1(instr_datapath[19:15]),
    .A2(instr_datapath[24:20]),
    .A3(instr_datapath[11:7]),
    .WE3(RegWrite_datapath),
    .WD3(Result_datapath),
    .RD1(RD1_datapath),
    .RD2(RD2_datapath)  
    );

/***************** ALU ***********************************/
wire  [DATA_WIDTH-1:0] ALUResult_datapath;
 wire [DATA_WIDTH-1:0] SrcB_mux_datapath;

 alu #(.DATA_WIDTH(DATA_WIDTH))
   u4(
    .SrcA(RD1_datapath),
    .SrcB(SrcB_mux_datapath),
    .ALUControl(ALUControl_datapath),
    .ALUResult(ALUResult_datapath),
    .Zero(Zero_datapath)      
    );

/**************** Data Memory ***************************/
wire [DATA_WIDTH-1:0] ReadData_datapath;
// data_memory #(.DATA_WIDTH(DATA_WIDTH)) 
//    u5(
//     .clk(clk),
//     .rst(rst),
//     .Address(ALUResult_datapath),
//     .WE(MemWrite_datapath),
//     .WD(RD2_datapath),
//     .RD(ReadData_datapath) 
//     );

 cache_Memory_top u5(
    .clk(clk),
    .rst(rst),
    .Mem_Write(MemWrite_datapath),
    .Mem_Read(MemRead_datapath),
    .Word_address(ALUResult_datapath),
    .Data_In(RD2_datapath),

    .stall(stall),
    .Data_Out(ReadData_datapath) 
) ;




/******************* EXTENSION ***************************/ 
 wire [DATA_WIDTH-1:0] ImmExt_datapath;

 sign_extend u6 (
    .instr_unextend(instr_datapath[31:7]),
    .imm_src(ImmSrc_datapath),
    .instr_extend(ImmExt_datapath)
    );

/****************** ADDER PCTarget ***********************/
wire  [DATA_WIDTH-1:0] PCTarget_datapath;

adder #(.DATA_WIDTH(DATA_WIDTH))
 u7 (
    .in0(PC_datapath),
    .in1(ImmExt_datapath),
    .result(PCTarget_datapath) 
);

/****************** ADDER PCPlus4 ***********************/
wire  [DATA_WIDTH-1:0] PCPlus4_datapath;

adder #(.DATA_WIDTH(DATA_WIDTH))
 u8 (
    .in0(PC_datapath),
    .in1('d4),
    .result(PCPlus4_datapath) 
);

/******************  MUX PCNext ************************/
 mux2_1 #(.DATA_WIDTH(DATA_WIDTH))
  u9(
    .in0(PCPlus4_datapath),
    .in1(PCTarget_datapath),
    .sel(PCSrc_datapath),
    .out(PCNext_datapath)  
    );

/******************  MUX ALUResult ************************/
 mux2_1 #(.DATA_WIDTH(DATA_WIDTH))
  u10(
    .in0(RD2_datapath),
    .in1(ImmExt_datapath),
    .sel(ALUSrc_datapath),
    .out(SrcB_mux_datapath)  
    );

/******************  MUX Result ************************/
mux4_1 #(.DATA_WIDTH(DATA_WIDTH))
u11(
    .in0(ALUResult_datapath),
    .in1(ReadData_datapath),
    .in2(PCPlus4_datapath),
    .sel(ResultSrc_datapath),
    .out(Result_datapath)  
);

endmodule
  