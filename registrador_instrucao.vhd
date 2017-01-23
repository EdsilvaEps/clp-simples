library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity registrador_instrucao is 
	port
	(
		-- REGISTRADOR DE INSTRUO (IR)
		D	: in std_logic_vector(15 downto 0);
		t_bus		: in std_logic;
		clk	 	: in std_logic;
		IR		: buffer std_logic_vector(15 downto 0) := "0000000000000000"
		-- IR  simplesmente o valor da sada D15-D0 da RAM convertido para binrio
	);

end entity;

architecture ri of registrador_instrucao is

	signal out_array : std_logic_vector(15 downto 0);
	
begin

	out_array <= D;

	process(clk)
	begin 
		
		if(rising_edge(clk)) then
			if(t_bus = '1') then
				IR <= out_array;	
		   end if;
		end if;
	end process;

	

end ri;
