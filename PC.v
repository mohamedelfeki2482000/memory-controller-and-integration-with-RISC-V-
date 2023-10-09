module program_counter #(parameter DATA_WIDTH=32)
 (
    input  wire                  clk,rst,
    input  wire [DATA_WIDTH-1:0] PCNext,
    input  wire                  stall,
    output reg  [DATA_WIDTH-1:0] PC  
 );

always @(posedge clk or negedge rst)
 begin
    if(!rst)
       begin
         PC <= 'b0;
       end 
    else if (!stall)
        begin
         PC <= PCNext;   
        end    
    end
 endmodule
