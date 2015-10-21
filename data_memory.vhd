library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_memory is --mémoire de donnée
  port (
    clk       : in std_logic;
    memWrite  : in std_logic;
    memRead   : in std_logic;  
    address   : in std_logic_vector(31 downto 0); 
    writeData : in std_logic_vector(31 downto 0); 
    
    readData  : out std_logic_vector(31 downto 0)
  );
end; -- dmem;

architecture rtl of data_memory is

constant mem_size : integer := 128;-- la mémoire disopse de 64 cases mémoire de 32 bits chacun
type ramtype is array (mem_size-1 downto 0) of std_logic_vector (7 downto 0);
signal mem : ramtype;-- déclaration d ela mémoire de taille 64 et contenant des mots de 32 bits

begin
  process (clk)
  begin 
    if (rising_edge(clk)) then-- l'écriture est synchrone avec la clock
      if (MemWrite = '1') then 
        mem(to_integer(unsigned(address)))   <= WriteData(31 downto 24);
        mem(to_integer(unsigned(address))+1) <= WriteData(23 downto 16);
        mem(to_integer(unsigned(address))+2) <= WriteData(15 downto 8);
        mem(to_integer(unsigned(address))+3) <= WriteData(7 downto 0);
      end if;
    end if;
  end process;
   
  readData <= mem(to_integer(unsigned(address))) & mem(to_integer(unsigned(address))+1) & mem(to_integer(unsigned(address))+2) & mem(to_integer(unsigned(address))+3) when MemRead='1';
    
end;