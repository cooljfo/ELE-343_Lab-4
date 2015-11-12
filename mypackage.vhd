--================ mypackage.vhd ===============================
-- Description: 
--	mypackage est utile pour la declaration des components
-- Utilisation:
--	1: compiler mypackage.vhd
--	2: le declarer dans tous les fichiers vhdl
---	   avec: USE WORK.mypackage.ALL;
-- =============================================================

LIBRARY ieee;
USE ieee.std_logic_1164.all;

package mypackage is

  type controlBus_t is record
    regWrite   : std_logic;
    regDst     : std_logic;
    aluSrc     : std_logic;
    pcSrc      : std_logic;
    memRead    : std_logic;
    memWrite   : std_logic;
    memToReg   : std_logic;
    aluControl : std_logic_vector(3 downto 0);
    jump       : std_logic;
  end record;

end mypackage;