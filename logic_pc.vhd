library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mypackage.all;

entity logic_pc is                                    -- Entite logic_pc
  port (                                              -- Declaration des inputs / outputs de l'entite logic_pc
    clk         : in  std_logic;
    reset       : in  std_logic;
    instruction : in  std_logic_vector(31 downto 0);
    controlBus  : in  controlBus_t;     
    pc          : out unsigned(31 downto 0)
  ); 
end;

architecture rtl of logic_pc is                       -- Architecture logic_pc
-- Declaration des signaux
signal signImm,signImmSh,pcBranch,pcJump,pcPlus4,s_pc  : unsigned (31 downto 0):= (others =>'0');
signal s_instruction25_0                               : unsigned (25 downto 0):= (others =>'0');
signal s_instruction27_0		               : unsigned (27 downto 0):= (others =>'0');
signal s_instruction15_0                               : unsigned (15 downto 0):= (others =>'0');
 	 

begin 
--Assignation des différentes longueurs du signal instruction pour les équations du PC.
s_instruction25_0 <= unsigned(instruction(25 downto 0));
s_instruction15_0 <= unsigned(instruction(15 downto 0));


--Extension de signe du signal des 16 premiers bits de l'instruction(16 bits à 32 bits).
signImm           <= unsigned(resize(signed(s_instruction15_0), signImm'length));

--On shift de 2 bits à gauche le signal de 32 bits des 16 premiers bits de l'instruction
signImmSh         <= signImm sll 2;

--L'extension de signe pour les 26 premiers bits de l'instruction pour pouvoir shiftés de 2 à gauche
s_instruction27_0 <= unsigned(resize(unsigned(s_instruction25_0), s_instruction27_0'length));

--L'équation pour le PC en mode normal. On doit seulement ajouter 4 au dernier PC.
pcPlus4           <= s_pc+4;
-- L'équation pour le PC en mode jump. On doit concatèné les 4 bits significatif du PC+4 avec les
--26 premiers bits de l'instruction qui sont shiftés de deux vers la gauche pour obtenir un signal de 28 bits.
pcJump 		  <= pcPlus4(31 downto 28) &(s_instruction27_0 sll 2); 

--L'équation pour le PC en mode branch. On doit ajouter au PC+4 le signal de 32 bits du signal des 16 premiers bits
--de l'instruction qui a eu un extension de signe.
pcBranch          <= signImmSh + pcPlus4 ;
--Mise à jour du PC à chaque coup de clock
 process (clk)
  begin
    --Choix du mode pour le prochain PC qui est controlé par les signaux pcSrc et jump qui font partie du controlBus
    if (rising_edge(clk) and reset = '1') then
        if   (controlBus.pcSrc = '0' AND controlBus.jump ='0') then
          -- Mode normal
          pc   <= pcPlus4;
	  s_pc <= pcPlus4;
	elsif(controlBus.pcSrc = '1' AND controlBus.jump ='0') then  
	  --Mode branch
 	  pc   <= pcBranch;
	  s_pc <= pcBranch;
        else
          --Mode jump
          pc   <= pcJump;
	  s_pc <= pcJump;
        end if;
    end if;
    if (rising_edge(clk) and reset = '0') then
        --Le reset est comparé avec le clock, donc il est synchrone
    	--On met le PC et son signal à 0 puisqu'il a un reset
        pc <= (others => '0' );
        s_pc <= (others => '0' );
    end if;
  end process;
end;
