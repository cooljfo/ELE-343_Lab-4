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
COMPONENT instruction_memory 											--	Déclaration de logic PC
   port (
    pc          : in  unsigned(31 downto 0);-- adresse d'accés à la mémoire envoyée par le MIPS de 6 bits
    
    instruction : out std_logic_vector(31 downto 0)
  ); END COMPONENT;

COMPONENT data_memory
  port (
    clk       : in std_logic;
    memWrite  : in std_logic;
    memRead   : in std_logic;  
    address   : in std_logic_vector(31 downto 0); 
    writeData : in std_logic_vector(31 downto 0); 
    
    readData  : out std_logic_vector(31 downto 0)
  ); END COMPONENT;

COMPONENT mips 
port (
    clk         : in  std_logic;
    reset       : in  std_logic;
    instruction : in  std_logic_vector(31 downto 0);
    data        : in  std_logic_vector(31 downto 0);

    controlBus  : out controlBus_t;
    result      : out std_logic_vector(31 downto 0);
    pc          : out unsigned(31 downto 0);
    regToData   : out std_logic_vector(31 downto 0)
  );
   END COMPONENT;
signal s_pc                        : unsigned(31 downto 0);
signal s_instruction		   : std_logic_vector(31 downto 0);
signal s_data,s_result,s_regToData : std_logic_vector(31 downto 0);
signal s_controlBus	           : controlBus_t;

begin
  
imem : instruction_memory 
port map(s_pc,s_instruction);
mips1 : mips
port map(clk,reset,s_instruction,s_data,s_controlBus,s_result,s_pc,s_regToData);
dmem : data_memory
port map(clk,s_controlBus.memWrite,s_controlBus.memRead,s_result,s_regToData,s_data);

memRead  <= s_controlBus.memRead;
memWrite <= s_controlBus.memWrite;
pc 	 <= std_logic_vector(s_pc);
writeData<=s_regToData;
dataAddr <= s_result;
end;
