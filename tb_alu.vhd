--================ tb_alu.vhd =================================
-- ELE-340 Conception des syst�mes ordin�s
-- ETE 2007, Ecole de technologie sup�rieure
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

ENTITY tb_alu IS -- l'entit� du testbench est vide
   GENERIC (ALU_SIZE: integer := 31); --Constante pour le nombre de bit de L'ALU dans le testbench
END tb_alu;

ARCHITECTURE tb_alu_arch OF tb_alu IS -- architecture compos�e de trois process
COMPONENT alu_32                      --d�claration du composant utilis�
   GENERIC (ALU_SIZE: integer := 31); --Constante pour le nombre de bit de L'ALU
PORT (
      SrcA, SrcB: IN STD_LOGIC_VECTOR (ALU_SIZE downto 0); -- Entr�e source A et source B du testBench 
      ALUControl : IN STD_LOGIC_VECTOR (3 downto 0);       -- Entr�e pour les commandes de l'ALU
      c_out: OUT STD_LOGIC;				   -- Sortie de la retenue de l'additionneur
      result: OUT STD_LOGIC_VECTOR (ALU_SIZE downto 0);    -- R�sultat de l'op�ration de l'ALU
      zero: out std_logic				   -- Sortie pour savoir si le r�sultat vaut z�ro
     ); END COMPONENT;


SIGNAL SrcA,SrcB        : std_logic_vector(ALU_SIZE downto 0);  --Signaux entre les entr�es SrcA et SrcB du testbench vers l'ALU
SIGNAL result           : std_logic_vector(ALU_SIZE downto 0);  --Signal entre le r�sultat de l'ALU et la sortie du testbench
SIGNAL ALUControl 	: std_logic_vector(3 downto 0);         --Signal entre l'entr�e du testbench ALUControl et l'entr�e pour les commandes de l'ALU
SIGNAL c_out      	: std_logic;				--Signaux entre la retenue de l'additionneur de l'ALU et et celui du testbench
SIGNAL zero		: std_logic;			        --Signal pour savoir si le r�sultat est z�ro entre l'ALU et le testbench
SIGNAL clk	        : std_logic;	                        --Signal entre les modules pour l'horloge du circuit

SIGNAL   OpType: STRING(1 to 3);			        --Signal qui d�fini en mot le type d'op�ration pour le fichier de sortie


-- d�claration de la constante contr�lant la p�riode de l'horloge.
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

   FILE data_txt: TEXT OPEN READ_MODE IS "data_in.txt";   --Fichier d'entr�e lu par le testbench
   FILE data_out: TEXT OPEN WRITE_MODE IS "data_out.txt"; --Fichier de sortie du testbench

   VARIABLE ligne_texte, ligne_texte2: line; 			             --Variables qui storent les lignes lus dans le fichier d'entr�e
   VARIABLE ALUControl_stimuli       : std_logic_vector(3 downto 0);         --Variable qui store l'op�ration lu dans le fichier d'entr�e
   VARIABLE SrcA_stimuli,SrcB_stimuli: std_logic_vector (ALU_SIZE downto 0); --Variables qui storent les op�randes lus dans le fichier d'entr�e
   VARIABLE resultat_theorique       : std_logic_vector (ALU_SIZE downto 0); --Variable qui store le r�sultat th�orique lu dans le fichier d'entr�e
   VARIABLE Une_Erreur               : std_logic:='0';			     --Variable pour savoir s'il y a une erreur 
   
   VARIABLE operation_ok: boolean;					     --Variable retourn� lorsqu'un op�ration est r�ussi	
   VARIABLE char_pour_espace: character;				     --Variable pour storer un espace lu
BEGIN 
   SrcA<=(others=>'0');       -- ou SrcA<=("00000000");			     --Initialisation de SrcA � 0
   SrcB<=(others=>'0');       -- ou SrcB<=("00000000");			     --Initialisation de SrcA � 0
   WAIT FOR PERIODE;							     --Attendre pour prochaine p�riode
