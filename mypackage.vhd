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
      MemtoReg, MemWrite, MemRead :  std_logic;
      PCSrc, AluSrc               :  std_logic;
      RegDst, RegWrite            :  std_logic;
      Jump                        :  std_logic;
      AluControl                  :  std_logic_vector(3 downto 0);
  end record;

end mypackage;