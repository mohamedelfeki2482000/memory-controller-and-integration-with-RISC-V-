module main_decoder (
    input  wire [6:0] op,
    output reg        RegWrite,ALUSrc,Jump,
    output reg        MemWrite,Branch,
    output reg        MemRead,
    output reg  [1:0] ImmSrc,ALUOp,ResultSrc               
);


always@(*)
   begin
    RegWrite    ='b0;
    ImmSrc      ='b0;
    ALUSrc      ='b0;
    MemWrite    ='b0;
    MemRead     ='b0;
    ResultSrc   ='b0;
    Branch      ='b0;
    ALUOp       ='b0;
    Jump        ='b0;

    case (op)
    7'b0000_011: begin      // lw
                RegWrite    ='b1;
                ImmSrc      ='b00;
                ALUSrc      ='b1;
                MemWrite    ='b0;
                MemRead     ='b1;
                ResultSrc   ='b01;
                Branch      ='b0;
                ALUOp       ='b00;
                Jump        ='b0;
                    end

    7'b0100_011: begin      // sw
                RegWrite    ='b0;
                ImmSrc      ='b01;
                ALUSrc      ='b1;
                MemWrite    ='b1;   
                MemRead     ='b0;
                Branch      ='b0;
                ALUOp       ='b00;
                Jump        ='b0;
                    end

    7'b0110_011: begin      //R-type
                RegWrite    ='b1;
                ALUSrc      ='b0;
                MemWrite    ='b0;
                MemRead     ='b0;
                ResultSrc   ='b00;
                Branch      ='b0;
                ALUOp       ='b10;
                Jump        ='b0;
                    end

    7'b1100_011: begin      //beq
                RegWrite    ='b0;
                ImmSrc      ='b10;
                ALUSrc      ='b0;
                MemWrite    ='b0;
                MemRead     ='b0;
                Branch      ='b1;
                ALUOp       ='b01;
                Jump        ='b0;
                    end

    7'b0010_011: begin      // I-Type 
                RegWrite    ='b1;
                ImmSrc      ='b00;
                ALUSrc      ='b1;
                MemWrite    ='b0;
                MemRead     ='b0;
                ResultSrc   ='b00;
                Branch      ='b0;
                ALUOp       ='b10;
                Jump        ='b0;
                    end


    7'b1101_111: begin      // jal
                RegWrite    ='b1;
                ImmSrc      ='b11;
                MemWrite    ='b0;
                MemRead     ='b0;
                ResultSrc   ='b10;
                Branch      ='b0;
                Jump        ='b1;
                    end

    default     : begin
                RegWrite    ='b0;
                ImmSrc      ='b00;
                ALUSrc      ='b0;
                MemWrite    ='b0;
                MemRead     ='b0;
                ResultSrc   ='b0;
                Branch      ='b0;
                ALUOp       ='b00;
                Jump        ='b0;

                    end

    endcase
   end
endmodule