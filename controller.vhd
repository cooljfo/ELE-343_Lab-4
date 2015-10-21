library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mypackage.all;

entity controller is 
  port (
    zero        : in  std_logic;
    instruction : in  std_logic_vector(31 downto 0);

    controlBus  : out controlBus_t
  );
end;

architecture rtl of controller is
  
begin
  
end;