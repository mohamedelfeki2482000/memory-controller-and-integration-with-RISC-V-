module adder #(parameter DATA_WIDTH =32) (
    input  wire   [DATA_WIDTH-1:0] in0,in1,
    output reg    [DATA_WIDTH-1:0] result 
);
    
always @(*)
   begin 
    result = in0 + in1;
   end
endmodule
