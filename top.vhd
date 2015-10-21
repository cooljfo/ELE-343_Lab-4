library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all ;
use work.mypackage.all;

entity top is 
  port(
    clk       : in  std_logic;
    reset     : in  std_logic;

    memRead   : out std_logic;
    memWrite  : out std_logic;
    pc        : out std_logic_vector(31 downto 0);
    writeData : out std_logic_vector(31 downto 0);
    dataAddr  : out std_logic_vector(31 downto 0)
  ); 
  end;

architecture rtl of top is

begin
  
end;
