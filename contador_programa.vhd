library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity contador_programa is 

	
	
	port
	(
		-- CONTADOR DE PROGRAMA (PC)
		prog	: in std_logic_vector(1 downto 0) := "00";
		z_pc		: in std_logic := '0';
		i_pc		: in std_logic := '0';
		clk		: in std_logic;
		p		: buffer std_logic_vector(7 downto 0) := "00000000"
	);

end entity;

architecture pc of contador_programa is


	signal out_array : std_logic_vector(7 downto 0);
	
	constant p0 : std_logic_vector(7 downto 0) := "00000000";
	constant p1 : std_logic_vector(7 downto 0) := "00011110"; -- 30B
	constant p2:  std_logic_vector(7 downto 0) := "00110010"; -- 50b
	constant p3:  std_logic_vector(7 downto 0) := "01000110"; -- 70b

	signal entry : std_logic_vector(1 downto 0);
	signal keys : std_logic_vector(1 downto 0);
	signal change : std_logic := '0';
begin

	entry <= z_pc & i_pc;
	keys	<= prog;
	
	
  
	process(clk, change)
	begin 
		
		--if(change'event and change = '1') then 
		--	case keys is
		--		when "00" => out_array <= p0;
		--		when "01" => out_array <= p1;
		--		when "10" => out_array <= p2;
		--		when "11" => out_array <= p3;
		--	end case;
		--end if;
		
		
		if(rising_edge(clk)) then
			if(p = p0) then
				case keys is
					when "00" => p <= p0;
					when "01" => p <= p1;
					when "10" => p <= p2;
					when "11" => p <= p3;
					when others => p <= p;
				end case;
			else
				case entry is 
						when "01" => p <= p + "1";
						when "10" => p <= p0;
						when others => p <= p; 
				end case;					 
			end if;	
		--	if(prog <= "00") then
		--		out_array <= p0;
		--	end if;
		end if;
	end process;

	--p <= out_array;

end pc;
