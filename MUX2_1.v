module mux2_1 #(parameter DATA_WIDTH=1)(

    input   wire   [DATA_WIDTH-1:0] in0,in1,
    input   wire                    sel,
    output  reg    [DATA_WIDTH-1:0] out  
);

always @(*)
   begin
        if(sel)
          out = in1;   
        else
          out = in0;      
   end
endmodule
