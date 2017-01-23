library ieee;
use ieee.std_logic_1164.all;


entity conversor_ascii is 
		port(
			-- CONVERSOR ASCII
			data_ir : in std_logic_vector(15 downto 0);
			data_pc : in std_logic_vector(7 downto 0);
			data_mar : in std_logic_vector(7 downto 0);
			data_d : in std_logic;
			data_t : in std_logic;
			data_a : in std_logic;
			
			--wl_ir, wl_pc, wl_mar, wl_d, wl_t, wl_a : in std_logic;
			clk : in std_logic;
			
			-- the data below are the ascII characters converted from the entry signals above 
			data_ir_out_1 : out std_logic_vector(7 downto 0);
			data_ir_out_2 : out std_logic_vector(7 downto 0);
			data_ir_out_3 : out std_logic_vector(7 downto 0);
			data_ir_out_4 : out std_logic_vector(7 downto 0);
			
			data_pc_out_1 : out std_logic_vector(7 downto 0);
			data_pc_out_2 : out std_logic_vector(7 downto 0);
			
			data_mar_out_1 : out std_logic_vector(7 downto 0);
			data_mar_out_2 : out std_logic_vector(7 downto 0);
			
			data_d_out : out std_logic_vector(7 downto 0);
			data_t_out : out std_logic_vector(7 downto 0);
			data_a_out : out std_logic_vector(7 downto 0)
			
			
		);
		
end entity;

architecture conversor of conversor_ascii is
	
	begin	
	
	--entry  <= wl_ir & wl_pc & wl_mar & wl_d & wl_t & wl_a;
	
-- converting data_ir bus
data_ir_out_1	<= x"30" when data_ir(3 downto 0) = x"0" else
						x"31" when data_ir(3 downto 0) = x"1" else
						x"32" when data_ir(3 downto 0) = x"2" else
						x"33" when data_ir(3 downto 0) = x"3" else
						x"34" when data_ir(3 downto 0) = x"4" else
						x"35" when data_ir(3 downto 0) = x"5" else
						x"36" when data_ir(3 downto 0) = x"6" else
						x"37" when data_ir(3 downto 0) = x"7" else
						x"38" when data_ir(3 downto 0) = x"8" else
						x"39" when data_ir(3 downto 0) = x"9" else
						x"41" when data_ir(3 downto 0) = x"A" else
						x"42" when data_ir(3 downto 0) = x"B" else
						x"43" when data_ir(3 downto 0) = x"C" else
						x"44" when data_ir(3 downto 0) = x"D" else
						x"45" when data_ir(3 downto 0) = x"E" else
						x"46" when data_ir(3 downto 0) = x"F";
		
	
data_ir_out_2	<= x"30" when data_ir(7 downto 4) = x"0" else
						x"31" when data_ir(7 downto 4) = x"1" else
						x"32" when data_ir(7 downto 4) = x"2" else
						x"33" when data_ir(7 downto 4) = x"3" else
						x"34" when data_ir(7 downto 4) = x"4" else
						x"35" when data_ir(7 downto 4) = x"5" else
						x"36" when data_ir(7 downto 4) = x"6" else
						x"37" when data_ir(7 downto 4) = x"7" else
						x"38" when data_ir(7 downto 4) = x"8" else
						x"39" when data_ir(7 downto 4) = x"9" else
						x"41" when data_ir(7 downto 4) = x"A" else
						x"42" when data_ir(7 downto 4) = x"B" else
						x"43" when data_ir(7 downto 4) = x"C" else
						x"44" when data_ir(7 downto 4) = x"D" else
						x"45" when data_ir(7 downto 4) = x"E" else
						x"46" when data_ir(7 downto 4) = x"F";
		
data_ir_out_3	<= x"30" when data_ir(11 downto 8) = x"0" else
						x"31" when data_ir(11 downto 8) = x"1" else
						x"32" when data_ir(11 downto 8) = x"2" else
						x"33" when data_ir(11 downto 8) = x"3" else
						x"34" when data_ir(11 downto 8) = x"4" else
						x"35" when data_ir(11 downto 8) = x"5" else
						x"36" when data_ir(11 downto 8) = x"6" else
						x"37" when data_ir(11 downto 8) = x"7" else
						x"38" when data_ir(11 downto 8) = x"8" else
						x"39" when data_ir(11 downto 8) = x"9" else
						x"41" when data_ir(11 downto 8) = x"A" else
						x"42" when data_ir(11 downto 8) = x"B" else
						x"43" when data_ir(11 downto 8) = x"C" else
						x"44" when data_ir(11 downto 8) = x"D" else
						x"45" when data_ir(11 downto 8) = x"E" else
						x"46" when data_ir(11 downto 8) = x"F";
	
