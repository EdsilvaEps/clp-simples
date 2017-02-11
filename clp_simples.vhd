library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.numeric_std.ALL; 

entity clp_simples is 
	port
	(
		-- CLP SIMPLES --
		-- 9/DEZ - CICLO DE BUSCA --
		m_prog	: in std_logic_vector(1 downto 0);
		m_Continue_btn : in std_logic ;
		m_SOP_btn		: in std_logic ;
		mclk_in 		: in std_logic ;
		m_EOP		: buffer std_logic;
		m_IR		: buffer std_logic_vector(15 downto 0);
		
		-- sinais do controlador para visualizaao
		m_IPC 	: buffer std_logic;
		m_TPC		: buffer std_logic;
		m_TBUS	: buffer std_logic;
		m_RM		: buffer std_logic;
		
		clk_watch : buffer std_logic; -- eu quero visualizar o clock dividido
		
		-- entradas do display de 7 segmentos
		ktodos	: out std_logic_vector(3 downto 0);
		display_in	: out std_logic_vector(6 downto 0);
		
		-- I/O do LCD
		RS, RW: OUT std_logic;
		E: BUFFER std_logic;-- can be OUT if an internai sigr.al is sreated 
		DB: OUT std_logic_VECTOR(7 DOWNTO 0);
	 
		m_I : in std_logic_vector(9 downto 0);
		Q : buffer std_logic_vector(9 downto 0);
		sw  : in std_logic_vector(1 downto 0);
		m_rx  : in std_logic;
		flag : buffer std_logic
		
		
	);
	-- entradas e saidas do sistema 

end entity;