--Boucle pour lecture fichier
   w1:WHILE NOT ENDFILE(data_txt) LOOP                   --Tant que le fichier n'a pas fini d'�tre lu
      READLINE(data_txt,ligne_texte);			 --lecture d'une ligne
      hread(ligne_texte,ALUControl_stimuli,operation_ok);--lecture du chant ALUControl dans la ligne lu, retourne une valeur selon la reussite ou l'�chec de l'op�ration 
      NEXT WHEN NOT operation_ok;			 --On veut ignorer les commantaire
           read (ligne_texte,char_pour_espace);          --lecture espace
	   hread(ligne_texte,SrcA_stimuli);		 --lecture de l'op�rande A
           read(ligne_texte,char_pour_espace);           --lecture espace
	   hread(ligne_texte,SrcB_stimuli);              --lecture de l'op�rande B
	   read(ligne_texte,char_pour_espace);           --lecture espace
           hread(ligne_texte,resultat_theorique);        --lecture du r�sultat th�orique
           ALUControl <= ALUControl_stimuli;             --Attribution de la commande lu vers l'ALU
	   SrcA       <= SrcA_stimuli;                   --Attribution de l'op�rande A lu vers l'ALU
	   SrcB	      <= SrcB_stimuli;			 --Attribution de l'op�rande B lu vers l'ALU
	   WAIT FOR PERIODE;				 --Attendre pour prochaine p�riode
              
           ASSERT (result/=resultat_theorique )                   --On regarde s'il y a un erreur
           REPORT "Operation reussie. Resultat = " & hstr(result) --Si non, on rapporte que l'op�ration est r�ussie
           SEVERITY note;

           ASSERT (result=resultat_theorique )		          --On regarde si le r�sultat est �gale au r�sultat th�orique
           REPORT "ECHEC. Resultat = " & hstr(result)             --Si non, on rapport une echec
           SEVERITY note;
       
           if (result=resultat_theorique) THEN	     --Si le r�sultat calcul� est �gale au r�sultat th�orique
                  				     -- On ecrit dans une ligne selon le format suivant : 			
                 write(ligne_texte2,Optype & " "     --Op�ration	  		
                       &hstr(SrcA_stimuli)&" " 	     --Op�rande A
                       &hstr(SrcB_stimuli)&" "       --Op�rande B
                       &hstr(resultat_theorique)&" " --R�sultat th�orique 
	               &hstr(result) & " : SUCCES"); -- r�sultat calcul� : Succ�s 
	         Une_Erreur := '0';	             --On met la variable d'erreur �?0         
           else					     --Si le r�sultat calcul� n'est pas �gale au r�sultat th�orique
                 				     -- On ecrit dans une ligne selon le format suivant :
                 write(ligne_texte2,Optype & " "     --Op�ration
                       &hstr(SrcA_stimuli)&" "       --Op�rande A
	               &hstr(SrcB_stimuli)&" "       --Op�rande B
                       &hstr(resultat_theorique)&" " --R�sultat th�orique
	               &hstr(result) & " : ECHEC");  --r�sultat calcul� : echec
                 Une_Erreur := '1';                  --On met la variable d'erreur �?1 
           end if; 
           writeline(data_out, ligne_texte2);	     --On �crit dans le fichier de sortie la ligne contenant toute l'information sur l'op�ration effectu�e   
     END LOOP w1;
     ASSERT (Une_Erreur='1') 			     				     --On regarde s'il y a un erreur.
         REPORT "testbench pour full_adder_8.vhd termine avec succes" SEVERITY note; --Si non, on rapporte un succ�s.
     ASSERT (Une_Erreur='0') 				  			     --Si oui
         REPORT "testbench pour full_adder_8.vhd termine avec echec" SEVERITY note;  --On rapporte un echec.

     file_close ( data_txt ); --fermeture du fichier d'entr�e
     file_close ( data_out ); --fermeture du fichier de sortie

     WAIT; --le process s'ex�cute seulement une fois
     
      
      


END PROCESS; --fin du process de test

END tb_alu_arch; --fin de larchitecture

