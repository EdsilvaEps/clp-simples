library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity chip_seletor2 is 
	port
	(
		-- CHIP SELETOR PARA REGISTRADOR A e E/S(CS)
		-- explicacao: em vista da dificuldade de se criar 
		-- um barramento bidirecional p/ suprir dados as said Q
		-- este componente seleciona os dados que devem ser escritos
		-- provenientes de REGISTRADOR A e BARRAMENTO D_BUS(0)
		-- (editar para multiplos outputs,se necessario
		REG_A		 : in std_logic;
		D_BUS	    : in std_logic;
		r_a, r_m : in std_logic;
		clk 		 : in std_logic;
		A		    : out std_logic 
		
	);

end entity;

architecture selec of chip_seletor2 is

	signal out_array : std_logic := '0';
	signal entry : std_logic_vector(1 downto 0);
	
begin

	
	entry <= r_a & r_m;

	process(clk)
	begin 

		if(rising_edge(clk)) then
			case entry is
				when "10" => out_array <= REG_A;
				when "01" => out_array <= D_BUS;
				when others => out_array <= '1';
			end case;
		end if;

	end process;

	A <= out_array;

end selec;
