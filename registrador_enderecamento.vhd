library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity registrador_enderecamento is 
	port
	(
		-- REGISTRADOR DE ENDEREAMENTO DE MEMORIA (MAR)
		IR, P	: in std_logic_vector(7 downto 0);
		t_pc, t_ir, z_mar, i_mar : in std_logic;
		clk 	: in std_logic;
		A	: out std_logic_vector(7 downto 0) 
		
	);

end entity;

architecture mar of registrador_enderecamento is

	signal out_array : std_logic_vector(7 downto 0);
	signal entry : std_logic_vector(3 downto 0);
	
begin

	
	entry <= t_pc & t_ir & z_mar & i_mar;

	process(clk)
	begin 

		if(rising_edge(clk)) then
			case entry is
				when "1000" => out_array <= P;
				when "0100" => out_array <= IR;
				when "0010" => out_array <= "00000000";
				when "0001" => out_array <= out_array + "1";
				when others => out_array <= out_array;
			end case;
		end if;

	end process;

	A <= out_array;

end mar;
