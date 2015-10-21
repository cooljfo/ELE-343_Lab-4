library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity full_adder is
  port ( 
    a     : in std_logic;
    b     : in std_logic;
    c_i   : in std_logic;

    sum   : out std_logic;
    c_out : out std_logic
  );
end;

architecture rtl of full_adder is

begin

	(c_out,sum) <= unsigned'('0' & a) + unsigned'('0' & b) + unsigned'('0' & c_i);
  
end;
