module cache_Memory_top (
    input  wire          clk,rst,
    input  wire          Mem_Write,Mem_Read,
    input  wire  [9:0]   Word_address,
    input  wire  [31:0]  Data_In,

    output wire          stall,
    output wire  [31:0]  Data_Out 
) ;

/***********************************/
wire         check_Miss_hit;
wire         write_in_mem,write_in_cache;
wire         move_from_mem;
wire         move_to_cache;
wire         read_from_cache; 

cache_controller u0(
    .clk(clk),
    .rst(rst),
    .Mem_Write(Mem_Write),
    .Mem_Read(Mem_Read),
    .check_Miss_hit(check_Miss_hit),
    
    .write_in_mem(write_in_mem),
    .write_in_cache(write_in_cache),
    .move_from_mem(move_from_mem),
    .move_to_cache(move_to_cache),
    .read_from_cache(read_from_cache),
    .stall(stall)
);

/************************************/
wire  [31:0]     data;

cache_Memory u1(
    .clk(clk),
    .rst(rst),
    .Word_address(Word_address),
    .data(data),
    .Data_IN(Data_In),
    .write_in_cache(write_in_cache),
    .read_from_cache(read_from_cache),
    .move_to_cache(move_to_cache),          

    .check_Miss_hit(check_Miss_hit),
    .Data_Out(Data_Out) 
);

/************************************/

data_memory u2(
    .clk(clk),
    .rst(rst),    
    .Word_address(Word_address),              
    .Data_In(Data_In),   
    .write_in_mem(write_in_mem),    
    .move_to_cache(move_from_mem),
    
    .data(data)    
);

endmodule