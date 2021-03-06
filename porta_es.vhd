library ieee;
use ieee.std_logic_1164.all;

entity porta_es is 

	port(clk, RD_ES, WR_ES : in std_logic;
		  I : in std_logic_vector(9 downto 0) := "0000000000"; -- entradas do sistema
		  D : buffer std_logic_vector(15 downto 0); -- 20 bits on the scheme
		  DATA_IN : in std_logic_vector(15 downto 0); -- entrada de dados (n estamos usando tri-state)
		  ADDR : in std_logic_vector(7 downto 0);
		  Q : buffer std_logic_vector(9 downto 0) -- saidas do sistema
		  
		  );
		  
end entity;

architecture es of porta_es is
		
		signal entry: std_logic_vector(1 downto 0);
		
	 	subtype word_t is std_logic_vector(15 downto 0);
		type mem is array(9 downto 0) of word_t;	
		signal keys : mem := (others => (others => '0'));
		signal counter : integer range 0 to 10 := 0;

begin


		keys(0)(0)  <= I(0);
	   keys(1)(0)	<= I(1);
		keys(2)(0)	<= I(2);
		keys(3)(0)	<= I(3);
	   keys(4)(0)	<= I(4);
	   keys(5)(0)	<= I(5);
	   keys(6)(0)	<= I(6);
		keys(7)(0)	<= I(7);
	   keys(8)(0)	<= I(8);
		keys(9)(0)	<= I(9);
				
		entry <= RD_ES & WR_ES;
		
		process(clk)
		begin
			if(rising_edge(clk)) then
				case entry is
					when "10" =>
								   		case ADDR is
												when "00000000" => D <= keys(0);
												when "00000001" => D <= keys(1);
												when "00000010" => D <= keys(2);
												when "00000011" => D <= keys(3);
												when "00000100" => D <= keys(4);
												when "00000101" => D <= keys(5);
												when "00000110" => D <= keys(6);
												when "00000111" => D <= keys(7);
												when "00001000" => D <= keys(8);
												when "00001001" => D <= keys(9);
												when others => D <= (others => '0');
											end case;
									 
			      when "01" => if(counter > 9) then
											counter <= 0;
									 else 
											case ADDR is
												when "00001010" => Q(0)  <= DATA_IN(0);
												when "00001011" => Q(1)  <= DATA_IN(0);
												when "00001100" => Q(2)  <= DATA_IN(0);
												when "00001101" => Q(3)  <= DATA_IN(0);
												when "00001110" => Q(4)  <= DATA_IN(0);
												when "00001111" => Q(5)  <= DATA_IN(0);
											   when "00010000" => Q(6)  <= DATA_IN(0);
												when "00010001" => Q(7)  <= DATA_IN(0);
												when "00010010" => Q(8)  <= DATA_IN(0);
												when "00010011" => Q(9)  <= DATA_IN(0);
												when others => Q(0) <= '0';
											end case;
												--Q(counter) <= D(0); -- it might be useful to make a WHEN condition with the addresses received
											counter <= counter + 1;
									 end if;
					when others => D <= (others => '0'); 
				end case;
			end if;
		end process;
		
end es;
					
		