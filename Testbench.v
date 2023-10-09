module cache_Memory_tb();

//parameters
parameter CLOCK_PERIOD = 10;

//signals
reg             clk,rst;
reg             Mem_Write,Mem_Read;
reg   [9:0]     Word_address;
reg   [31:0]    Data_In;
wire            stall;
wire  [31:0]    Data_Out; 

initial
  begin
    $dumpfile("Cache Memory.vcd");
    $dumpvars;

    initiaize();

    /***********************************       testcases     ****************************************/

      /* senario writing in block and check the reading operations of them miss first then all hit */
          /** write operations **/

  write_data('b111_00010_01 ,'d16  );
  write_data('b111_00010_10 ,'d8  );
  write_data('b111_00010_00 ,'d4  );
  write_data('b111_00010_11 ,'d2  );


          /** read operations **/
 
  read_data ('b111_00010_11);
  read_data ('b111_00010_10);
  read_data ('b111_00010_01);
  read_data ('b111_00010_00);
  
  
      /* senario writing in block exist in cache and check the writing operations of them hit and store in cache and memory in same time */
          /** write operations **/

  write_data('b111_00010_01 ,'d100  );
  write_data('b111_00010_10 ,'d120  );

         /** read operations **/
  
  read_data ('b111_00010_00);
  read_data ('b111_00010_01);
  read_data ('b111_00010_10);
  read_data ('b111_00010_11);
  
  
    /* senario addressing same block different in tag with different values */
          /** write operations **/
  
  write_data('b101_00010_01 ,'d200  );
  write_data('b101_00010_10 ,'d220  );

        /** read operations **/

  read_data ('b101_00010_00);
  read_data ('b101_00010_01);
  read_data ('b101_00010_10);
  read_data ('b111_00010_11);
  read_data ('b111_00010_01);
 

    /*******************  Random processes ******************/
             /** write operations **/

  write_data('b000_00110_01 ,'d60  );  // Block 6    tag =0  ofsset=1
  write_data('b011_01010_01 ,'d100 );  // Block 10   tag =3  offset=1
  write_data('b010_00111_01 ,'d20  );  // Block 2    tag=2   offset=1
  write_data('b110_10010_10 ,'d60  );  // Blcok 18   tag=6   offset=2                   /*******/
  write_data('b000_01011_00 ,'d110 );  // BLock 11   tag =0  offset=0 
  write_data('b101_10010_11 ,'d200 );  // Block 18   tag=5   offset=3 
  write_data('b001_00000_11 ,'d1000);  // Block 0    tag =1  offset=3 
  write_data('b001_10011_01 ,'d190 );  // Block 19   tag =1  offset=1 
  write_data('b111_11010_10 ,'d260 );  // Block 26   tag =7  offset=2


        /** read operations **/
  
  read_data ('b000_00110_01);
  read_data ('b011_01010_01);
  read_data ('b010_00111_01);
  read_data ('b110_10010_10);
  read_data ('b110_10010_10);
  read_data ('b000_01011_00);
  read_data ('b101_10010_11);
  read_data ('b001_00000_11);
  read_data ('b001_10011_01);
  read_data ('b111_11010_10);
  

  repeat(12)
  #CLOCK_PERIOD;
  $stop;

  end

//task to read operation 
task read_data (input [9:0] task_address);
  begin
  Mem_Read  ='b1;
  Mem_Write ='b0;
  Word_address = task_address;  
  #CLOCK_PERIOD;
  Mem_Read  ='b0;    
  repeat(6)
  #CLOCK_PERIOD;
  end
endtask

//task to write operation
task write_data (input [9:0] task_address, input [31:0] task_write_data);
  begin
  Mem_Write ='b1;
  Mem_Read  ='b0;
  Word_address=task_address;
  Data_In     =task_write_data;
  #CLOCK_PERIOD;
  Mem_Write ='b0;    
  repeat(6)
  #CLOCK_PERIOD;
end
endtask

//task to initialize clk & rst
task initiaize ();
   begin
        clk= 'b0;
        rst= 'b1;
      #CLOCK_PERIOD;
        rst= 'b0;
      #CLOCK_PERIOD;
        rst= 'b1;    
   end
endtask



// clock generator 
always #(CLOCK_PERIOD/2) clk=~clk ;

// module instantation
 cache_Memory_top DUT(
    .clk(clk),
    .rst(rst),
    .Mem_Write(Mem_Write),
    .Mem_Read(Mem_Read),
    .Word_address(Word_address),
    .Data_In(Data_In),
    .stall(stall),
    .Data_Out(Data_Out) 
  ) ;

endmodule
