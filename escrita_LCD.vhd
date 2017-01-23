library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity LCD_FPGA is
	generic(fsd_Clk_divider: integer:= 40000);
	port(	
			data_ir_out_1			: in std_logic_vector(7 downto 0);
			data_ir_out_2			: in std_logic_vector(7 downto 0);
			data_ir_out_3			: in std_logic_vector(7 downto 0);
			data_ir_out_4			: in std_logic_vector(7 downto 0);
			
			data_pc_out_1			: in std_logic_vector(7 downto 0);
			data_pc_out_2			: in std_logic_vector(7 downto 0);
			
			data_mar_out_1 		: in std_logic_vector(7 downto 0);
			data_mar_out_2 		: in std_logic_vector(7 downto 0);
			
			data_d_out 				: in std_logic_vector(7 downto 0);
			data_t_out 				: in std_logic_vector(7 downto 0);
			data_a_out 				: in std_logic_vector(7 downto 0);
			
			fsd_Clk	 				: in std_logic := '0';
			fsd_Reset				: in std_logic	:= '0';
			fsd_SelecionaChar		: in std_logic := '0';
			fsd_AtivaEscrita		: in std_logic := '0';
			fsd_EnderecoEscritaX	: in  std_logic_vector (3 downto 0):= "0000"; 
			fsd_EnderecoEscritaY	: in  std_logic := '0' ;
			fsd_DadosEmChar  		: in  character := '0';
			fsd_DadosEmBinario  	: in std_logic_vector(7 downto 0) := "00000000";
			fsd_RS, fsd_RW			: out std_logic;
			fsd_E						: Buffer std_logic;
			fsd_Dados				: out std_logic_vector(7 downto 0)
	);
end LCD_FPGA;

architecture LCD_ME of LCD_FPGA is
	type fsd_estado is (functionSet1, functionSet2, functionSet3, functionSet4,
						clearDisplay, displayControl, entryMode, 
						P0, P1, P2, P3, P4, P5, P6, P7, P8, 
						P9, P10, P11, P12, P13, P14, P15, 
						posicionaAbaixo,
						P16, P17, P18, P19, P20, P21, P22, P23,
						P24, P25, P26, P27, P28, P29, P30, P31,
						returnHome);
	signal fsd_est, fsd_estado_prox: fsd_estado;
	type fsd_memoria is array (0 to 31) of std_logic_vector(7 downto 0);
   signal fsd_RAM : fsd_memoria := (0 to 31 =>	"00100000");
	signal fsd_EnderecoEscrita: std_logic_vector(4 downto 0); 
