library ieee;
use ieee.std_logic_1164.all;

entity divisor_freq_1hz is

		port (
					-- divisor de frequencia de 50MHz p/ 1Hz
					clk_in : in std_logic;
					reset  : in std_logic;
					clk_out : out std_logic
					
		);
		
end entity divisor_freq_1hz;

architecture div_freq of divisor_freq_1hz is

		signal temp : std_logic := '0';
		signal counter: integer range 0 to 25000000 := 0;
begin													

		process(reset, clk_in) 
		begin
				if (reset = '1') then
						temp <= '0';
						counter <= 0;
				elsif rising_edge(clk_in) then
				
					if	 (counter = 25000000) then
							temp <= NOT(temp);
							counter <= 0;
					else
							counter <= counter + 1;
					end if;
				end if;
    end process;   
    clk_out <= temp;
	 
end div_freq;
													  