data_ir_out_4	<= x"30" when data_ir(15 downto 12) = x"0" else
						x"31" when data_ir(15 downto 12) = x"1" else
						x"32" when data_ir(15 downto 12) = x"2" else
						x"33" when data_ir(15 downto 12) = x"3" else
						x"34" when data_ir(15 downto 12) = x"4" else
						x"35" when data_ir(15 downto 12) = x"5" else
						x"36" when data_ir(15 downto 12) = x"6" else
						x"37" when data_ir(15 downto 12) = x"7" else
						x"38" when data_ir(15 downto 12) = x"8" else
						x"39" when data_ir(15 downto 12) = x"9" else
						x"41" when data_ir(15 downto 12) = x"A" else
						x"42" when data_ir(15 downto 12) = x"B" else
						x"43" when data_ir(15 downto 12) = x"C" else
						x"44" when data_ir(15 downto 12) = x"D" else
						x"45" when data_ir(15 downto 12) = x"E" else
						x"46" when data_ir(15 downto 12) = x"F";	
						
-- converting data_pc bus
data_pc_out_1	<= x"30" when data_pc(3 downto 0) = x"0" else
						x"31" when data_pc(3 downto 0) = x"1" else
						x"32" when data_pc(3 downto 0) = x"2" else
						x"33" when data_pc(3 downto 0) = x"3" else
						x"34" when data_pc(3 downto 0) = x"4" else
						x"35" when data_pc(3 downto 0) = x"5" else
						x"36" when data_pc(3 downto 0) = x"6" else
						x"37" when data_pc(3 downto 0) = x"7" else
						x"38" when data_pc(3 downto 0) = x"8" else
						x"39" when data_pc(3 downto 0) = x"9" else
						x"41" when data_pc(3 downto 0) = x"A" else
						x"42" when data_pc(3 downto 0) = x"B" else
						x"43" when data_pc(3 downto 0) = x"C" else
						x"44" when data_pc(3 downto 0) = x"D" else
						x"45" when data_pc(3 downto 0) = x"E" else
						x"46" when data_pc(3 downto 0) = x"F";
		
	
data_pc_out_2	<= x"30" when data_pc(7 downto 4) = x"0" else
						x"31" when data_pc(7 downto 4) = x"1" else
						x"32" when data_pc(7 downto 4) = x"2" else
						x"33" when data_pc(7 downto 4) = x"3" else
						x"34" when data_pc(7 downto 4) = x"4" else
						x"35" when data_pc(7 downto 4) = x"5" else
						x"36" when data_pc(7 downto 4) = x"6" else
						x"37" when data_pc(7 downto 4) = x"7" else
						x"38" when data_pc(7 downto 4) = x"8" else
						x"39" when data_pc(7 downto 4) = x"9" else
						x"41" when data_pc(7 downto 4) = x"A" else
						x"42" when data_pc(7 downto 4) = x"B" else
						x"43" when data_pc(7 downto 4) = x"C" else
						x"44" when data_pc(7 downto 4) = x"D" else
						x"45" when data_pc(7 downto 4) = x"E" else
						x"46" when data_pc(7 downto 4) = x"F";
						
-- converting data_mar bus
data_mar_out_1	<= x"30" when data_mar(3 downto 0) = x"0" else
						x"31" when data_mar(3 downto 0) = x"1" else
						x"32" when data_mar(3 downto 0) = x"2" else
						x"33" when data_mar(3 downto 0) = x"3" else
						x"34" when data_mar(3 downto 0) = x"4" else
						x"35" when data_mar(3 downto 0) = x"5" else
						x"36" when data_mar(3 downto 0) = x"6" else
						x"37" when data_mar(3 downto 0) = x"7" else
						x"38" when data_mar(3 downto 0) = x"8" else
						x"39" when data_mar(3 downto 0) = x"9" else
						x"41" when data_mar(3 downto 0) = x"A" else
						x"42" when data_mar(3 downto 0) = x"B" else
						x"43" when data_mar(3 downto 0) = x"C" else
						x"44" when data_mar(3 downto 0) = x"D" else
						x"45" when data_mar(3 downto 0) = x"E" else
						x"46" when data_mar(3 downto 0) = x"F";
		
	
data_mar_out_2	<= x"30" when data_mar(7 downto 4) = x"0" else
						x"31" when data_mar(7 downto 4) = x"1" else
						x"32" when data_mar(7 downto 4) = x"2" else
						x"33" when data_mar(7 downto 4) = x"3" else
						x"34" when data_mar(7 downto 4) = x"4" else
						x"35" when data_mar(7 downto 4) = x"5" else
						x"36" when data_mar(7 downto 4) = x"6" else
						x"37" when data_mar(7 downto 4) = x"7" else
						x"38" when data_mar(7 downto 4) = x"8" else
						x"39" when data_mar(7 downto 4) = x"9" else
						x"41" when data_mar(7 downto 4) = x"A" else
						x"42" when data_mar(7 downto 4) = x"B" else
						x"43" when data_mar(7 downto 4) = x"C" else
						x"44" when data_mar(7 downto 4) = x"D" else
						x"45" when data_mar(7 downto 4) = x"E" else
						x"46" when data_mar(7 downto 4) = x"F";
						
-- converting the remaining binary signals 
data_d_out <= x"30" when data_d = '0' else
				  x"31" when data_d = '1';
				  
data_t_out <= x"30" when data_t = '0' else
				  x"31" when data_t = '1';

data_a_out <= x"30" when data_a = '0' else
				  x"31" when data_a = '1';

				 
								
end conversor;
	