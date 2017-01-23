library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL; 

entity single_port_ram is
	port
	(
		-- 256X16 BITS RAM
		data	: in std_logic_vector(15 downto 0) := "0000000000000000";
		i			: in std_logic_vector (3 downto 0);
		addr_in	: in std_logic_vector (7 downto 0);
		w_m		: in std_logic := '0';
		r_m		: in std_logic := '0';
		clk		: in std_logic;
		q		: buffer std_logic_vector(15 downto 0)  := "0000000000000000"
	);
	
end entity;

architecture rtl of single_port_ram is

	-- address
	signal addr : natural range 0 to 255;
	
	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector(15 downto 0);
	type memory_t is array(255 downto 0) of word_t;
		
	function init_ram
		return memory_t is
		variable ram : memory_t := (others => (others => '0'));
		begin
			ram(0)  := x"0000";
			ram(1)  := x"0000";
			ram(2)  := x"0000";
			ram(3)  := x"0000";
			ram(10)  := x"0000";
		
			ram(30) := x"0400";
			ram(31) := x"0301";
			ram(32) := x"0302";
			ram(33) := x"010A";
			ram(34) := x"1000";

			ram(50) := x"0004";
			ram(51) := x"030B";
			ram(52) := x"0605";
			ram(53) := x"010B";
			ram(54) := x"1000";

			ram(70) := x"0000";
			ram(71) := x"0201";
			ram(72) := x"0114";
			ram(73) := x"0002";
			ram(74) := x"0603";
			ram(75) := x"0314";
			ram(76) := x"010C";
			ram(77) := x"1000";

		return ram;
	end init_ram;
	
	-- Declare the RAM signal with the initialized values
	signal ram : memory_t:= init_ram;
		
	-- Register to hold the address
	signal addr_reg : natural range 0 to 255 ; 
	
	signal entry : std_logic_vector(1 downto 0);
	

begin


	entry <= w_m & r_m;
	addr_reg <= to_integer(unsigned(addr_in));
	--addr_reg <= addr;
	
	process(clk)
	begin
		if(rising_edge(clk)) then
			-- inject the keys' values to the ram, whatever they are
			--ram(0)(0) <= i(0);
			--ram(1)(0) <= i(1);
			--ram(2)(0) <= i(2);
			--ram(3)(0) <= i(3);
			
			case entry is 
			   when "10" => ram(addr_reg) <= data;
				--when "10" => ram(addr) <= q;
			   when "01" => q <= ram(addr_reg);
			   when others => q <= q;
			end case;
			
			     
			--if(entry = "10") then
			--	ram(addr) <= data;
			--end if;
			
			-- Register the address for reading
			
			--if(entry = "01") then
			--	q <= ram(addr);  -- addr_reg <= addr;
			--end if;
			
				--q <= ram(addr); -- PREV: 	q <= ram(addr_reg);

		end if;
	
	end process;
  
	
end rtl;