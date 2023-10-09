module instruction_memory #( parameter DATA_WIDTH=32 )
 (
    input  wire     [DATA_WIDTH-1:0] pc,
    output reg      [DATA_WIDTH-1:0] instr
);

reg [DATA_WIDTH-1:0] instr_mem [0:DATA_WIDTH-1];

 initial
    begin
   $readmemh ("instruction_mem.txt",instr_mem);
    end

always@(*)
 begin
    instr =instr_mem[pc>>2];
  end
  
endmodule
