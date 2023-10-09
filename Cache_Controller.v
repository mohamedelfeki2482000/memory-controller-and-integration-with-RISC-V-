module cache_controller(
    input  wire             clk,rst,
    input  wire             Mem_Write,Mem_Read,
    input  wire             check_Miss_hit,

    output reg              write_in_mem,
    output reg              write_in_cache,
    output reg              move_from_mem,
    output reg              move_to_cache,
    output reg              read_from_cache,
    output reg              stall
);
parameter  IDLE          =3'b000,
           READING       =3'b001,
           MOVE_TO_CACHE =3'b010,
           WRITING       =3'b011,
           STALL         =3'b100;

reg     [2:0] current_state,next_state;
reg     [2:0] counter;                
reg           counter_enable;


always @(negedge clk or negedge rst)
    begin
        if(!rst)
          begin
            counter <='b0;
          end
        else if (counter_enable)
            begin
            counter <= counter +'b1;   
            end  
       else 
          begin
            counter <= 'b0;
          end     
    end

always @(negedge clk or negedge rst)
    begin
        if(!rst)
          begin
            current_state <=IDLE;
          end
        else 
          begin
            current_state <= next_state;   
          end  
    end

always@(*)
    begin
        write_in_mem    ='b0;
        write_in_cache  ='b0;
        move_from_mem   ='b0;
        move_to_cache   ='b0;
        read_from_cache ='b0;
        counter_enable  ='b0;

        case(current_state)
             IDLE        : begin 
                            if((Mem_Read=='b1) && (Mem_Write =='b0) && (check_Miss_hit=='b1) ) 
                                begin
                                    next_state = IDLE;
                                    stall           ='b0;
                                    read_from_cache='b1;
                                end
                            
                            else if((Mem_Read=='b1) && (Mem_Write =='b0) && (check_Miss_hit=='b0) ) 
                                begin
                                    next_state = READING;
                                    stall='b1;
                                    move_from_mem = 'b1;
                               
                                end
                            
                            else if((Mem_Read=='b0) && (Mem_Write =='b1) ) 
                                begin
                                    next_state = WRITING;
                                    stall='b1;
                                end

                            else
                                begin
                                    next_state =IDLE;
                                    stall='b0;

                                end
                          end
           
           READING      : begin         
                                    next_state    = MOVE_TO_CACHE;
                                    move_from_mem = 'b1;
                                    move_to_cache = 'b1;
                                    stall         = 'b1;  /*****/
                                    counter_enable= 'b1;  
                            end
           
           MOVE_TO_CACHE  : begin
                             
                           if(counter == 3'b100) 
                                begin
                                    next_state      = IDLE;
                                    read_from_cache = 'b1;
                                    stall           = 'b0;
                                    counter_enable  = 'b0;
                                    move_from_mem   = 'b0;
                                    move_to_cache   = 'b0;
                                end
                           else if(counter == 3'b011) 
                                begin
                                    next_state      = MOVE_TO_CACHE;
                                    read_from_cache = 'b0;
                                    stall           = 'b1;
                                    counter_enable  = 'b1;
                                    move_from_mem   = 'b0;
                                    move_to_cache   = 'b1;
                                end
                           else  
                                begin
                                    next_state    = MOVE_TO_CACHE;
                                    move_from_mem = 'b1;
                                    move_to_cache = 'b1;
                                    stall         = 'b1;
                                    counter_enable= 'b1;  
                                end                            
                            end

           WRITING      : begin 
                            counter_enable='b1;

                           if(check_Miss_hit )      // 1 hit       0 Miss 
                                 begin
                                    write_in_cache ='b1;
                                    write_in_mem   ='b1;
                                    stall          ='b1; 
                                    next_state     =STALL;
                                 end
                           else  
                                begin
                                    write_in_cache ='b0;
                                    write_in_mem   ='b1;
                                    stall          ='b1;
                                    next_state     =STALL;   
                                end                            
                              end

            STALL      : begin
                    counter_enable  ='b1;

                            if(counter == 'b100)
                                begin
                                    stall='b0;
                                    write_in_cache='b0;
                                    write_in_mem='b0;
                                    next_state =IDLE;
                                    counter_enable  ='b0;          
                                end
                            else
                                begin
                                    stall='b1;
                                    write_in_cache='b0;
                                    write_in_mem='b1;
                                    next_state =STALL;
                                    counter_enable  ='b1;        
                                 end
                          end 

            default     : begin
                                write_in_mem    ='b0;
                                write_in_cache  ='b0;
                                move_from_mem   ='b0;
                                read_from_cache ='b0;
                                stall           ='b0;
                                counter_enable  ='b0;
                                next_state      =IDLE;
                            end
        endcase
    end
endmodule