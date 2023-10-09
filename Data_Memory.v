module  data_memory (
    input        wire            clk,rst,    
    input        wire   [9:0]    Word_address,              
    input        wire   [31:0]   Data_In,   
    input        wire            write_in_mem,    
    input        wire            move_to_cache,
    
    output       reg    [31:0]         data    
);

    reg [31:0]  main_memory [0:1023];
    reg [1:0]   address_count;
    integer     i;

always@(posedge clk or negedge rst)
    begin
        if(!rst)
          begin
            for(i=0;i<1024;i=i+1)
              main_memory[i] <='b0;
              address_count  <='b0;
              data           <='b0;
          end
        else 
          begin
             if(write_in_mem)
               begin
                main_memory[Word_address] <= Data_In;
                address_count             <='b0;
               end   
             else if (move_to_cache)
               begin
                address_count <=address_count+1;
                data          <= main_memory[{Word_address[9:2],address_count}];
               end  
               else 
               begin
                address_count <='b0;
               end
          end    
    end 

endmodule
