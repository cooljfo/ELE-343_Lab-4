--================ tb_alu.vhd =================================
-- ELE-340 Conception des systèmes ordinés
-- ETE 2007, Ecole de technologie supérieure
-- Chakib Tadj
-- =============================================================
-- Description: 
--   testbench pour tester alu_32.vhd
--   les donnees sont lues de data_in.txt
--   la sortie est dirigee vers data_out.txt
-- =============================================================

LIBRARY ieee;
LIBRARY std;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_textio.all;
--USE ieee.std_logic_textio;
USE std.textio.all;

USE WORK.txt_util.ALL;
--USE WORK.mypackage.ALL;

ENTITY tb_alu IS -- l'entité du testbench est vide
   GENERIC (ALU_SIZE: integer := 31); --Constante pour le nombre de bit de L'ALU dans le testbench
END tb_alu;

ARCHITECTURE tb_alu_arch OF tb_alu IS -- architecture composée de trois process
COMPONENT alu_32                      --déclaration du composant utilisé
   GENERIC (ALU_SIZE: integer := 31); --Constante pour le nombre de bit de L'ALU
PORT (
      SrcA, SrcB: IN STD_LOGIC_VECTOR (ALU_SIZE downto 0); -- Entrée source A et source B du testBench 
      ALUControl : IN STD_LOGIC_VECTOR (3 downto 0);       -- Entrée pour les commandes de l'ALU
      c_out: OUT STD_LOGIC;				   -- Sortie de la retenue de l'additionneur
      result: OUT STD_LOGIC_VECTOR (ALU_SIZE downto 0);    -- Résultat de l'opération de l'ALU
      zero: out std_logic				   -- Sortie pour savoir si le résultat vaut zéro
     ); END COMPONENT;


SIGNAL SrcA,SrcB        : std_logic_vector(ALU_SIZE downto 0);  --Signaux entre les entrées SrcA et SrcB du testbench vers l'ALU
SIGNAL result           : std_logic_vector(ALU_SIZE downto 0);  --Signal entre le résultat de l'ALU et la sortie du testbench
SIGNAL ALUControl 	: std_logic_vector(3 downto 0);         --Signal entre l'entrée du testbench ALUControl et l'entrée pour les commandes de l'ALU
SIGNAL c_out      	: std_logic;				--Signaux entre la retenue de l'additionneur de l'ALU et et celui du testbench
SIGNAL zero		: std_logic;			        --Signal pour savoir si le résultat est zéro entre l'ALU et le testbench
SIGNAL clk	        : std_logic;	                        --Signal entre les modules pour l'horloge du circuit

SIGNAL   OpType: STRING(1 to 3);			        --Signal qui défini en mot le type d'opération pour le fichier de sortie


-- déclaration de la constante contrôlant la période de l'horloge.
CONSTANT PERIODE: time:=20 ns;

BEGIN -- de l'architecture tb_alu_arch
   
    alu32 : alu_32    --Instantiation du composant de l'ALU
    PORT MAP(SrcA=>SrcA,SrcB=>SrcB,ALUControl=>ALUControl,c_out=>c_out,result=>result,zero=>zero); --Lien entre le testbench et l'ALU


