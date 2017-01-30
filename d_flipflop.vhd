library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity D_FF is
   port
   (
      clk : in std_logic;      
      sop_in, eop_in : in std_logic;
      sop_out, eop_out : out std_logic
   );
end entity D_FF;
 
architecture Behavioral of D_FF is
begin
   process (clk) is
   begin
      if rising_edge(clk) then  
         sop_out <= sop_in;
			eop_out <= eop_in;
      end if;
   end process;
end architecture Behavioral;
