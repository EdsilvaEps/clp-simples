library ieee;
use ieee.std_logic_1164.all;


entity registrador_temporario is 
		port (
			-- REGISTRADOR TEMPORARIO
			Dt: in std_logic;
			wr_T: in std_logic;
			rst_T: in std_logic;
			clk: in std_logic;
			q: out std_logic
		);
		
end entity;	
architecture reg_t of registrador_temporario is

	signal output: std_logic := '0';
	signal entry : std_logic_vector(1 downto 0);
	
begin
  
  entry <= rst_T & wr_T;

	process(clk) 
	begin
	
		if(rising_edge(clk)) then
		    case entry is
		        when "10" => output <= '0';
		        when "01" => output <= Dt;
		        when others => output <= output;
				end case;
		end if;
	end process;
	q <= output;
	
end reg_t;