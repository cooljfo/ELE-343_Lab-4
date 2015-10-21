library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mypackage.all;

entity logic_registre is
  port (
    clk         : in  std_logic;
    instruction : in  std_logic_vector(31 downto 0);
    controlBus  : in  controlBus_t;
    result      : in  std_logic_vector(31 downto 0);
    data        : in  std_logic_vector(31 downto 0);

    srca        : out std_logic_vector(31 downto 0);
    srcb        : out std_logic_vector(31 downto 0);
    regToData   : out std_logic_vector(31 downto 0)
  );
end;

architecture rtl of logic_registre is

begin

end;