module RISC_V_testbench();

parameter DATA_WIDTH=32,
          CLOCK_PERIOD=10;  

//signals
reg  clk_tb;
reg  rst_tb;

initial
 begin
   $dumpfile("RISC-V .vcd");
   $dumpvars;   

clk_tb ='b0;
rst_tb ='b0; 

#CLOCK_PERIOD;
rst_tb ='b1;

repeat(500)
  begin
    #CLOCK_PERIOD;
  end
$stop;

 end


//clock generator 
always #(CLOCK_PERIOD/2) clk_tb=~clk_tb;



//design instantation
RISC_V #(.DATA_WIDTH(DATA_WIDTH))
 DUT (
       .clk(clk_tb),
       .rst(rst_tb)
);

endmodule
