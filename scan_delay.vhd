library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- author Edson Silva
-- the sw keys direct the 'scan_time' signal to the user's preferred 
-- value of delay between the EOP of one program, and the availability
-- of the CLP for a next program

-- recommendation: master ctrl must hold 'start' input until 'tout' is high
-- for proper working of this component 
entity scan_delay is

		port (
					start : in std_logic;
					clk	: in std_logic;
					sw  : in std_logic_vector(1 downto 0);
					tout : buffer std_logic
		);
		
end entity scan_delay;

architecture delay of scan_delay is

	constant second: integer := 25000000;
	constant tenth_second: integer := 2500000;
	constant ten_milisecond: integer := 250000;
	constant milisecond: integer := 25000;
	
	signal scan_time: integer := second;
	signal counter : integer range 0 to 25000000;
	
begin	

	scan_time <= (second) when sw = "00" else
				    (tenth_second) when sw = "01" else
					 (ten_milisecond) when sw = "10" else
					 (milisecond) when sw = "11" else (second);
					 
	process(clk,start)
	begin
		if(start = '1') then
			if(rising_edge(clk)) then
				if	 (counter = scan_time) then
							tout <= '1';
							counter <= 0;
					else
							counter <= counter + 1;
				end if;
			end if;
		elsif(start = '0') then
			tout <= '0';
			counter <= 0;
		end if;
	end process;
	
end delay;
	
	
