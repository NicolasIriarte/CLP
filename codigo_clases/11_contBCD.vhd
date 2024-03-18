library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity contBCD is
	port(
		clk_i: in std_logic;
		rst_i: in std_logic;
		ena_i: in std_logic;
		s_o: out std_logic_vector(3 downto 0)
	);
end;

architecture contBCD_arq of contBCD is

	component reg is
		generic(
			N: natural := 4
		);
		port(
			clk_i: in std_logic;
			rst_i: in std_logic;
			ena_i: in std_logic;
			d_i: in std_logic_vector(N-1 downto 0);
			q_o: out std_logic_vector(N-1 downto 0)
		);
	end component;
	
	signal salComp: std_logic;
	signal salMux: std_logic_vector(3 downto 0);
	signal salReg: std_logic_vector(3 downto 0);
	signal salInc: std_logic_vector(3 downto 0);
		
	signal rst_aux: std_logic;
	
begin

	rst_aux <= (salComp or rst_i);
	
	inst_registro: reg
		generic map(
			N => 4
		)
		port map(
			clk_i => clk_i,
			rst_i => rst_aux,
			ena_i => '1',
			d_i   => salMux,
			q_o   => salReg
		);
		
	-- Multiplexer
	salMux <= salInc when ena_i = '1' else salReg;
	
	-- Comparador
	salComp <= salReg(3) and not salReg(2) and not salReg(1) and salReg(0) and ena_i; -- "1001"
	
	salInc <= std_logic_vector(unsigned(salReg) + 1);
	
	s_o <= salReg;
 		
end;