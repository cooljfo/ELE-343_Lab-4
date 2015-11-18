library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all ;
use work.mypackage.all;

entity mips is                                        -- Entity MIPS  
  port (                                              -- Declaration des inputs / outputs du MIPS
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

architecture rtl of mips is		              -- Architecture du MIPS 
COMPONENT datapath                                    -- Declaration des inputs / outputs de la composante datapath
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

COMPONENT controller                                  -- Declaration des inputs / outputs de la composante controller
  PORT (
    zero        : in  std_logic;
    instruction : in  std_logic_vector(31 downto 0);
    controlBus  : out controlBus_t
  ); END COMPONENT;
                                                      -- Declaration des signaux
SIGNAL szero         : std_logic;
SIGNAL bits_controle : controlBus_t;

begin                                                 -- Connections entre les composants
  datapath_1: datapath PORT MAP (clk,reset,instruction,data,bits_controle,pc,szero,result,regToData);
  controller_1: controller PORT MAP (szero,instruction,bits_controle);
  controlBus <= bits_controle;

end;

