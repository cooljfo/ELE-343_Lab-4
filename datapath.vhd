library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mypackage.all;

entity datapath is 
  port (
    clk         : in  std_logic;
    reset       : in  std_logic;
    instruction : in  std_logic_vector(31 downto 0);
    data        : in  std_logic_vector(31 downto 0);
    controlBus  : in  controlBus_t;

    pc          : out unsigned(31 downto 0);
    zero        : out std_logic;
    result      : out std_logic_vector(31 downto 0);
    regToData   : out std_logic_vector(31 downto 0)
  ); 
end;

architecture rtl of datapath is 

COMPONENT logic_pc 											--	Déclaration de logic PC
  PORT (
    clk         : in  std_logic;
    reset       : in  std_logic;
    instruction : in  std_logic_vector(31 downto 0);
    controlBus  : in  controlBus_t;
     
    pc          : out unsigned(31 downto 0) 
  ); END COMPONENT;

COMPONENT alu_generic
  PORT (
   SrcA, SrcB: IN STD_LOGIC_VECTOR (31 downto 0);	--	entrées 32 bits 
   ALUControl : IN STD_LOGIC_VECTOR (3 downto 0);		--	entrées qui dictent le comportement de l'ALU
   c_out: OUT STD_LOGIC;								--	sortie de la retenue de l'additionneur
   result: OUT STD_LOGIC_VECTOR (31 downto 0);	--	resultat de l'ALU
   zero: out std_logic									--	sortie pour savoir si le resultat vaut 0
  ); END COMPONENT;

COMPONENT logic_registre 
  PORT (
    clk         : in  std_logic;
    instruction : in  std_logic_vector(31 downto 0);
    controlBus  : in  controlBus_t;
    result      : in  std_logic_vector(31 downto 0);
    data        : in  std_logic_vector(31 downto 0);

    srca        : out std_logic_vector(31 downto 0);
    srcb        : out std_logic_vector(31 downto 0);
    regToData   : out std_logic_vector(31 downto 0)
  ); END COMPONENT;

SIGNAL alu_result :  STD_LOGIC_VECTOR (31 downto 0);
SIGNAL alu_srca,alu_srcb: STD_LOGIC_VECTOR (31 downto 0);

begin
  logic_pc1: logic_pc 
  PORT MAP (clk,reset,instruction(31 DOWNTO 0),controlBus,pc);
  logique_Registre1: logic_registre 
  PORT MAP (clk,instruction(31 DOWNTO 0),controlBus,alu_result,data,alu_srca,alu_srcb,regToData);
  alu : alu_generic 
  PORT MAP (alu_srca,alu_srcb,controlBus.aluControl,open,alu_result,zero);

  result <= alu_result;

end;