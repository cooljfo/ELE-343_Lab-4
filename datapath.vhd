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
      PCSrc              : in  std_logic_vector(N downto 0);
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


COMPONENT RegFile --is a 3 port Register File
PORT (clk: in std_logic;
   we3 : in std_logic;
   ra1, ra2, wa3 : in std_logic_vector(4 downto 0);
   wd3 : in std_logic_vector(31 downto 0);
   rd1, rd2 : out std_logic_vector(31 downto 0));
END COMPONENT;

COMPONENT alu_32 
   GENERIC (ALU_SIZE: integer := 31); 				--	Delacration de la constante ALU_SIZE
PORT (
   SrcA, SrcB: IN STD_LOGIC_VECTOR (ALU_SIZE downto 0);	--	entr�es 32 bits 
   ALUControl : IN STD_LOGIC_VECTOR (3 downto 0);		--	entr�es qui dictent le comportement de l'ALU
   c_out: OUT STD_LOGIC;								--	sortie de la retenue de l'additionneur
   result: OUT STD_LOGIC_VECTOR (ALU_SIZE downto 0);	--	resultat de l'ALU
   zero: out std_logic); 								--	sortie pour savoir si le resultat vaut 0
END COMPONENT;

COMPONENT DFF
generic(
	 INPUT_LENGTH: integer := 31
        );
  Port ( D          : in  STD_LOGIC_VECTOR(INPUT_LENGTH DOWNTO 0);
         clk        : in  STD_LOGIC;
         reset      : in  STD_LOGIC; 
         Q          : out STD_LOGIC_VECTOR(INPUT_LENGTH DOWNTO 0)
       );
END COMPONENT;

SIGNAL PCPlus4: std_logic_vector(31 downto 0);
SIGNAL PCJump: std_logic_vector(31 downto 0);
SIGNAL PCNextbr: std_logic_vector(31 downto 0);
SIGNAL PCNext: std_logic_vector(31 downto 0);
SIGNAL SignImm: std_logic_vector(31 downto 0);
SIGNAL PCBranch: std_logic_vector(31 downto 0);
SIGNAL MemWrite: std_logic;
SIGNAL WriteReg: std_logic;
SIGNAL SrcA : std_logic_vector(31 downto 0);
SIGNAL rd2 : std_logic_vector(31 downto 0);
SIGNAL SrcB: std_logic_vector(31 downto 0);
SIGNAL Result: std_logic_vector(31 downto 0);




BEGIN 

SignImm <= std_logic_vector(resize(signed(Instruction(15 downto 0)), SignImm'length));

U1:  full_adder_32 PORT MAP (?,"0100",PCPlus4);
U2:  mux32 PORT MAP ((PCPlus4(31 downto 28)) & (Instruction(25 downto 0) sll 2),PCNextbr,Jump,PCNext);
U3:  full_adder_32 PORT MAP (PCPlus4,(SignImm sll 2),PCBranch);
U4:  mux32 PORT MAP ((PCPlus4,PCBranch,PCSrc,PCNextbr);
U6:  mux32 GENERIC MAP (N => 5) PORT MAP (Instruction(20 downto 16),Instruction(15 downto 11),RegDst,WriteReg);
U7:  regfile PORT MAP(clk,RegWrite,Instruction(25 downto 21),Instruction(20 downto 16),WriteReg,Result,SrcA,rd2);
U8:  mux32 PORT MAP (rd2,SignImm,ALUSrc,SrcB);
U9:  alu_32 PORT MAP (SrcA,SrcB,AluControl,open,AluResult,Zero);
U10: mux32 PORT MAP (ReadData,rd2,MemtoReg,Result);
U11: DFF PORT MAP (PCNext,clk,reset,PC);

end DataPath_archi;



