library ieee;
use ieee.std_logic_1164.all;

entity controlador_escravo is 

	port(clk, SOP, Continue : in std_logic;
		  IR : in std_logic_vector(7 downto 0);
		  EOP, I_PC, Z_PC, T_PC, T_IR, T_BUS : out std_logic;
		  R_A, W_A, Z_A : out std_logic;
		  R_M, W_M : out std_logic;
		  W_T: out std_logic
		  );
		  
end entity;

architecture slave_ctrl of controlador_escravo is
		type ctrl_est is (e0, e1, e2, e3, e4, e5, e6, e7, e8);
		signal est : ctrl_est := e0;
		signal C : std_logic_vector(10 downto 0);
		
begin

		--sinais de controle varredura de execuao de instruoes
		process(clk)
		begin
			
			if (falling_edge(clk)) then
					case est is
						when e0 => if(SOP = '1') then 
											est <= e1;
										end if;
						when e1 => est <= e2;
						when e2 => est <= e3;
						when e3 => est <= e4;
						when e4 => est <= e5;
						when e5 => est <= e6;
						when e6 => if(IR = "00010000") then
											est <= e8;
										elsif(IR /= "00010000") then
											est <= e7;
										end if;
						when e7 => est <= e1;
						when e8 => if(SOP = '1') then
											est <= e1;
										end if;
						when others => est <= est; --haha
					end case;
					case est is      --109876543210 
						when e1 => C <= "00000001000";
						when e2 => C <= "00001000000";
						when e3 => C <= "00000110000";
						when e4 => C <= "00101000000"; 
						when e5 => C <= "01000000000";
						when e6 => C <= "10010000000";
						when e7 => C <= "00000000010";
						when e8 => C <= "00000000001";
						when others => C <= C;
					end case;
			end if;
		end process;
										
							
					EOP <= C(0);
					I_PC <= C(1);
					Z_PC <= C(2);
					T_PC <= C(3);
					T_IR <= C(4);
					T_BUS <= C(5);
					R_M <= C(6);
					W_M <= C(7);
					W_T <= C(8);
					W_A <= C(9);
					R_A <= C(10);
					
end slave_ctrl;