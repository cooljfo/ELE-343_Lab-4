LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned. all;


entity DataPath is

generic(
	N: integer := 31
);
port (clk                : in  std_logic;
      reset              : in  std_logic;
      MemtoReg           : in  std_logic;
      PCSrc              : in  std_logic;
      AluSrc             : in  std_logic;
      RegDst             : in  std_logic;
      RegWrite           : in  std_logic;
      Jump               : in  std_logic;
      AluControl         : in  std_logic_vector(3 downto 0);
      Zero               : out std_logic;
      PC                 : out std_logic_vector(N downto 0);
      Instruction        : in  std_logic_vector(N downto 0);
      AluResult          : out std_logic_vector(N downto 0);
      WriteData          : out std_logic_vector(N downto 0);
      ReadData           : in  std_logic_vector(N downto 0)
     );
end Datapath; -- Controller;
