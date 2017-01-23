--Esse cdigo apresentar os caracteres de 0, 1 ,2,3 em um display de sete segmentos. 
--Foi utilizado como fonte de clock o oscilador hibrido de 50Mhz ligado ao pino 23 do kit FPGAEE03 


library ieee;
use ieee.std_logic_1164.all;
entity display_7seg is
	port 
	(
		clock: in std_logic;
		data : in std_logic_vector(1 downto 0);
		dp:out std_logic;
		catodos: out std_logic_vector (3 downto 0);
		display: out std_logic_vector (6 downto 0));
end ;
architecture rtl of display_7seg is
	signal contador_disp: integer range 0 to 3; --contador do display
	signal contador:integer range 0 to 25000000;-- numero de ciclos para 500ms
	signal mem_led: std_logic;

begin
		dp <='1';

WITH contador_disp SELECT

	display <= 				"1111110"  WHEN 0, --0
								"0110000" 	WHEN 1,--1
								"1101101"  	WHEN 2,--2
								"1111001" 	WHEN 3;--3
										
					
													
					
	process1: process(clock)  --processo de gerao do clock de 1 Hz
	begin

			
			if (clock'  EVENT AND clock= '0') -- para clock com borda de descida
		
				then
				contador<=contador+1;
					if contador=99999 -- de zero at 9999999 soma-se 10000000 ciclos
						then
							mem_led<=not mem_led;
							contador<=0;
					end if;							
			else
			contador<= contador;
			end if;
		
	end process;
	
	process2: process(mem_led)  --processo para atualizar o velor do contador do display
	begin

		
			if (mem_led'  EVENT AND mem_led= '0') -- para clock com borda de descida
				then
				
				case data is
					when "00" => contador_disp <= 0;
					when "01" => contador_disp <= 1;
					when "10" => contador_disp <= 2;
					when "11" => contador_disp <= 3;
					when others => contador_disp <= contador_disp;
				end case;
				
			end if;
	
	end process;
	
process3: process(contador_disp)
begin

	case contador_disp is
	
		when 0=> catodos<= "0001";
		when 1=> catodos<="0010";
		when 2=> catodos<="0100";
		when 3=> catodos<="1000";
	
	
	end case;
end process;
	end;