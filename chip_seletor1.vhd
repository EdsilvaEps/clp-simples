library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity chip_seletor is 
	port
	(
		-- CHIP SELETOR PARA REGISTRADOR A e E/S(CS)
		-- explicacao: em vista da dificuldade de se criar 
		-- um barramento bidirecional p/ suprir dados a RAM
		-- este componente seleciona os dados que devem ser escritos
		-- proveniente dos dois unicos componentes q podem
		-- realizar mudancas na memoria
		-- REGISTRADOR A(1-BIT) e PORTA DE E/S(16-BITS)
		REG_A		 : in std_logic;
		ES	   	 : in std_logic_vector(15 downto 0);
		r_a, r_es : in std_logic := '0';
		clk 		 : in std_logic;
		A		    : out std_logic_vector(15 downto 0) 
		
	);

end entity;

architecture selec of chip_seletor is

	signal out_array : std_logic_vector(15 downto 0) := "0000000000000000";
	signal entry : std_logic_vector(1 downto 0);
	
begin

	
	entry <= r_a & r_es;
	out_array(0) <= REG_A;
	
	A <= ES when entry = "01" else
		  out_array when entry = "10" else 
		  (others => '0');

	--process(clk)
	--begin 

	--	if(rising_edge(clk)) then
	--		case entry is
	--			when "01" => out_array <= ES;
	--			when "10" => out_array(0) <= REG_A;
	--			when others => out_array <= (others => '0');
	--		end case;
	--	end if;

	--end process;

	--A <= out_array;

end selec;
