module cache_Memory (
    input    wire          clk,rst,
    input    wire  [9:0]   Word_address,
    input    wire  [31:0]  data,
    input    wire  [31:0]  Data_IN,
    input    wire          write_in_cache,read_from_cache,
    input    wire          move_to_cache,         

    output   reg           check_Miss_hit,
    output   reg   [31:0]  Data_Out 
);

reg [31:0]  cache_mem [0:127];
reg [3:0]   valid_tag [0:31];
reg [1:0]   move_count;
integer i,k;

always @(posedge clk or negedge rst )
    begin
      if(!rst)
         begin
            for (i=0;i<128;i=i+1)
               begin
                cache_mem[i]<='b0;
               end 
            for (k=0;k<32;k=k+1)
               begin
                valid_tag[k]<='b0;
               end 
               move_count <= 'b0;  
         end

      else if (write_in_cache)
         begin
            cache_mem [Word_address[6:0]] <= Data_IN;
            valid_tag [Word_address[6:2]] <={1'b1,Word_address[9:7]}; 
         end

      else if (move_to_cache)
         begin
            cache_mem [{Word_address[6:2],move_count}] <= data;
            valid_tag [Word_address[6:2]]              <={1'b1,Word_address[9:7]};
            move_count                                 <= move_count +'b1;
         end   


    end


   always @(*)
      begin
         if (valid_tag[Word_address[6:2]] == {1'b1 , Word_address [9:7]})
            begin
             check_Miss_hit ='b1;
            end         
         else
            begin
             check_Miss_hit ='b0;
            end
      end
       always @(*) begin
         if (!rst) begin
            Data_Out='b0;
            
         end
         else if (read_from_cache)
         begin
            Data_Out = cache_mem [Word_address[6:0]]; 
         end 
         else begin
            Data_Out='b0;
         end           
   
 end
endmodule
