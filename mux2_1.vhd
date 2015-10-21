library ieee;
use ieee.std_logic_1164.all;

entity mux2_1 is
  port(
    i0   : in  std_logic;
    i1   : in  std_logic;
    ctrl : in  std_logic;
    
    q    : out std_logic
  );
end;

architecture rtl of mux2_1 is
begin

  q <= i0 when (ctrl='0') else i1; 
 
end;