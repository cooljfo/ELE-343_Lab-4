library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all ;

entity alu_generic is 
  generic(
    alu_size: integer := 32
  ); 
  port(
    srcA       : in  std_logic_vector(alu_size-1 downto 0);
    srcB       : in  std_logic_vector(alu_size-1 downto 0);
    aluControl : in  std_logic_vector(3 downto 0);
    
    c_out      : out std_logic;
    result     : out std_logic_vector (alu_size-1 downto 0);
    zero       : out std_logic
  );
end;

architecture rtl of alu_generic is
  alias  b_inv   : std_logic is alucontrol(2);

  signal c_v     : std_logic_vector(alu_size downto 0);
  signal less_v  : std_logic_vector(alu_size-1 downto 0);
  signal set_v   : std_logic_vector(alu_size-1 downto 0);
  signal result_i: std_logic_vector(alu_size-1 downto 0);
begin

  c_v(c_v'low) <= b_inv;
  
  less_v <= (less_v'high downto less_v'low+1=>'0') & set_v(set_v'high);
  
  gen_code_label: for index in alu_size-1 downto 0 generate  
    begin  

    alu_1_inst : entity work.alu_1
    port map(
      a          =>srca(index),
      b          =>srcb(index),
      c_in       =>c_v(index),
      less       =>less_v(index),
      alucontrol =>alucontrol,
      c_out      =>c_v(index+1),
      result     =>result_i(index),
      set        =>set_v(index)
    ); 
  end generate; 
  
  c_out <= c_v(c_v'high);
  zero <= '1' when (result_i = (result_i'range=>'0')) else '0';
  result <= result_i;
  
end;
