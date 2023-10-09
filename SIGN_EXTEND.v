module sign_extend (
input   wire   [31:7] instr_unextend,
input   wire   [1:0]  imm_src,
output  reg    [31:0]  instr_extend
);

always@(*) 
  begin
    case (imm_src)
    2'b00: instr_extend = {{20{instr_unextend[31]}},instr_unextend[31:20]};
    2'b01: instr_extend = {{20{instr_unextend[31]}},instr_unextend[31:25],instr_unextend[11:7]};  
    2'b10: instr_extend = {{20{instr_unextend[31]}},instr_unextend[7],instr_unextend[30:25],instr_unextend[11:8],1'b0};
    2'b11: instr_extend = {{12{instr_unextend[31]}},instr_unextend[19:12],instr_unextend[20],instr_unextend[30:21],1'b0};
    endcase
  end 
endmodule
