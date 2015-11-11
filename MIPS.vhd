library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all ;
use work.mypackage.all;

entity mips is 
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
end;

architecture rtl of mips is
COMPONENT datapath  
  PORT (
    clk         : in  std_logic;
    reset       : in  std_logic;
    instruction : in  std_logic_vector(31 downto 0);
    data        : in  std_logic_vector(31 downto 0);
    controlBus  : in  controlBus_t;

    pc          : out unsigned(31 downto 0);
    zero        : out std_logic;
    result      : out std_logic_vector(31 downto 0);
    regToData   : out std_logic_vector(31 downto 0)
  ); END COMPONENT;

COMPONENT controller 
  PORT (
    zero        : in  std_logic;
    instruction : in  std_logic_vector(31 downto 0);
    controlBus  : out controlBus_t
  ); END COMPONENT;

SIGNAL szero : std_logic;
SIGNAL bits_controle : controlBus_t;

begin
  datapath_1: datapath PORT MAP (clk,reset,instruction(31 DOWNTO 0),data(31 DOWNTO 0),bits_controle,pc(31 DOWNTO 0),szero,result(31 DOWNTO 0),regToData(31 DOWNTO 0));
  controller_1: controller PORT MAP (szero,instruction(31 DOWNTO 0),bits_controle);
  controlBus <= szero;

end;