architecture clp of clp_simples is

	-- componentes declarados abaixo:
	
	-- //primeira entrega//
	-- divisor de frequencia de 50MHz p/ 1Hz
	-- DECODER DO DISPLAY 7 SEGMENTOS
	-- MODULO DEBOUNCE
	-- CONTADOR DE PROGRAMA (PC)
	-- REGISTRADOR DE ENDERECAMENTO DE MEMORIA (MAR)
	-- REGISTRADOR DE INSTRUCAO (IR)
	-- 256X16 BITS RAM
	-- CONTROLADOR ESCRAVO
	-- //segunda entrega//
	-- ULA
	-- REGISTRADOR A
	-- REGISTRADOR TEMPORARIO
	-- CONVERSOR ASCII
	-- ESCRITA DE LCD (mod)
	-- //terceira entrega//
	-- PORTA_ES
	-- CONTROLADOR MESTRE
	-- GERADOR DE ATRASO
	-- FF-D

	-- declaracao dos componentes --
	
	component divisor_freq_1hz 
			port (
					-- divisor de frequencia de 50MHz p/ 1Hz
					clk_in : in std_logic;
					reset  : in std_logic;
					clk_out : out std_logic
					
		);
	end component;
	
	component display_7seg 
			port (
				-- DECODER DO DISPLAY 7 SEGMENTOS
				clock: in std_logic;
				data : in std_logic_vector(1 downto 0);
				dp:out std_logic;
				catodos: out std_logic_vector (3 downto 0);
				display: out std_logic_vector (6 downto 0));
	end component;
	
	component Debounce
			Port (
				-- MODULO DEBOUNCE
				CLK : in  STD_LOGIC;
				x : in  STD_LOGIC;
				DBx : out  STD_LOGIC
			);
	end component;
	
	component contador_programa 
			port(
				-- CONTADOR DE PROGRAMA (PC)
          prog	: in std_logic_vector(1 downto 0) := "00";
          z_pc		: in std_logic := '0';
          i_pc		: in std_logic := '0';
          clk		: in std_logic;
          p		: buffer std_logic_vector(7 downto 0) := "00000000"
			);
	end component;
	
	component registrador_enderecamento 
			port(
				-- REGISTRADOR DE ENDEREAMENTO DE MEMORIA (MAR)
				IR, P	: in std_logic_vector(7 downto 0);
				t_pc: in std_logic;
				t_ir : in std_logic;
				z_mar : in std_logic;
				i_mar : in std_logic; 
				clk 	: in std_logic;
				A	: out std_logic_vector(7 downto 0) 	
			);
	end component;
	
	component registrador_instrucao 
			port(
				-- REGISTRADOR DE INSTRUCAO (IR)
				D	: in std_logic_vector(15 downto 0);
				t_bus		: in std_logic;
				clk	 	: in std_logic;
				IR		: buffer std_logic_vector(15 downto 0):= "0000000000000000" 
				-- IR  simplesmente o valor da saida D15-D0 da RAM convertido para binario
			);
	end component;
	
	component single_port_ram is
			port(
				-- 256X16 BITS RAM
				data		: in std_logic_vector(15 downto 0);
				addr_in	: in std_logic_vector (7 downto 0);
				w_m		: in std_logic := '0';
				r_m		: in std_logic := '0';
				clk		: in std_logic;
				q			: buffer std_logic_vector(15 downto 0) := "0000000000000000"
			);
	end component;
	
	component controlador_escravo 
		  port(
				-- CONTROLADOR ESCRAVO
				clk, SOP, Continue : in std_logic;
				IR : in std_logic_vector(7 downto 0);
				EOP, I_PC, Z_PC, T_PC, T_IR, T_BUS : out std_logic;
				R_A, W_A, Z_A : out std_logic;
				R_M, W_M : out std_logic;
				W_T: out std_logic
			);
	end component;
	
	component ULA
		port(
			-- UNIDADE LOGICA E ARITMETICA
			reg_t, reg_a : in std_logic;
			op : in std_logic_vector(7 downto 0);
			q : out std_logic
		);
	end component;
	
	component registrador_A
		port (
			-- REGISTRADOR A(REG_A)
			input: in std_logic;
			rd_A, wr_A: in std_logic;
			rst_A: in std_logic; 
			clk: in std_logic;
			q: buffer std_logic; -- ?
			c: out std_logic
		);
		
	end component;	
	
	component registrador_temporario 
		port (
			-- REGISTRADOR TEMPORARIO(REG_T)
			Dt: in std_logic;
			wr_T: in std_logic;
			rst_T: in std_logic;
			clk: in std_logic;
			q: out std_logic
		);
		
	end component;	
	
	component conversor_ascii
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
	end component;
	
	component LCD_FPGA
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
			
			fsd_Clk	 				: in std_logic;
			fsd_Reset				: in std_logic;
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
	end component;
	
	component chip_seletor
		port (
			-- REGISTRADOR A(1-BIT) e PORTA DE E/S(16-BITS)
			REG_A		 : in std_logic;
			ES	   	 : in std_logic_vector(15 downto 0);
			r_a, r_es : in std_logic;
			clk 		 : in std_logic;
			A		    : out std_logic_vector(15 downto 0) 
		);
	end component;
	
	component chip_seletor2
		port (
		   -- REGISTRADOR A e BARRAMENTO D_BUS(0)
			REG_A		 : in std_logic;
			D_BUS   	 : in std_logic;
			r_a, r_m  : in std_logic;
			clk 		 : in std_logic;
			A		    : out std_logic 
		);
	end component;
	
	component porta_es 
		port(
		  -- PORTAS DE ENTRADA E SAIDA
		  clk, RD_ES, WR_ES : in std_logic;
		  I : in std_logic_vector(9 downto 0) := "0000000000"; -- entradas do sistema
		  D : out std_logic_vector(15 downto 0); -- 20 bits on the scheme
		  DATA_IN : in std_logic_vector(15 downto 0); -- entrada de dados (n estamos usando tri-state)
		  ADDR : in std_logic_vector(7 downto 0);
		  Q : buffer std_logic_vector(9 downto 0) -- saidas do sistema 
		 );
	end component;
	
	component controlador_mestre
		port(
		  -- CONTROLADOR MESTRE
		  clk, SOP, tout, EOP : in std_logic;
		  RD_ES, WR_ES: out std_logic;
		  RST_MAR, INC_MAR : out std_logic;
		  WR_M, RD_M : out std_logic;
		  START : out std_logic;
		  RX : in std_logic -- this entry starts the writing of user input on mem
		  );
	end component;
	
	component scan_delay
		port (
				-- GERADOR DE ATRASO
				start : in std_logic;
				clk	: in std_logic;
				sw  : in std_logic_vector(1 downto 0);
				tout : buffer std_logic
		);
	end component;
	
	component D_FF 
		port(
		-- FLIP FLOP D
      clk : in std_logic;      
      sop_in, eop_in : in std_logic;
      sop_out, eop_out : out std_logic
		);
	end component;
	
	-- 
	
	signal m_Continue : std_logic; -- Continue signal to button
	signal m_SOP : std_logic; -- START OF PROGRAM signal to button
	signal mclk : std_logic; -- clock de 1s
	
	
	
	signal display_enabled: std_logic; -- enable do display 7 seg
		
	signal IR_BUS : std_logic_vector(15 downto 0) := "0000000000000000"; -- barramento de instruoes
	signal P_BUS  : std_logic_vector(7 downto 0)  := "00000000";			-- barramento de enderaameno PC -> MAR
	signal A_BUS  : std_logic_vector(7 downto 0)  := "00000000";			-- barramento de endereamento MAR -> RAM
	signal D_BUS  : std_logic_vector(15 downto 0) := "0000000000000000"; -- barramento de dados da RAM
	signal ES_BUS : std_logic_vector(15 downto 0) ; -- barramento de E/S
	signal DATA	  : std_logic_vector(15 downto 0) := "0000000000000000";	-- CHIP SELETOR -> RAM
	signal M_Z_PC, M_I_PC, M_T_PC, M_T_IR, M_T_BUS, M_R_M, M_W_M, M_Z_MAR, M_I_MAR : std_logic := '0'; -- sinais de controle
	signal M_R_A, M_W_A, M_Z_A : std_logic := '0'; -- sinais de controle (nao utilizados no modulo de busca)
	
	signal IR_BUS_CTRL : std_logic_vector(7 downto 0); -- LSB 8 bits de IR_BUS (CTRL & ULA)
	signal IR_BUS_MAR : std_logic_vector(7 downto 0); 	-- MSB 8 bits de IR_BUS (MAR)
	
	--//segunda entrega//
	signal M_W_T : std_logic := '0'; -- CTRL -> REG_T
	signal M_REG_A_RFEED : std_logic := '0'; -- REG_A -> ULA (realimentacao)
	signal M_REG_T : std_logic := '0'; -- REG_T -> ULA
	signal M_REG_A : std_logic := '0'; -- ULA -> REG_A
	signal M_REG_A_OUT : std_logic := '0'; -- REG_A -> SYSTEM OUTPUT
	signal Q_REG_A : std_logic := '0'; -- buffer port of reg_a
	
	--signal D_BUS_RAM 	 : std_logic_vector (15 downto 0) := "0000000000000000"; -- gambiarra: this will be copied from RAM to tristate bus
	--signal D_BUS_A_REG : std_logic_vector (15 downto 0) := "0000000000000000"; -- gambiarra: this will have last bit changed by reg_a
	
	-- barramentos convertidos em ASCII
	signal IR_BUS_ASCII_1 : std_logic_vector(7 downto 0);
	signal IR_BUS_ASCII_2 : std_logic_vector(7 downto 0);
	signal IR_BUS_ASCII_3 : std_logic_vector(7 downto 0);
	signal IR_BUS_ASCII_4 : std_logic_vector(7 downto 0);
	signal P_BUS_ASCII_1 : std_logic_vector(7 downto 0);
	signal P_BUS_ASCII_2 : std_logic_vector(7 downto 0);
	signal MAR_BUS_ASCII_1 : std_logic_vector(7 downto 0);
	signal MAR_BUS_ASCII_2 : std_logic_vector(7 downto 0);
	signal A_BUS_ASCII_1 : std_logic_vector(7 downto 0);
	signal D_BUS_ASCII_1 : std_logic_vector(7 downto 0);
	signal T_BUS_ASCII_1	: std_logic_vector(7 downto 0);
	
	signal MA_PROG : std_logic_vector(7 downto 0);
	
	signal M_RD_ES : std_logic := '0'; -- MASTERCTRL -> PES
	signal M_WR_ES : std_logic := '0'; -- MASTERCTRL -> PES
	signal M_START : std_logic := '0'; -- MASTERCTRL -> DELAY
	signal M_TOUT : std_logic := '0';	-- DELAY -> MASTERCTRL
	
	--signal din_SOP : std_logic;
	--signal dout_SOP : std_logic;
	--signal din_EOP : std_logic;
	--signal dout_EOP : std_logic;
	
	signal M_W_M_ctrl : std_logic := '0'; 
	signal M_R_M_ctrl : std_logic := '0';
	
	signal M_W_M_master : std_logic := '0'; 
	signal M_R_M_master : std_logic := '0';
	
	signal test : std_logic_vector(5 downto 0):= "000000";
	signal mrx_btn : std_logic := '0';
	
