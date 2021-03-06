library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity ULA is
	port(
		reg_t, reg_a : in std_logic;
		op : in std_logic_vector(7 downto 0);
		q : out std_logic
	);
	
end ULA;

architecture logic of ULA is
	

begin
	

	 -- suppositions:
    -- reg_t -> (receives)mem8 
	 -- reg_a -> A
	
	q <= (reg_t) when op = "00000000" else      		      -- LD (A <- mem8)
		  (reg_a) when op = "00000001" else        		   -- ST (mem8 <- A) 
		  (reg_a) AND reg_t when op = "00000010" else  		-- AND (A <- A AND mem8)
		  (reg_a OR reg_t) when op = "00000011"	else		-- OR (A <- A OR mem8)
		  (NOT(reg_t)) when op = "00000100" else 				-- LDN (A <- NOT mem8)
		  (NOT(reg_a)) when op = "00000101" else 				-- STN (mem8 <- NOT A)
		  (reg_a AND NOT(reg_t)) when op = "00000110" else -- ANDN (A <- A AND NOT mem8)
		  (reg_a OR NOT(reg_t)) when op = "00000111" else '0';	-- ORN (A <- A OR NOT mem8)
		
		  
end logic;