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
      MemtoReg, MemWrite, MemRead : out std_logic;
      PCSrc, AluSrc               : out std_logic;
      RegDst, RegWrite            : out std_logic;
      Jump                        : out std_logic;
      AluControl                  : out std_logic_vector(3 downto 0)
  end record;

end mypackage;