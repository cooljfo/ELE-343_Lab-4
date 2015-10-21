library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mypackage.all;

entity datapath is 
  port (
    clk         : in  std_logic;
    reset       : in  std_logic;
    instruction : in  std_logic_vector(31 downto 0);
    data        : in  std_logic_vector(31 downto 0);
    controlBus  : in  controlBus_t;

    pc          : out unsigned(31 downto 0);
    zero        : out std_logic;
    result      : out std_logic_vector(31 downto 0);
    regToData   : out std_logic_vector(31 downto 0)
  ); 
end;

architecture rtl of datapath is 
  
begin
  
end;