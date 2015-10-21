library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regfile is --is a 3 port register file
  port(
    clk         : in  std_logic;
    writeEnable : in  std_logic;
    reg1ReadAdr : in  std_logic_vector(4 downto 0);
    reg2ReadAdr : in  std_logic_vector(4 downto 0); 
    writeAdr    : in  std_logic_vector(4 downto 0);
    writeData   : in  std_logic_vector(31 downto 0);
     
    reg1Data    : out std_logic_vector(31 downto 0); 
    reg2Data    : out std_logic_vector(31 downto 0)
  ); 
end;

architecture rtl of regfile is
--déclaration du banc de registre de taille 32 contenant chacun 32 bits
type ramtype is array (31 downto 0) of std_logic_vector(31 downto 0) ;
signal mem : ramtype := (31 downto 1=>(others=>'U'),0=>(others=>'0'));

begin

  -- ecriture synchrone
  process (clk)
  begin
    if (rising_edge(clk)) then
      if (writeEnable = '1' and writeAdr /= (writeAdr'range=>'0')) then
        mem(to_integer(unsigned(writeAdr))) <= writeData;
      end if;
    end if;
  end process;
  
  --lecture asynchrone a completerrrrrrrrrrrrrrrr !!!!!!!!!!!!

end;