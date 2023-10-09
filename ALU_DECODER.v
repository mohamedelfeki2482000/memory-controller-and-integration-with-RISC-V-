module alu_decoder (
    input   wire     [1:0]  ALUOP,
    input   wire     [2:0]  funct3,
    input   wire            funct7_5,
    input   wire            op_5,

    output  reg      [2:0]  ALUControl      
);
    
always @(*)
   begin
    ALUControl =3'b000;
    case (ALUOP)
    2'b00: ALUControl =3'b000;
    2'b01: ALUControl =3'b001;
    2'b10: begin
            case(funct3)
            3'b111: ALUControl= 3'b010;    
            3'b110: ALUControl= 3'b011;    
            3'b010: ALUControl= 3'b101;    
            3'b000: begin
                      if({op_5 , funct7_5} == 2'b11 )
                        ALUControl =3'b001;
                      else
                        ALUControl =3'b000;  
                    end
           default: ALUControl =3'b000;         
            endcase     
            end 
 default: ALUControl =3'b000;
    endcase
   end
endmodule
