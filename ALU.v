module alu #(parameter DATA_WIDTH=32)
  (
    input   wire  [DATA_WIDTH-1:0] SrcA,SrcB,
    input   wire  [2:0]            ALUControl,

    output  reg   [DATA_WIDTH-1:0] ALUResult,
    output  wire                    Zero      
  );

always @(*)
 begin
    ALUResult='b0;
    case(ALUControl)
    3'b000: ALUResult =  SrcA + SrcB;                //addition                   
    3'b001: ALUResult =  SrcA - SrcB;                 //Subtraction
    3'b010: ALUResult =  SrcA & SrcB;                  //AND 
    3'b011: ALUResult =  SrcA | SrcB;                   //OR
    3'b101: ALUResult = ((SrcA-SrcB))>>(DATA_WIDTH-1);  //SLT
   default: ALUResult='b0;
    endcase
 end
    
    assign Zero =(ALUResult == 'b0);

endmodule