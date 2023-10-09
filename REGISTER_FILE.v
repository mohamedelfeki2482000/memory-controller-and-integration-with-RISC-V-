module register_file #( parameter DATA_WIDTH=32)
 (
    input  wire                       clk,rst,
    input  wire  [4:0]                A1,A2,A3,
    input  wire                       WE3,
    input  wire  [DATA_WIDTH-1:0]     WD3,

    output wire  [DATA_WIDTH-1:0]     RD1,RD2  
);

reg [DATA_WIDTH-1:0] reg_file [0:31];
integer  i;
always @(posedge clk)
  begin
    if(!rst)
      begin
         for (i=0; i<32 ; i=i+1)
           reg_file[i] <= 'b0;
      end

    else if (WE3 & A3==0)
      begin
         reg_file[A3] <= 'b0;
      end
 
    else if (WE3)
      begin
         reg_file[A3] <= WD3;
      end  
    else
      begin
          reg_file[A3] <= reg_file[A3]; 
      end   
  end
    
    assign RD1 = reg_file[A1];
    assign RD2 = reg_file[A2];

endmodule