begin
  
  
	
	m_Continue <= not(m_Continue_btn); -- botoes do fpga sao ativos em sinal zero, portanto devemos reverter as entradas
	m_SOP <= not(m_SOP_btn);
	mrx_btn <= m_rx;
	
	
	M_W_M <= (M_W_M_ctrl) OR (M_W_M_master);
	M_R_M <= (M_R_M_ctrl) OR (M_R_M_master);
	
	-- OBS: m_Continue esta temporariamente alocado como reset interno do sistema

	IR_BUS_CTRL <= IR_BUS(15 downto 8);
	IR_BUS_MAR  <= IR_BUS(7 downto 0);
	
	m_IPC 	<= M_I_PC;
	m_TPC		<= M_T_PC;
	m_TBUS	<= M_T_BUS;
	m_RM		<= M_R_M;
      
  clk_watch <= mclk;
  
  
	--flag <= D_BUS(0);
	
	-- associando e interconectando os outputs e inputs dos componentes a outros componentes ou a saida/entrada do sistema
	--DBC1: Debounce port map (mclk_in, m_SOP_btn, m_SOP); -- debounce do SOP (m_SOP estavel)
	--DBC2: Debounce port map (mclk_in, m_Continue_btn , m_Continue); -- debounce do Continue (m_Continue estavel)
	--DIV:  divisor_freq_1hz port map(mclk_in, m_SOP , mclk); -- divisor de frequencia(mclk - clock de 1s)
	
	
	mclk <= mclk_in;  
	
	
	DP_7: display_7seg port map(mclk_in, m_prog, display_enabled, ktodos, display_in); 
	
	
	
	PC1:  contador_programa port map (m_prog, m_EOP, M_I_PC, mclk, P_BUS); 
	
	
	MAR1: registrador_enderecamento port map(IR   => IR_BUS_MAR, 
														  P 	 => P_BUS, 
														  t_pc => M_T_PC,
														  t_ir => M_T_IR, 
														  z_mar=> M_Z_MAR,
														  i_mar=> M_I_MAR, 
														  clk  => mclk,
														  A	 => A_BUS
	);
	
	
	
	IR1: 	registrador_instrucao port map (D_BUS, M_T_BUS, mclk, IR_BUS);
	
	
	RAM1: single_port_ram port map (data    => DATA,
											  addr_in => A_BUS, 
											  w_m 	 => M_W_M, 
											  r_m		 => M_R_M, 
											  clk		 => mclk, 
											  q 		 => D_BUS); -- o barramento de entrada eh o mesmo de saida na RAM 
											  
											  
	--CTRL_S: controlador_escravo port map(mclk, m_SOP, m_Continue, IR_BUS_CTRL, m_EOP, M_I_PC, M_Z_PC, M_T_PC, M_T_IR, M_T_BUS, M_R_A, M_W_A, M_Z_A, M_R_M_ctrl, M_W_M_ctrl, M_W_T);
	
	
	CTRL_S: controlador_escravo port map(clk => mclk,
													 SOP => m_SOP,
													 Continue => m_Continue,
													 IR => IR_BUS_CTRL,
													 EOP => m_EOP,
													 I_PC => M_I_PC,
													 Z_PC => M_Z_PC,
													 T_PC => M_T_PC,
													 T_IR => M_T_IR,
													 T_BUS => M_T_BUS,
													 R_A => M_R_A,
													 W_A => M_W_A,
													 Z_A => M_Z_A,
													 R_M => M_R_M_ctrl,
													 W_M => M_W_M_ctrl,
													 W_T => M_W_T
	);
	
	MASTERCTRL : controlador_mestre port map(clk => mclk,
														  SOP => m_SOP, -- if need arises, make SOP reach the controller before being transmitted to the ff
														  tout => M_TOUT,
														  EOP => m_EOP,
														  RD_ES => M_RD_ES,
														  WR_ES => M_WR_ES,
														  RST_MAR => M_Z_MAR,
														  INC_MAR => M_I_MAR,
														  WR_M => M_W_M_master,
														  RD_M => M_R_M_master,
														  START => M_START,
														  RX => mrx_btn
	);
	
	PES1 : porta_es port map(clk => mclk,
									 RD_ES => M_RD_ES,
									 WR_ES => M_WR_ES,
									 I => m_I,
									 D => ES_BUS,	
									 DATA_IN => D_BUS,
									 ADDR => A_BUS,
									 Q => Q
	);
													 
													 
		
	-- //segunda entrega// DEAKTIVOITU TESTAUKSEEN
	ULA1 : ULA port map(M_REG_T, M_REG_A_RFEED, IR_BUS_CTRL, M_REG_A);
	
	
	REG_A1 : registrador_A port map(M_REG_A, M_R_A, M_W_A, m_SOP, mclk, Q_REG_A, M_REG_A_OUT);
	
	
	REG_T1 :	registrador_temporario port map(D_BUS(0), M_W_T, m_SOP, mclk, M_REG_T);
	
	
	
	CS1 : chip_seletor port map(REG_A	=> Q_REG_A,
										  ES	   => ES_BUS,
		                      	  r_a		=> M_R_A,
										  r_es   => M_RD_ES,
			                       clk    => mclk,
			                       A		=> DATA
	);
	
	
	
	CS2 : chip_seletor2 port map(REG_A	 => Q_REG_A,
										  D_BUS   => D_BUS(0),
										  r_a   	 => M_R_A,		
										  r_m     => M_R_M,
										  clk 	 => mclk,
										  A		 => flag
	); 
	
	
	
	
	
	DELAY1 : scan_delay port map(start => M_START,
									  clk => mclk,
									  sw => sw,
									  tout => M_TOUT
	);
	
	--FFD1 : D_FF port map(clk => mclk,
	--							sop_in => m_SOP,
	--							eop_in => m_EOP,
	--							sop_out => dout_SOP,
	--							eop_out => dout_EOP
	--);
	
	
														  
	
	
	
	
	LCD: LCD_FPGA port map(fsd_Clk => mclk_in, 
								  fsd_Reset	=>	'1', 
								  fsd_AtivaEscrita => '0', 
								  fsd_RS	=>	RS, 
								  fsd_RW =>	RW,
								  fsd_E	=>	E,  
								  fsd_Dados => DB,
								  -- todos os sinais ficaram ao contrario durante a conversao
								  data_ir_out_1 => IR_BUS_ASCII_4,
								  data_ir_out_2 => IR_BUS_ASCII_3,		
								  data_ir_out_3 => IR_BUS_ASCII_2,		
								  data_ir_out_4 => IR_BUS_ASCII_1,		
								  data_pc_out_1 => P_BUS_ASCII_2,		
								  data_pc_out_2 => P_BUS_ASCII_1,		
								  data_mar_out_1 => MAR_BUS_ASCII_2,		
							  	  data_mar_out_2 => MAR_BUS_ASCII_1,
								  data_d_out => D_BUS_ASCII_1,				
								  data_t_out => T_BUS_ASCII_1,				
								  data_a_out => A_BUS_ASCII_1				
	); 
	
	CONV: conversor_ascii port map(data_ir => IR_BUS,
											 data_pc => P_BUS,
											 data_mar => A_BUS,
											 data_d => D_BUS(0),
											 data_t => M_REG_T,
											 data_a => M_REG_A_OUT,
											 clk => mclk_in,			
											 -- the data below are the ascII characters converted from the entry signals above 
											 data_ir_out_1 => IR_BUS_ASCII_1,
											 data_ir_out_2 => IR_BUS_ASCII_2, 
											 data_ir_out_3 => IR_BUS_ASCII_3,
											 data_ir_out_4 => IR_BUS_ASCII_4,
											 data_pc_out_1 => P_BUS_ASCII_1,	
											 data_pc_out_2 => P_BUS_ASCII_2,	
											 data_mar_out_1 => MAR_BUS_ASCII_1,
											 data_mar_out_2 => MAR_BUS_ASCII_2,
											 data_d_out => D_BUS_ASCII_1,
											 data_t_out => T_BUS_ASCII_1,
											 data_a_out => A_BUS_ASCII_1
	);
	-- sinais do controlador para visualizaao
	

end clp;
