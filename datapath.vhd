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
      PCSrc              : in  std_logic_vector(N downto 0)
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
end Datapath;

architecture DataPath_archi of DataPath is

COMPONENT Controller
PORT (OP, Funct                   : in std_logic_vector(5 downto 0);
      Zero                        : in std_logic;
      MemtoReg, MemWrite, MemRead : out std_logic;
      PCSrc, AluSrc               : out std_logic;
      RegDst, RegWrite            : out std_logic;
      Jump                        : out std_logic;
      AluControl                  : out std_logic_vector(3 downto 0)
     );
END COMPONENT; -- Controller;

COMPONENT imem --single cycle MIPS processor
PORT (aa: in std_logic_vector(5 downto 0);
   rd: out std_logic_vector(31 downto 0));
END COMPONENT; -- imem;

COMPONENT full_adder_32
GENERIC (ADDER_SIZE: integer := 31); -- Il suffit de chager la valeur 7 a 
				     -- celle de la taille de l'ALU desiree!
PORT (a_i, b_i: IN STD_LOGIC_VECTOR (ADDER_SIZE DOWNTO 0); 
     s_o : OUT STD_LOGIC_VECTOR (ADDER_SIZE DOWNTO 0);
     ret_o : OUT STD_LOGIC );
END COMPONENT;

COMPONENT mux32
GENERIC(N: integer := 31);
PORT (InputOne                   : in std_logic_vector(N downto 0);
      InputTwo                   : in std_logic_vector(N downto 0);
      Selecter                   : in std_logic;
      Output                     : out std_logic_vector(N downto 0)
     );
END COMPONENT;

SIGNAL PCPlus4 std_logic_vector(31 downto 0);
SIGNAL PCJump std_logic_vector(31 downto 0);
SIGNAL Instruction std_logic_vector(31 downto 0);
SIGNAL PCNextbr std_logic_vector(31 downto 0);
SIGNAL Jump std_logic;
SIGNAL PCNext std_logic_vector(31 downto 0);
SIGNAL SignImm std_logic_vector(31 downto 0);
SIGNAL PCBranch std_logic_vector(31 downto 0);
SIGNAL PCScr std_logic;


BEGIN 

U1: full_adder_32 PORT MAP (PCSrc,"0100",PCPlus4);
U2: imem PORT MAP (PCSrc(7 downto 2),Instruction);
U3: mux32 PORT MAP ((PCPlus4(31 downto 28)) & (Instruction(25 downto 0) sll 2),PCNextbr,Jump,PCNext);
U4: full_adder_32 PORT MAP (PCPlus4,(SignImm sll 2),PCBranch);
U5: mux32 PORT MAP ((PCPlus4,PCBranch,PCScr,PCNextbr);
U6: Controller PORT MAP (

end DataPath_archi;



