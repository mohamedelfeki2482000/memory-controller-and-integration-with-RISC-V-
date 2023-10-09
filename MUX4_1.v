module mux4_1 #(parameter DATA_WIDTH=1)(

    input   wire   [DATA_WIDTH-1:0] in0,in1,in2,
    input   wire   [1:0]            sel,
    output  reg    [DATA_WIDTH-1:0] out  
);

always @(*)
   begin
        case (sel)
        2'b00: out =in0;
        2'b01: out =in1;
        2'b10: out =in2;
        default: out='b0;
        endcase     
   end
endmodule