begin
	process(fsd_Clk, fsd_AtivaEscrita) is
	begin
		fsd_EnderecoEscrita(4) <= fsd_EnderecoEscritaY;
		fsd_EnderecoEscrita(3 downto 0) <= fsd_EnderecoEscritaX;
		if fsd_Reset = '1' then
			for i in fsd_RAM'range loop
				fsd_RAM(i) <= "00100000";
			end loop;
		elsif (rising_edge(fsd_Clk) and fsd_AtivaEscrita = '1') then
			if fsd_SelecionaChar = '1' then
				fsd_RAM(to_integer(unsigned(fsd_EnderecoEscrita))) <= std_logic_vector(to_unsigned(character'pos(fsd_DadosEmChar),8));
			else
				fsd_RAM(to_integer(unsigned(fsd_EnderecoEscrita))) <= fsd_DadosEmBinario;
			end if;
		end if;
	end process;
	
	process(fsd_Clk)
		variable fsd_count: integer range 0 to fsd_Clk_divider;
	begin
		if rising_edge(fsd_Clk) then
			fsd_count := fsd_count + 1;
			if fsd_count = fsd_Clk_divider then
				fsd_E <= not fsd_E;
				fsd_count := 0;
			end if;
		end if;
	end process;
	
	process(fsd_E)
	begin
		if rising_edge(fsd_E) then
			fsd_est <= fsd_estado_prox;
		end if;
	end process;
	
	process(fsd_est)
	begin
		case fsd_est is
			when functionSet1 =>
				fsd_RS <= '0'; fsd_RW <= '0';
				fsd_Dados <= "00111000";
				fsd_estado_prox <= functionSet2;
			when functionSet2 =>
				fsd_RS <= '0'; fsd_RW <= '0';
				fsd_Dados <= "00111000";
				fsd_estado_prox <= functionSet3;
			when functionSet3 =>
				fsd_RS <= '0'; fsd_RW <= '0';
				fsd_Dados <= "00111000";
				fsd_estado_prox <= functionSet4;
			when functionSet4 =>
				fsd_RS <= '0'; fsd_RW <= '0';
				fsd_Dados <= "00111000";
				fsd_estado_prox <= clearDisplay;
			when clearDisplay =>
				fsd_RS <= '0'; fsd_RW <= '0';
				fsd_Dados <= "00000001";
				fsd_estado_prox <= displayControl;
			when displayControl =>
				fsd_RS <= '0'; fsd_RW <= '0';
				fsd_Dados <= "00001100";
				fsd_estado_prox <= entryMode;
			when entryMode =>
				fsd_RS <= '0'; fsd_RW <= '0';
				fsd_Dados <= "00000110";
				fsd_estado_prox <= P0;
----------------------------------------------ESCRITA--------------------------------------------------------------------------------------------------------------------------------------------------------
			when P0 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= x"50";				--P
				fsd_estado_prox <= P1;
			when P1 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= x"3A";				--:
				fsd_estado_prox <= P2;
			when P2 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= data_pc_out_1;	
				fsd_estado_prox <= P3;
			when P3 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= data_pc_out_2;
				fsd_estado_prox <= P4;
			when P4 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= x"20";				-- space
				fsd_estado_prox <= P5;
			when P5 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= x"52";				-- R
				fsd_estado_prox <= P6;
			when P6 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= x"3A";				-- :
				fsd_estado_prox <= P7;
			when P7 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= data_mar_out_1;
				fsd_estado_prox <= P8;
			when P8 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= data_mar_out_2;
				fsd_estado_prox <= P9;
			when P9 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= x"20";				-- space
				fsd_estado_prox <= P10;
			when P10 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= x"49";				-- I
				fsd_estado_prox <= P11;
			when P11 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= x"3A";				-- :
				fsd_estado_prox <= P12;
			when P12 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= data_ir_out_1;
				fsd_estado_prox <= P13;
			when P13 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= data_ir_out_2;
				fsd_estado_prox <= P14;
			when P14 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= data_ir_out_3;
				fsd_estado_prox <= P15;
			when P15 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= data_ir_out_4;
				fsd_estado_prox <= posicionaAbaixo;
			when posicionaAbaixo =>
				fsd_RS <= '0'; fsd_RW <= '0';
				fsd_Dados <= "11000000";
				fsd_estado_prox <= P16;
			when P16 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= x"44"; 				-- D
				fsd_estado_prox <= P17;
			when P17 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= x"3A";				-- :
				fsd_estado_prox <= P18;
			when P18 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= data_d_out;
				fsd_estado_prox <= P19;
			when P19 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= x"20";				-- space
				fsd_estado_prox <= P20;
			when P20 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= x"54";				-- T
				fsd_estado_prox <= P21;
			when P21 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= x"3A";				-- :
				fsd_estado_prox <= P22;
			when P22 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= data_t_out;
				fsd_estado_prox <= P23;
			when P23 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= x"20";				-- space
				fsd_estado_prox <= P24;
			when P24 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= x"41";				-- A
				fsd_estado_prox <= P25;
			when P25 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= x"3A";				-- :
				fsd_estado_prox <= P26;
			when P26 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= data_a_out;
				fsd_estado_prox <= P27;
			when P27 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= x"20";
				fsd_estado_prox <= P28;
			when P28 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= x"20";
				fsd_estado_prox <= P29;
			when P29 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= x"20";
				fsd_estado_prox <= P30;
			when P30 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= x"20";
				fsd_estado_prox <= P31;
			when P31 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= x"20";
				fsd_estado_prox <= returnHome;
			when returnHome =>
				fsd_RS <= '0'; fsd_RW <= '0';
				fsd_Dados <= "10000000";
				fsd_estado_prox <= P0;
			when others	=> fsd_estado_prox <= functionSet1;
		end case;
	end process;
end LCD_ME;