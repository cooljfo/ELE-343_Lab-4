library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mypackage.all;

entity logic_registre is                              -- Entite logic_registre
  port (                                              -- Declaration des inputs / outputs de l'entite logic_registre
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

architecture rtl of logic_registre is                 -- Architecture logic_registre
-- Declaration des signaux
signal s_data,s_result,s_writeData            :std_logic_vector(31 downto 0):= (others =>'0');
signal s_regData1,s_regData2		              :std_logic_vector(31 downto 0):= (others =>'0');
signal s_instr25_21,s_instr20_16,s_instr15_11 :std_logic_vector( 4 downto 0):= (others =>'0');
signal s_writeAddr			                      :std_logic_vector( 4 downto 0):= (others =>'0');
signal s_instr15_0			                      :std_logic_vector(15 downto 0):= (others =>'0');
signal s_signExtend_Instr15_0                 :unsigned(31 downto 0):= (others =>'0');
signal s_regWrite                             :std_logic;
begin

-- Connections des signaux
s_regWrite     <=controlBus.regWrite;
s_result       <=result;
s_data 	       <=data;
s_instr25_21   <=instruction(25 downto 21);
s_instr20_16   <=instruction(20 downto 16);
s_instr15_11   <=instruction(15 downto 11);
s_instr15_0    <=instruction(15 downto 0);
regToData <= s_regData2;

--Extension de signe des 15 premier bit de l'instruction (16 bits a 32 bits)
s_signExtend_Instr15_0 <= unsigned(resize(signed(s_instr15_0), s_signExtend_Instr15_0'length));

--Entrée writeAddr du regfile  controlé par RegDst compris dans le controlBus_t
s_writeAddr <= s_instr20_16 when controlBus.regDst   = '0' else
               s_instr15_11 when controlBus.regDst   = '1';
               
--Entrée writeData du regfile  controlé par memToReg compris dans le controlBus_t
s_writeData <= s_result     when controlBus.memToReg = '0' else
               s_data       when controlBus.memToReg = '1';

srca <= s_regData1;
--sortie srcB du module selon le MUX contrôlé par ALUSrc compris dans le controlBus_t
srcb <= s_regData2                               when controlBus.ALUSrc = '0' else
        std_logic_vector(s_signExtend_Instr15_0) when controlBus.ALUSrc = '1';

-- assignation des inputs/outputs du regfile
  regfile_ins1 : entity work.regfile
  port map(
    clk,
    s_regWrite, 
    s_instr25_21,
    s_instr20_16,
    s_writeAddr,
    s_writeData,
    s_regData1,
    s_regData2    
  );
end;