------------------------------------------------------------------
PROCESS -- process (#1) : circuit l'horloge
BEGIN
   clk<='1';
   WAIT FOR PERIODE/2;
   clk<='0';
   WAIT FOR PERIODE/2;
END PROCESS;

------------------------------------------------------------------
PROCESS(ALUControl) -- process (#2) pour l'esthetique. On peut s'en passer!
BEGIN
  Case ALUControl is  -- Plus agreable pour le fichier de sortie!
   when X"0"    =>  OpType  <= "AND"; --Operation ET logique
   when X"1"    =>  OpType  <= "OR "; --Operation OU logique
   when X"2"    =>  OpType  <= "ADD"; --Operation ADD logique
   when X"6"    =>  OpType  <= "SUB"; --Operation SUB logique
   when X"7"    =>  OpType  <= "SLT"; --Operation ET logique
   when Others  =>  OpType  <= "---";  --illegal
 END Case;
END PROCESS;


------------------------------------------------------------------
PROCESS -- process (#3) principal de test 

   FILE data_txt: TEXT OPEN READ_MODE IS "data_in.txt";   --Fichier d'entrée lu par le testbench
   FILE data_out: TEXT OPEN WRITE_MODE IS "data_out.txt"; --Fichier de sortie du testbench

   VARIABLE ligne_texte, ligne_texte2: line; 			             --Variables qui storent les lignes lus dans le fichier d'entrée
   VARIABLE ALUControl_stimuli       : std_logic_vector(3 downto 0);         --Variable qui store l'opération lu dans le fichier d'entrée
   VARIABLE SrcA_stimuli,SrcB_stimuli: std_logic_vector (ALU_SIZE downto 0); --Variables qui storent les opérandes lus dans le fichier d'entrée
   VARIABLE resultat_theorique       : std_logic_vector (ALU_SIZE downto 0); --Variable qui store le résultat théorique lu dans le fichier d'entrée
   VARIABLE Une_Erreur               : std_logic:='0';			     --Variable pour savoir s'il y a une erreur 
   
   VARIABLE operation_ok: boolean;					     --Variable retourné lorsqu'un opération est réussi	
   VARIABLE char_pour_espace: character;				     --Variable pour storer un espace lu
BEGIN 
   SrcA<=(others=>'0');       -- ou SrcA<=("00000000");			     --Initialisation de SrcA à 0
   SrcB<=(others=>'0');       -- ou SrcB<=("00000000");			     --Initialisation de SrcA à 0
   WAIT FOR PERIODE;							     --Attendre pour prochaine période
--Boucle pour lecture fichier
   w1:WHILE NOT ENDFILE(data_txt) LOOP                   --Tant que le fichier n'a pas fini d'être lu
      READLINE(data_txt,ligne_texte);			 --lecture d'une ligne
      hread(ligne_texte,ALUControl_stimuli,operation_ok);--lecture du chant ALUControl dans la ligne lu, retourne une valeur selon la reussite ou l'échec de l'opération 
      NEXT WHEN NOT operation_ok;			 --On veut ignorer les commantaire
           read (ligne_texte,char_pour_espace);          --lecture espace
	   hread(ligne_texte,SrcA_stimuli);		 --lecture de l'opérande A
           read(ligne_texte,char_pour_espace);           --lecture espace
	   hread(ligne_texte,SrcB_stimuli);              --lecture de l'opérande B
	   read(ligne_texte,char_pour_espace);           --lecture espace
           hread(ligne_texte,resultat_theorique);        --lecture du résultat théorique
           ALUControl <= ALUControl_stimuli;             --Attribution de la commande lu vers l'ALU
	   SrcA       <= SrcA_stimuli;                   --Attribution de l'opérande A lu vers l'ALU
	   SrcB	      <= SrcB_stimuli;			 --Attribution de l'opérande B lu vers l'ALU
	   WAIT FOR PERIODE;				 --Attendre pour prochaine période
              
           ASSERT (result/=resultat_theorique )                   --On regarde s'il y a un erreur
           REPORT "Operation reussie. Resultat = " & hstr(result) --Si non, on rapporte que l'opération est réussie
           SEVERITY note;

           ASSERT (result=resultat_theorique )		          --On regarde si le résultat est égale au résultat théorique
           REPORT "ECHEC. Resultat = " & hstr(result)             --Si non, on rapport une echec
           SEVERITY note;
       
           if (result=resultat_theorique) THEN	     --Si le résultat calculé est égale au résultat théorique
                  				     -- On ecrit dans une ligne selon le format suivant : 			
                 write(ligne_texte2,Optype & " "     --Opération	  		
                       &hstr(SrcA_stimuli)&" " 	     --Opérande A
                       &hstr(SrcB_stimuli)&" "       --Opérande B
                       &hstr(resultat_theorique)&" " --Résultat théorique 
	               &hstr(result) & " : SUCCES"); -- résultat calculé : Succès 
	         Une_Erreur := '0';	             --On met la variable d'erreur à?0         
           else					     --Si le résultat calculé n'est pas égale au résultat théorique
                 				     -- On ecrit dans une ligne selon le format suivant :
                 write(ligne_texte2,Optype & " "     --Opération
                       &hstr(SrcA_stimuli)&" "       --Opérande A
	               &hstr(SrcB_stimuli)&" "       --Opérande B
                       &hstr(resultat_theorique)&" " --Résultat théorique
	               &hstr(result) & " : ECHEC");  --résultat calculé : echec
                 Une_Erreur := '1';                  --On met la variable d'erreur à?1 
           end if; 
           writeline(data_out, ligne_texte2);	     --On écrit dans le fichier de sortie la ligne contenant toute l'information sur l'opération effectuée   
     END LOOP w1;
     ASSERT (Une_Erreur='1') 			     				     --On regarde s'il y a un erreur.
         REPORT "testbench pour full_adder_8.vhd termine avec succes" SEVERITY note; --Si non, on rapporte un succès.
     ASSERT (Une_Erreur='0') 				  			     --Si oui
         REPORT "testbench pour full_adder_8.vhd termine avec echec" SEVERITY note;  --On rapporte un echec.

     file_close ( data_txt ); --fermeture du fichier d'entrée
     file_close ( data_out ); --fermeture du fichier de sortie

     WAIT; --le process s'exécute seulement une fois
     
      
      


END PROCESS; --fin du process de test

END tb_alu_arch; --fin de larchitecture

