library ieee;
use ieee.std_logic_1164.all;

entity controlador_mestre is 

	port(clk, SOP, tout, EOP : in std_logic;
		  RD_ES, WR_ES: out std_logic;
		  RST_MAR, INC_MAR : out std_logic;
		  WR_M, RD_M : out std_logic;
		  START : out std_logic;
		  RX : in std_logic -- this entry starts the writing of user input on mem
		  );
		  
end entity;

architecture master_ctrl of controlador_mestre is
	type ctrl_est is (e0, e1, e2, e3, e4, e5, e6, e7, e8, e9);
	signal est : ctrl_est := e0;
	signal C : std_logic_vector(6 downto 0);
	
	signal counter : integer range 0 to 20 := 0;
		
begin
	process(clk)
		begin
			
			if (falling_edge(clk)) then
					case est is
						when e0 => if(RX = '1') then -- here we wait until RX is HIGH and the circuit is uploaded
											est <= e1;
										end if;
										
						when e1 => est <= e2; -- here we zero the MAR component and write the first input
						
						when e2 =>  if(counter = 10) then -- here we write the user inputs on memory
											counter <= 0;
											est <= e3;
										else 
											counter <= counter + 1;
										end if;	
										
						when e3 => if(SOP = '1') then -- here SOP is inputted and execution starts
										est <= e4;
										    elsif(RX = '1') then
										      est <= e1;
									  end if;
									  
						when e4 => if(EOP = '1') then -- here EOP is received and execution ends
										est <= e5;
									  end if;
									  
						when e5 => est <= e6; -- here we zero the MAR component
									  
						when e6 =>  if(counter = 9) then -- here we start counting the addresses for writing
											est <= e7;			-- when we get to 9 count, we go to next state
										else 
											counter <= counter + 1;
										end if;
						
						when e7 =>  if(counter = 20) then -- here we write the machine inputs to the leds
											est <= e8;
											counter <= 0;			
										else 
											counter <= counter + 1;
										end if;
			
						when e8 => if(tout = '1')then -- here we send the START signal and wait for 
										est <= e9;			-- tout to return HIGH
									  end if;
									  
						when e9 => if(RX = '1')then   	-- here the ctrls output are zero
										est <= e1;				-- if RX is HIGH we rewrite the circuit
									  elsif(SOP = '1') then	-- SOP is HIGH we rerun the same circuit
										est <= e4;
									  end if;
									  
						when others => est <= est; 
					end case;
					case est is       --6543210 
						when e1 => C <= "0100101";	-- RST_MAR / RD_ES / WR_M
						when e2 => C <= "1000101"; -- INC_MAR / RD_ES / WR_M
						when e3 => C <= "0000000";
						when e4 => C <= "0000000"; 
						when e5 => C <= "0100000"; -- RST_MAR  
						when e6 => C <= "1000000"; -- INC_MAR  
						when e7 => C <= "1000010"; -- INC_MAR / WR_ES 
						when e8 => C <= "0010000";	-- START
						when e9 => C <= "0000000";
						when others => C <= C;
					end case;
			end if;
	end process;
	RD_ES <= C(0);
	WR_ES <= C(1);
	WR_M <= C(2);
	RD_M <= C(3);
	START <= C(4);
	RST_MAR <= C(5);
	INC_MAR <= C(6);
	
	
end master_ctrl;